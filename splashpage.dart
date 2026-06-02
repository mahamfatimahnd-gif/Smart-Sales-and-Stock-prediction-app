
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/siginup.dart';
//import 'dashboard_page.dart'; // Make sure to import your dashboard page here

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Smooth, gentle fade-in animation for the logo and text
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    // Automatically navigate to your Dashboard after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignupPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5), // Same warm, cozy background as the dashboard
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // THE LOGO: Abstract, soft, and premium
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9745B).withOpacity(0.08), // Soft Terracotta tint
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.grain_rounded, // Aesthetic, organic-looking leaf/grain structure
                  size: 42,
                  color: Color(0xFFD9745B), // Solid Terracotta accent
                ),
              ),
              const SizedBox(height: 24),
              
              // THE APP NAME
              const Text(
                "Stock AND Sync",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2C2523), // Deep earthy charcoal
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              
              // THE SUBTITLE
              const Text(
                "Business Insights & Analytics",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9C938E), // Soft dusty taupe
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 48),
              
              // A tiny, gentle loading indicator that doesn't ruin the look
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8A9A86)), // Calming Sage Green
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
