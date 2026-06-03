
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'loginpage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool isLoading = false;

  Future<void> signup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      _msg("Fill all fields");
      return;
    }

    if (password != confirm) {
      _msg("Passwords do not match");
      return;
    }

    setState(() => isLoading = true);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "uid": uid,
        "name": name,
        "email": email,
        "createdAt": FieldValue.serverTimestamp(),
      });

      _msg("Account created");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      _msg(e.message ?? "Signup failed");
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
        backgroundColor: const Color(0xFF2C2523), // Earthy charcoal
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Beautiful reusable helper widget for Pinterest-styled TextFields
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
        cursorColor: const Color(0xFFD9745B), // Terracotta cursor
        style: const TextStyle(
          color: Color(0xFF2C2523), 
          fontSize: 15, 
          fontWeight: FontWeight.w500
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF9C938E), 
            fontSize: 14, 
            fontWeight: FontWeight.w500
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
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5), // Soft, warm cream background
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // BRAND LOGO ICON
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9745B).withOpacity(0.08), // Soft Terracotta tint
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.grain_rounded, // Beautiful, organic grain structure
                    size: 38,
                    color: Color(0xFFD9745B),
                  ),
                ),
                const SizedBox(height: 20),

                // BRAND HEADERS
                const Text(
                  "Stock & Sync",
                  style: TextStyle(
                    fontSize: 28, 
                    fontWeight: FontWeight.w800, 
                    color: Color(0xFF2C2523), 
                    letterSpacing: -0.5
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Create an account to manage your business operations",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14, 
                    color: Color(0xFF9C938E), 
                    fontWeight: FontWeight.w500
                  ),
                ),
                const SizedBox(height: 32),

                // INPUT FORM FIELDS
                _buildInputField(
                  controller: nameController,
                  label: "Full Name",
                  prefixIcon: Icons.person_outline_rounded,
                ),
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
                _buildInputField(
                  controller: confirmController,
                  label: "Confirm Password",
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: true,
                ),
                const SizedBox(height: 24),

                // SUBMIT BUTTON / LOADER CONTAINER
                isLoading
                    ? const CircularProgressIndicator(color: Color(0xFFD9745B))
                    : ElevatedButton(
                        onPressed: signup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD9745B), // Terracotta Tone
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 54),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Create Account",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                const SizedBox(height: 16),

                // NAVIGATION TO LOGIN
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF8A9A86), // Relaxing Sage Green text accent
                  ),
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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
