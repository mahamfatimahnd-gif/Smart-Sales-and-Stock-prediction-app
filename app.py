from flask import Flask, request, jsonify
from flask_cors import CORS

import pandas as pd
import numpy as np
import os
import time

from sklearn.ensemble import GradientBoostingRegressor, RandomForestRegressor
from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.metrics import r2_score, mean_absolute_error, mean_absolute_percentage_error

app = Flask(__name__)
CORS(app)

print(" RETAIL ML RUNNING - FORCE RELOAD ENABLED")

# =========================================================
# CONFIGURATION
# =========================================================
DATA_FILE = "Sales_Dataset_With_Appended_Yearly_Summary.xlsx"
last_modified_time = 0

# Global variables
gb_model = None
rf_model = None
scaler = None
cat_enc = None
prod_enc = None
season_enc = None
month_map = None
accuracy_percent = 0
accuracy_r2 = 0
accuracy_mae = 0
current_df = None
monthly_multipliers = {}  # Store seasonal patterns per product

# =========================================================
# MONTH MAP
# =========================================================
import calendar

month_map = {month: i for i, month in enumerate(calendar.month_name) if month}
month_names = list(month_map.keys())

# Typical seasonal multipliers (for products without enough history)
DEFAULT_MONTHLY_MULTIPLIERS = {
    "January": 0.85, "February": 0.85, "March": 0.95,
    "April": 0.95, "May": 1.0, "June": 1.0,
    "July": 1.0, "August": 1.05, "September": 1.1,
    "October": 1.15, "November": 1.2, "December": 1.3
}

# =========================================================
# FUNCTION TO FORCE RELOAD EXCEL (NO CACHE)
# =========================================================
def force_reload_excel():
    """Force reload Excel file - no caching whatsoever"""
    if not os.path.exists(DATA_FILE):
        raise FileNotFoundError(f"Dataset '{DATA_FILE}' not found")
    
    print("🔄 FORCE RELOADING Excel file...")
    df = pd.read_excel(DATA_FILE)
    df.columns = df.columns.str.strip()
    print(f" Loaded {len(df)} rows from Excel")
    return df

# =========================================================
# FUNCTION TO CLEAN DATA (ALWAYS FRESH)
# =========================================================
def clean_data(df_to_clean):
    """Clean and prepare dataframe"""
    df_clean = df_to_clean.copy()
    
    # Remove summary rows
    df_clean = df_clean[df_clean["Category"].notna()]
    df_clean = df_clean[df_clean["Category"] != ""]
    df_clean = df_clean[df_clean["Category"].astype(str).str.strip() != "nan"]
    
    # Convert to string and strip whitespace
    df_clean["Category"] = df_clean["Category"].astype(str).str.strip()
    df_clean["Product Name"] = df_clean["Product Name"].astype(str).str.strip()
    df_clean["Month"] = df_clean["Month"].astype(str).str.strip()
    df_clean["Season"] = df_clean["Season"].astype(str).str.strip()
    
    # Convert numeric columns
    df_clean["Units Sold"] = pd.to_numeric(df_clean["Units Sold"], errors="coerce").fillna(0)
    df_clean["Year"] = pd.to_numeric(df_clean["Year"], errors="coerce").fillna(0).astype(int)
    df_clean["Price Per Unit"] = pd.to_numeric(df_clean["Price Per Unit"], errors="coerce").fillna(500)
    df_clean["Cost Price"] = pd.to_numeric(df_clean["Cost Price"], errors="coerce").fillna(0)
    df_clean["Total Sales"] = pd.to_numeric(df_clean["Total Sales"], errors="coerce").fillna(0)
    
    # Remove invalid rows
    df_clean = df_clean[df_clean["Price Per Unit"] > 0]
    df_clean = df_clean[df_clean["Year"] >= 2020]
    df_clean = df_clean[df_clean["Year"] <= 2030]
    
    # Add month encoding
    df_clean["MonthEncoded"] = df_clean["Month"].map(month_map)
    df_clean = df_clean.dropna(subset=["MonthEncoded"])
    df_clean["MonthEncoded"] = df_clean["MonthEncoded"].astype(int)
    
    # Sort data
    df_clean = df_clean.sort_values(["Product Name", "Year", "MonthEncoded"]).reset_index(drop=True)
    
    return df_clean

# =========================================================
# CALCULATE MONTHLY MULTIPLIERS PER PRODUCT
# =========================================================
def calculate_monthly_multipliers(df):
    """Calculate seasonal multipliers for each product"""
    global monthly_multipliers
    
    monthly_multipliers = {}
    
    for product in df["Product Name"].unique():
        product_data = df[df["Product Name"] == product].copy()
        
        # Calculate average units per month
        monthly_avg = product_data.groupby("Month")["Units Sold"].mean()
        overall_avg = product_data["Units Sold"].mean()
        
        if overall_avg > 0:
            multipliers = {month: (monthly_avg.get(month, overall_avg) / overall_avg) for month in month_names}
        else:
            multipliers = DEFAULT_MONTHLY_MULTIPLIERS.copy()
        
        monthly_multipliers[product] = multipliers
    
    print(f"📊 Calculated seasonal multipliers for {len(monthly_multipliers)} products")

# =========================================================
# FUNCTION TO RETRAIN MODEL (ALWAYS FRESH)
# =========================================================
def retrain_model():
    global gb_model, rf_model, scaler, cat_enc, prod_enc, season_enc
    global accuracy_percent, accuracy_r2, accuracy_mae, current_df
    
    print("🔄 RETRAINING MODEL with fresh data...")
    
    # FORCE reload Excel - no cache
    fresh_df = force_reload_excel()
    df_clean = clean_data(fresh_df)
    current_df = df_clean
    
    # Calculate seasonal multipliers
    calculate_monthly_multipliers(df_clean)
    
    print(f"📊 Cleaned data: {len(df_clean)} rows")
    print(f"📅 Years: {sorted(df_clean['Year'].unique())}")
    
    # Label encoders
    cat_enc = LabelEncoder()
    prod_enc = LabelEncoder()
    season_enc = LabelEncoder()
    
    df_clean["CategoryEncoded"] = cat_enc.fit_transform(df_clean["Category"].astype(str))
    df_clean["ProductEncoded"] = prod_enc.fit_transform(df_clean["Product Name"].astype(str))
    df_clean["SeasonEncoded"] = season_enc.fit_transform(df_clean["Season"].astype(str))
    
    # Feature engineering
    df_clean["MonthSin"] = np.sin(2 * np.pi * df_clean["MonthEncoded"] / 12)
    df_clean["MonthCos"] = np.cos(2 * np.pi * df_clean["MonthEncoded"] / 12)
    
    # Add seasonal multiplier as a feature
    df_clean["SeasonalMultiplier"] = df_clean.apply(
        lambda row: monthly_multipliers.get(row["Product Name"], DEFAULT_MONTHLY_MULTIPLIERS).get(row["Month"], 1.0),
        axis=1
    )
    
    # Lag features
    df_clean["Prev1Units"] = df_clean.groupby("Product Name")["Units Sold"].shift(1)
    df_clean["Prev2Units"] = df_clean.groupby("Product Name")["Units Sold"].shift(2)
    df_clean["Prev3Units"] = df_clean.groupby("Product Name")["Units Sold"].shift(3)
    df_clean["Prev12Units"] = df_clean.groupby("Product Name")["Units Sold"].shift(12)
    
    df_clean["Rolling3Units"] = df_clean.groupby("Product Name")["Units Sold"].transform(
        lambda x: x.rolling(3, min_periods=1).mean()
    )
    df_clean["Rolling6Units"] = df_clean.groupby("Product Name")["Units Sold"].transform(
        lambda x: x.rolling(6, min_periods=1).mean()
    )
    df_clean["Rolling12Units"] = df_clean.groupby("Product Name")["Units Sold"].transform(
        lambda x: x.rolling(12, min_periods=1).mean()
    )
    
    df_clean["PriceChange"] = df_clean.groupby("Product Name")["Price Per Unit"].diff(1)
    df_clean["PriceRolling3"] = df_clean.groupby("Product Name")["Price Per Unit"].transform(
        lambda x: x.rolling(3, min_periods=1).mean()
    )
    
    df_clean["TimeIndex"] = df_clean.groupby("Product Name").cumcount()
    
    # Fill NaN values
    product_mean_units = df_clean.groupby("Product Name")["Units Sold"].transform("mean")
    
    for col in ["Prev1Units", "Prev2Units", "Prev3Units", "Prev12Units", 
                "Rolling3Units", "Rolling6Units", "Rolling12Units"]:
        df_clean[col] = df_clean[col].fillna(product_mean_units)
    
    df_clean["PriceChange"] = df_clean["PriceChange"].fillna(0)
    df_clean["PriceRolling3"] = df_clean["PriceRolling3"].fillna(df_clean["Price Per Unit"])
    df_clean = df_clean.fillna(0)
    
    # Features - INCLUDING SeasonalMultiplier
    features = [
        "CategoryEncoded", "ProductEncoded", "MonthEncoded",
        "MonthSin", "MonthCos", "SeasonEncoded",
        "Prev1Units", "Prev2Units", "Prev3Units", "Prev12Units",
        "Rolling3Units", "Rolling6Units", "Rolling12Units",
        "TimeIndex", "Price Per Unit", "Cost Price",
        "PriceChange", "PriceRolling3", "SeasonalMultiplier"  # ADDED
    ]
    
    X = df_clean[features].astype(float)
    y = df_clean["Units Sold"].astype(float)
    
    # Split data
    split_index = int(len(df_clean) * 0.8)
    X_train = X.iloc[:split_index]
    X_test = X.iloc[split_index:]
    y_train = y.iloc[:split_index]
    y_test = y.iloc[split_index:]
    
    # Scale features
    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)
    
    # Train models
    print("Training Gradient Boosting...")
    gb_model = GradientBoostingRegressor(
        n_estimators=500, learning_rate=0.05, max_depth=6,  # Increased depth
        min_samples_split=5, min_samples_leaf=3, subsample=0.8, random_state=42
    )
    gb_model.fit(X_train_scaled, y_train)
    
    print("Training Random Forest...")
    rf_model = RandomForestRegressor(
        n_estimators=500, max_depth=12,  # Increased depth
        min_samples_split=5, min_samples_leaf=2, random_state=42, n_jobs=-1
    )
    rf_model.fit(X_train_scaled, y_train)
    
    # Ensemble predictions
    gb_preds = gb_model.predict(X_test_scaled)
    rf_preds = rf_model.predict(X_test_scaled)
    ensemble_preds = (gb_preds + rf_preds) / 2
    
    # Metrics
    accuracy_r2 = r2_score(y_test, ensemble_preds)
    accuracy_mae = mean_absolute_error(y_test, ensemble_preds)
    accuracy_mape = mean_absolute_percentage_error(y_test, ensemble_preds)
    accuracy_percent = max(0, 100 - (accuracy_mape * 100))
    
    print(f"\n{'='*50}")
    print(f" MODEL PERFORMANCE (After Retrain)")
    print(f"{'='*50}")
    print(f"R² Score: {round(accuracy_r2, 4)}")
    print(f"MAE: {round(accuracy_mae, 2)} units")
    print(f"MAPE: {round(accuracy_mape * 100, 1)}%")
    print(f"Accuracy: {round(accuracy_percent, 1)}%")
    print(f"{'='*50}\n")
    
    return df_clean

# =========================================================
# INITIAL TRAINING
# =========================================================
print("Initial training...")
current_df = retrain_model()
print(" Ready! Use /reload to force reload Excel and retrain")

# =========================================================
# HELPER FUNCTIONS (ALWAYS GET FRESH PRICE)
# =========================================================
def get_latest_price(product_name):
    """Always get latest price directly from Excel"""
    fresh_df = force_reload_excel()
    fresh_clean = clean_data(fresh_df)
    
    filtered = fresh_clean[fresh_clean["Product Name"].str.lower() == product_name.lower()]
    
    if filtered.empty:
        print(f" Product '{product_name}' not found, using default price 500")
        return 500.0
    
    filtered = filtered.sort_values(["Year", "MonthEncoded"], ascending=True)
    latest_price = float(filtered.iloc[-1]["Price Per Unit"])
    
    print(f" {product_name} latest price: ₹{latest_price}")
    return latest_price if latest_price > 0 else 500.0

def get_latest_cost(product_name):
    """Always get latest cost directly from Excel"""
    fresh_df = force_reload_excel()
    fresh_clean = clean_data(fresh_df)
    
    filtered = fresh_clean[fresh_clean["Product Name"].str.lower() == product_name.lower()]
    
    if filtered.empty:
        return 325.0
    
    filtered = filtered.sort_values(["Year", "MonthEncoded"], ascending=True)
    latest_cost = float(filtered.iloc[-1]["Cost Price"])
    
    return latest_cost if latest_cost > 0 else 325.0

def get_monthly_multiplier(product_name, month):
    """Get seasonal multiplier for a product in a specific month"""
    if product_name in monthly_multipliers:
        return monthly_multipliers[product_name].get(month, 1.0)
    return DEFAULT_MONTHLY_MULTIPLIERS.get(month, 1.0)

# =========================================================
# ROUTES
# =========================================================
@app.route("/")
def home():
    return jsonify({
        "status": "RUNNING",
        "accuracy": round(accuracy_percent, 2),
        "r2_score": round(accuracy_r2, 4),
        "rows": int(len(current_df)) if current_df is not None else 0
    })

@app.route("/yearly_summary")
def yearly_summary():
    try:
        fresh_df = force_reload_excel()
        fresh_clean = clean_data(fresh_df)
        
        if "Cost Price" not in fresh_clean.columns:
            fresh_clean["Cost Price"] = fresh_clean["Price Per Unit"] * 0.65
        
        fresh_clean["Total Cost"] = fresh_clean["Units Sold"] * fresh_clean["Cost Price"]
        
        grouped = fresh_clean.groupby("Year", as_index=False).agg({
            "Units Sold": "sum",
            "Total Cost": "sum",
            "Total Sales": "sum"
        })
        
        grouped = grouped.sort_values("Year")
        
        years_list = [int(y) for y in grouped["Year"].tolist()]
        units_list = [float(u) for u in grouped["Units Sold"].tolist()]
        cost_list = [float(c) for c in grouped["Total Cost"].tolist()]
        sales_list = [float(s) for s in grouped["Total Sales"].tolist()]
        
        total_units = sum(units_list)
        total_cost = sum(cost_list)
        total_sales = sum(sales_list)
        
        return jsonify({
            "years": years_list,
            "units": units_list,
            "cost": cost_list,
            "sales": sales_list,
            "summary": {
                "total_units": total_units,
                "total_cost": total_cost,
                "total_sales": total_sales,
                "profit": total_sales - total_cost
            }
        })
        
    except Exception as e:
        print(f"ERROR: {e}")
        return jsonify({
            "years": [],
            "units": [],
            "cost": [],
            "sales": [],
            "summary": {
                "total_units": 0,
                "total_cost": 0,
                "total_sales": 0,
                "profit": 0
            }
        })

@app.route("/categories")
def categories():
    fresh_df = force_reload_excel()
    fresh_clean = clean_data(fresh_df)
    return jsonify({
        "categories": sorted(fresh_clean["Category"].unique().tolist())
    })

@app.route("/months")
def months():
    return jsonify({
        "months": list(month_map.keys())
    })

@app.route("/products")
def products():
    category = request.args.get("category", "").strip().lower()
    fresh_df = force_reload_excel()
    fresh_clean = clean_data(fresh_df)
    
    filtered = fresh_clean[fresh_clean["Category"].str.lower() == category]
    
    return jsonify({
        "products": sorted(filtered["Product Name"].unique().tolist())
    })

@app.route("/product_price")
def product_price():
    product = request.args.get("product", "").strip()
    price = get_latest_price(product)
    cost = get_latest_cost(product)
    
    return jsonify({
        "product": product,
        "price": float(price),
        "cost": float(cost),
        "profit_margin": round(((price - cost) / price) * 100, 1) if price > 0 else 0
    })

@app.route("/predict", methods=["POST"])
def predict():
    try:
        data = request.get_json()
        
        category = (data.get("category") or "").strip().lower()
        product = (data.get("product") or "").strip().lower()
        month = (data.get("month") or "").strip()
        
        # Get fresh data for prediction
        fresh_df = force_reload_excel()
        fresh_clean = clean_data(fresh_df)
        
        cat_match = next((c for c in cat_enc.classes_ if c.lower().strip() == category), None)
        prod_match = next((p for p in prod_enc.classes_ if p.lower().strip() == product), None)
        
        if not cat_match or not prod_match:
            return jsonify({"error": "Invalid category/product"}), 400
        
        c_code = cat_enc.transform([cat_match])[0]
        p_code = prod_enc.transform([prod_match])[0]
        m_code = month_map.get(month, 1)
        
        # Get product history from fresh data
        history = fresh_clean[fresh_clean["Product Name"].str.lower() == product]
        
        if history.empty:
            return jsonify({"error": "No history found"}), 400
        
        history = history.sort_values(["Year", "MonthEncoded"]).reset_index(drop=True)
        
        # Calculate features
        latest_row = history.iloc[-1]
        time_index = len(history)
        
        prev1 = float(history["Units Sold"].iloc[-1]) if len(history) > 0 else 0
        prev2 = float(history["Units Sold"].iloc[-2]) if len(history) > 1 else prev1
        prev3 = float(history["Units Sold"].iloc[-3]) if len(history) > 2 else prev1
        prev12 = float(history["Units Sold"].iloc[-12]) if len(history) > 11 else prev1
        
        rolling3 = float(history["Units Sold"].tail(3).mean())
        rolling6 = float(history["Units Sold"].tail(6).mean()) if len(history) > 5 else rolling3
        rolling12 = float(history["Units Sold"].tail(12).mean()) if len(history) > 11 else rolling3
        
        price_val = float(latest_row["Price Per Unit"])
        cost_val = float(latest_row["Cost Price"])
        price_change = price_val - (float(history["Price Per Unit"].iloc[-2]) if len(history) > 1 else price_val)
        price_rolling3 = float(history["Price Per Unit"].tail(3).mean())
        
        season_encoded = season_enc.transform([latest_row["Season"]])[0]
        
        # Get seasonal multiplier for this month
        seasonal_multiplier = get_monthly_multiplier(prod_match, month)
        
        # Create feature vector
        X_input = pd.DataFrame([{
            "CategoryEncoded": int(c_code),
            "ProductEncoded": int(p_code),
            "MonthEncoded": m_code,
            "MonthSin": np.sin(2 * np.pi * m_code / 12),
            "MonthCos": np.cos(2 * np.pi * m_code / 12),
            "SeasonEncoded": int(season_encoded),
            "Prev1Units": prev1,
            "Prev2Units": prev2,
            "Prev3Units": prev3,
            "Prev12Units": prev12,
            "Rolling3Units": rolling3,
            "Rolling6Units": rolling6,
            "Rolling12Units": rolling12,
            "TimeIndex": time_index,
            "Price Per Unit": price_val,
            "Cost Price": cost_val,
            "PriceChange": price_change,
            "PriceRolling3": price_rolling3,
            "SeasonalMultiplier": seasonal_multiplier  # ADDED
        }])
        
        # Scale features
        X_input_scaled = scaler.transform(X_input)
        
        # Ensemble prediction
        gb_pred = gb_model.predict(X_input_scaled)[0]
        rf_pred = rf_model.predict(X_input_scaled)[0]
        predicted_units = (gb_pred + rf_pred) / 2
        predicted_units = max(0, predicted_units)
        
        # Get latest price and cost directly from Excel
        price = get_latest_price(product)
        cost = get_latest_cost(product)
        predicted_sales = predicted_units * price
        predicted_profit = predicted_units * (price - cost)
        profit_rate = (predicted_profit / predicted_sales) * 100 if predicted_sales > 0 else 0
        
        # Get predictions for all months for comparison
        monthly_predictions = {}
        for test_month in month_names:
            test_month_code = month_map[test_month]
            test_multiplier = get_monthly_multiplier(prod_match, test_month)
            
            X_test_input = pd.DataFrame([{
                "CategoryEncoded": int(c_code),
                "ProductEncoded": int(p_code),
                "MonthEncoded": test_month_code,
                "MonthSin": np.sin(2 * np.pi * test_month_code / 12),
                "MonthCos": np.cos(2 * np.pi * test_month_code / 12),
                "SeasonEncoded": int(season_encoded),
                "Prev1Units": prev1,
                "Prev2Units": prev2,
                "Prev3Units": prev3,
                "Prev12Units": prev12,
                "Rolling3Units": rolling3,
                "Rolling6Units": rolling6,
                "Rolling12Units": rolling12,
                "TimeIndex": time_index,
                "Price Per Unit": price_val,
                "Cost Price": cost_val,
                "PriceChange": price_change,
                "PriceRolling3": price_rolling3,
                "SeasonalMultiplier": test_multiplier
            }])
            
            X_test_scaled = scaler.transform(X_test_input)
            gb_test_pred = gb_model.predict(X_test_scaled)[0]
            rf_test_pred = rf_model.predict(X_test_scaled)[0]
            test_pred = max(0, (gb_test_pred + rf_test_pred) / 2)
            monthly_predictions[test_month] = round(test_pred, 2)
        
        return jsonify({
            "predicted_units": round(predicted_units, 2),
            "predicted_sales": round(predicted_sales, 2),
            "predicted_profit": round(predicted_profit, 2),
            "price_used": float(price),
            "cost_used": float(cost),
            "profit_rate": round(profit_rate, 1),
            "accuracy": round(accuracy_percent, 2),
            "r2_score": round(accuracy_r2, 4),
            "latest_units": prev1,
            "rolling_avg": rolling3,
            "seasonal_multiplier": round(seasonal_multiplier, 2),
            "monthly_predictions": monthly_predictions,  # ADDED - shows variation across months
            "history_months": (history["Year"].astype(str) + "-" + history["Month"]).tolist(),
            "history_units": [float(u) for u in history["Units Sold"].tolist()],
            "history_sales": [float(s) for s in history["Total Sales"].tolist()]
        })
        
    except Exception as e:
        print("ERROR:", e)
        import traceback
        traceback.print_exc()
        return jsonify({"error": str(e)}), 500

@app.route("/reload")
def force_reload():
    """Force reload Excel and retrain model"""
    global current_df
    print("\n" + "="*50)
    print(" FORCE RELOAD TRIGGERED")
    print("="*50)
    current_df = retrain_model()
    return jsonify({
        "message": "Data reloaded and model retrained successfully",
        "accuracy": round(accuracy_percent, 2),
        "rows": int(len(current_df))
    })

@app.route("/debug_years")
def debug_years():
    fresh_df = force_reload_excel()
    fresh_clean = clean_data(fresh_df)
    years = [int(y) for y in sorted(fresh_clean["Year"].unique())]
    
    sugar_data = fresh_clean[fresh_clean["Product Name"].str.contains("Sugar", case=False)]
    sugar_price = float(sugar_data.iloc[-1]["Price Per Unit"]) if not sugar_data.empty else None
    
    return jsonify({
        "years_available": years,
        "total_rows": int(len(fresh_clean)),
        "sugar_latest_price": sugar_price,
        "message": "Excel file reloaded successfully"
    })

@app.route("/debug_product/<product_name>")
def debug_product(product_name):
    """Debug endpoint to check a specific product's latest price"""
    fresh_df = force_reload_excel()
    fresh_clean = clean_data(fresh_df)
    
    filtered = fresh_clean[fresh_clean["Product Name"].str.lower() == product_name.lower()]
    
    if filtered.empty:
        return jsonify({"error": f"Product '{product_name}' not found"}), 404
    
    filtered = filtered.sort_values(["Year", "MonthEncoded"], ascending=True)
    latest = filtered.iloc[-1]
    
    return jsonify({
        "product": product_name,
        "latest_price": float(latest["Price Per Unit"]),
        "latest_cost": float(latest["Cost Price"]),
        "latest_year": int(latest["Year"]),
        "latest_month": latest["Month"],
        "total_records": len(filtered)
    })

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
