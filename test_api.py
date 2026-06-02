import unittest
import json
from app import app

class TestInventoryAPI(unittest.TestCase):
    
    def setUp(self):
        """Setup before each test"""
        self.app = app.test_client()
        self.app.testing = True
    
    # =========================================================
    # TEST 1: Home endpoint
    # =========================================================
    def test_home_endpoint(self):
        response = self.app.get('/')
        data = json.loads(response.data)
        
        self.assertEqual(response.status_code, 200)
        self.assertIn('status', data)
        self.assertIn('accuracy', data)
        print("✅ Home endpoint working")
    
    # =========================================================
    # TEST 2: Categories endpoint
    # =========================================================
    def test_categories_endpoint(self):
        response = self.app.get('/categories')
        data = json.loads(response.data)
        
        self.assertEqual(response.status_code, 200)
        self.assertIn('categories', data)
        self.assertTrue(len(data['categories']) > 0)
        print("✅ Categories endpoint working")
    
    # =========================================================
    # TEST 3: Products endpoint with category
    # =========================================================
    def test_products_endpoint(self):
        response = self.app.get('/products?category=Groceries')
        data = json.loads(response.data)
        
        self.assertEqual(response.status_code, 200)
        self.assertIn('products', data)
        print("✅ Products endpoint working")
    
    # =========================================================
    # TEST 4: Product price endpoint
    # =========================================================
    def test_product_price_endpoint(self):
        response = self.app.get('/product_price?product=Rice Bag')
        data = json.loads(response.data)
        
        self.assertEqual(response.status_code, 200)
        self.assertIn('price', data)
        self.assertGreater(data['price'], 0)
        print("✅ Product price endpoint working")
    
    # =========================================================
    # TEST 5: Predict endpoint (VALID input)
    # =========================================================
    def test_predict_valid_input(self):
        test_data = {
            "category": "Groceries",
            "product": "Rice Bag",
            "month": "January",
            "price": 2400
        }
        
        response = self.app.post('/predict',
            data=json.dumps(test_data),
            content_type='application/json'
        )
        data = json.loads(response.data)
        
        self.assertEqual(response.status_code, 200)
        self.assertIn('predicted_units', data)
        self.assertGreater(data['predicted_units'], 0)
        print("✅ Predict endpoint working with valid input")
    
    # =========================================================
    # TEST 6: Predict endpoint (INVALID category)
    # =========================================================
    def test_predict_invalid_category(self):
        test_data = {
            "category": "Invalid Category",
            "product": "Rice Bag",
            "month": "January",
            "price": 2400
        }
        
        response = self.app.post('/predict',
            data=json.dumps(test_data),
            content_type='application/json'
        )
        data = json.loads(response.data)
        
        self.assertEqual(response.status_code, 400)
        self.assertIn('error', data)
        print("✅ Invalid category handled correctly")
    
    # =========================================================
    # TEST 7: Predict endpoint (MISSING fields)
    # =========================================================
    def test_predict_missing_fields(self):
        test_data = {
            "category": "Groceries"
            # Missing product, month, price
        }
        
        response = self.app.post('/predict',
            data=json.dumps(test_data),
            content_type='application/json'
        )
        
        # Should handle gracefully
        self.assertIn(response.status_code, [200, 400])
        print("✅ Missing fields handled correctly")
    
    # =========================================================
    # TEST 8: Yearly summary endpoint
    # =========================================================
    def test_yearly_summary(self):
        response = self.app.get('/yearly_summary')
        data = json.loads(response.data)
        
        self.assertEqual(response.status_code, 200)
        self.assertIn('years', data)
        self.assertIn('summary', data)
        print("✅ Yearly summary endpoint working")
    
    # =========================================================
    # TEST 9: Months endpoint
    # =========================================================
    def test_months_endpoint(self):
        response = self.app.get('/months')
        data = json.loads(response.data)
        
        self.assertEqual(response.status_code, 200)
        self.assertIn('months', data)
        self.assertEqual(len(data['months']), 12)
        print("✅ Months endpoint working")

# =========================================================
# RUN ALL TESTS
# =========================================================
if __name__ == '__main__':
    print("\n" + "="*50)
    print("🧪 RUNNING API TESTS")
    print("="*50 + "\n")
    
    unittest.main(verbosity=2)
