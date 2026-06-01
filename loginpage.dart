// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'homepage.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   bool isLoading = false;

//   Future<void> login() async {
//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();

//     if (email.isEmpty || password.isEmpty) {
//       _msg("Fill all fields");
//       return;
//     }

//     setState(() => isLoading = true);

//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       _msg("Login successful");

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const Homepage()),
//       );
//     } on FirebaseAuthException catch (e) {
//       _msg(e.message ?? "Login failed");
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   void _msg(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(msg)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [

//             const Text("Login", style: TextStyle(fontSize: 28)),

//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(labelText: "Email"),
//             ),

//             TextField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: const InputDecoration(labelText: "Password"),
//             ),

//             const SizedBox(height: 20),

//             isLoading
//                 ? const CircularProgressIndicator()
//                 : ElevatedButton(
//                     onPressed: login,
//                     child: const Text("Login"),
//                   ),

//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text("Go to Sign Up"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/dashboard.dart/dash.dart';
import 'homepage.dart';
//import 'signup_page.dart'; // Make sure this matches your signup page file name

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
        backgroundColor: const Color(0xFF2C2523), // Earthy charcoal
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Cozy, premium input field container matching the aesthetic
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
      backgroundColor: const Color(0xFFFAF8F5), // Warm sand background
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO CONTAINER 
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9745B).withOpacity(0.08), // Light terracotta tint
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.insights_rounded, // Matches predictive sales & analytics concept
                    size: 36,
                    color: Color(0xFFD9745B),
                  ),
                ),
                const SizedBox(height: 20),

                // HEADINGS
                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 28, 
                    fontWeight: FontWeight.w800, 
                    color: Color(0xFF2C2523), 
                    letterSpacing: -0.5
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Log in to manage your stock levels and view predictions",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14, 
                    color: Color(0xFF9C938E), 
                    fontWeight: FontWeight.w500
                  ),
                ),
                const SizedBox(height: 36),

                // INPUT FIELDS
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
                const SizedBox(height: 24),

                // ACTION BUTTON OR LOADING WHEEL
                isLoading
                    ? const CircularProgressIndicator(color: Color(0xFFD9745B))
                    : ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD9745B), // Terracotta primary tone
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 54),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                const SizedBox(height: 16),

                // LINK BACK TO SIGN UP
                TextButton(
                  onPressed: () {
                    // Replaces login stack with sign-up page cleanly to avoid empty pop loops
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const DashboardPage()),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF8A9A86), // Beautiful Sage Green accent text
                  ),
                  child: const Text(
                    "Don't have an account? Sign Up",
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