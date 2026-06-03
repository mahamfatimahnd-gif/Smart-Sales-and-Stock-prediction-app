
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/dashboard.dart/dash.dart';
import 'package:flutter_application_1/responsivelayout.dart';
import 'homepage.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _msg("Fill all fields");
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _msg("Login successful");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Homepage()),
      );
    } on FirebaseAuthException catch (e) {
      _msg(e.message ?? "Login failed");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _msg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2C2523),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    bool obscureText = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEFECE6)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2C2523).withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        cursorColor: const Color(0xFFD9745B),
        style: const TextStyle(
          color: Color(0xFF2C2523),
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF9C938E),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(prefixIcon, color: const Color(0xFF9C938E), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final formWidth = ResponsiveLayout.responsiveValue(
      context: context,
      mobile: double.infinity,
      tablet: 500.0,
      desktop: 600.0,
    );
    
    final horizontalPadding = ResponsiveLayout.responsiveValue(
      context: context,
      mobile: 28.0,
      tablet: 60.0,
      desktop: 120.0,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO CONTAINER
                Container(
                  width: ResponsiveLayout.responsiveValue(context: context, mobile: 80.0, tablet: 100.0, desktop: 120.0),
                  height: ResponsiveLayout.responsiveValue(context: context, mobile: 80.0, tablet: 100.0, desktop: 120.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9745B).withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.insights_rounded,
                    size: ResponsiveLayout.responsiveValue(context: context, mobile: 36.0, tablet: 46.0, desktop: 56.0),
                    color: const Color(0xFFD9745B),
                  ),
                ),
                SizedBox(height: isMobile ? 20 : 28),

                // HEADINGS
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: ResponsiveLayout.responsiveValue(context: context, mobile: 28.0, tablet: 36.0, desktop: 44.0),
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF2C2523),
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: isMobile ? 6 : 10),
                Text(
                  "Log in to manage your stock levels and view predictions",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: ResponsiveLayout.responsiveValue(context: context, mobile: 14.0, tablet: 16.0, desktop: 18.0),
                    color: const Color(0xFF9C938E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: isMobile ? 36 : 44),

                // INPUT FIELDS
                SizedBox(
                  width: formWidth,
                  child: Column(
                    children: [
                      _buildInputField(
                        controller: emailController,
                        label: "Email Address",
                        prefixIcon: Icons.mail_outline_rounded,
                      ),
                      _buildInputField(
                        controller: passwordController,
                        label: "Password",
                        prefixIcon: Icons.lock_open_rounded,
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isMobile ? 24 : 32),

                // ACTION BUTTON OR LOADING WHEEL
                SizedBox(
                  width: formWidth,
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator(color: Color(0xFFD9745B)))
                      : ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD9745B),
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, ResponsiveLayout.responsiveValue(context: context, mobile: 54.0, tablet: 60.0, desktop: 66.0)),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: ResponsiveLayout.responsiveValue(context: context, mobile: 16.0, tablet: 18.0, desktop: 20.0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
                SizedBox(height: isMobile ? 16 : 20),

                // SIGN UP NAVIGATION
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const DashboardPage()),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF8A9A86),
                  ),
                  child: Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(
                      fontSize: ResponsiveLayout.responsiveValue(context: context, mobile: 14.0, tablet: 16.0, desktop: 18.0),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
