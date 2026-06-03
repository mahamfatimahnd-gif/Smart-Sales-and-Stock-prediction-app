
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;

  bool isDarkMode = false;

  Uint8List? _imageBytes;
  String? photoUrl;
  bool _isUploading = false;
  bool _isLoadingImage = true;

  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // -------------------------------
  // LOAD USER DATA FROM FIRESTORE
  // -------------------------------
  Future<void> _loadUserData() async {
    if (user == null) return;
    
    try {
      final doc = await firestore.collection('users').doc(user!.uid).get();
      
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          nameController.text = data['displayName'] ?? user?.displayName ?? "User";
          photoUrl = data['photoURL'] ?? user?.photoURL;
          _isLoadingImage = false;
        });
      } else {
        // Create user document if it doesn't exist
        await firestore.collection('users').doc(user!.uid).set({
          'email': user!.email,
          'displayName': user?.displayName ?? "User",
          'photoURL': user?.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        setState(() {
          nameController.text = user?.displayName ?? "User";
          photoUrl = user?.photoURL;
          _isLoadingImage = false;
        });
      }
    } catch (e) {
      print("Error loading user data: $e");
      setState(() {
        nameController.text = user?.displayName ?? "User";
        photoUrl = user?.photoURL;
        _isLoadingImage = false;
      });
    }
  }

  // -------------------------------
  // SAVE USER DATA TO FIRESTORE
  // -------------------------------
  Future<void> _saveUserDataToFirestore() async {
    if (user == null) return;
    
    try {
      await firestore.collection('users').doc(user!.uid).update({
        'displayName': nameController.text.trim(),
        'photoURL': photoUrl,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error saving to Firestore: $e");
      // If document doesn't exist, create it
      await firestore.collection('users').doc(user!.uid).set({
        'email': user!.email,
        'displayName': nameController.text.trim(),
        'photoURL': photoUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    }
  }

  // -------------------------------
  // PICK IMAGE
  // -------------------------------
  Future<void> pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // Compress image
        maxWidth: 500,
        maxHeight: 500,
      );

      if (picked != null) {
        // Read image as bytes
        final bytes = await picked.readAsBytes();
        
        setState(() {
          _imageBytes = bytes;
          _isUploading = true;
        });

        await uploadImage();
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error picking image: $e"),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    }
  }

  // -------------------------------
  // UPLOAD TO FIREBASE STORAGE
  // -------------------------------
  Future<void> uploadImage() async {
    if (_imageBytes == null || user == null) return;

    try {
      // First, compress the image bytes
      final compressedBytes = await _compressImageBytes(_imageBytes!);
      
      final fileName = 'profile_${user!.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance
          .ref()
          .child('profilePics')
          .child(fileName);

      // Upload bytes directly with metadata
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        cacheControl: 'public,max-age=3600',
        customMetadata: {
          'userId': user!.uid,
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      // Show upload progress
      final uploadTask = ref.putData(compressedBytes, metadata);
      
      // Wait for upload to complete
      final snapshot = await uploadTask;
      
      // Get download URL with token
      final url = await snapshot.ref.getDownloadURL();
      
      print("Upload successful: $url");

      // Delete old profile picture if exists and it's not the default
      if (photoUrl != null && photoUrl!.isNotEmpty && photoUrl!.contains('firebasestorage')) {
        try {
          final oldRef = FirebaseStorage.instance.refFromURL(photoUrl!);
          await oldRef.delete();
          print("Old image deleted successfully");
        } catch (e) {
          print("Error deleting old image: $e");
        }
      }

      // Update Firebase Auth
      await user!.updatePhotoURL(url);
      
      // Update Firestore
      await firestore.collection('users').doc(user!.uid).update({
        'photoURL': url,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      setState(() {
        photoUrl = url;
        _imageBytes = null; // Clear bytes after upload
        _isUploading = false;
        _isLoadingImage = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✓ Profile picture updated successfully"),
            backgroundColor: Color(0xFF6B8F71),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      print("Upload error details: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error uploading image: ${e.toString()}"),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    }
  }

  // Helper method to compress image bytes
  Future<Uint8List> _compressImageBytes(Uint8List bytes) async {
    // You can add image compression logic here if needed
    // For now, return the original bytes
    return bytes;
  }

  // -------------------------------
  // UPDATE NAME
  // -------------------------------
  Future<void> updateName() async {
    if (user == null) return;
    
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Name cannot be empty"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    try {
      // Update Firebase Auth
      await user!.updateDisplayName(nameController.text.trim());
      
      // Update Firestore
      await _saveUserDataToFirestore();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✓ Name updated successfully"),
            backgroundColor: Color(0xFF6B8F71),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error updating name: $e"),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    }
  }

  // -------------------------------
  // CHANGE PASSWORD
  // -------------------------------
  Future<void> changePassword() async {
    if (user?.email == null) return;
    
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: user!.email!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("📧 Password reset email sent to ${user!.email}"),
            backgroundColor: const Color(0xFF6B8F71),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    }
  }

  // -------------------------------
  // LOGOUT
  // -------------------------------
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    }
  }

  // -------------------------------
  // BUILD PROFILE STATS SECTION
  // -------------------------------
  Widget _buildProfileStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            "Member Since",
            user?.metadata.creationTime?.year.toString() ?? "2024",
            Icons.calendar_today,
          ),
          Container(
            width: 1,
            height: 40,
            color: const Color(0xFFE8DFD0),
          ),
          _buildStatItem(
            "Last Login",
            _getTimeAgo(user?.metadata.lastSignInTime),
            Icons.history,
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime? date) {
    if (date == null) return "Today";
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 0) return "${diff.inDays}d ago";
    if (diff.inHours > 0) return "${diff.inHours}h ago";
    if (diff.inMinutes > 0) return "${diff.inMinutes}m ago";
    return "Just now";
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF8B7D6B)),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A3B2C),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  // -------------------------------
  // BUILD MENU ITEM
  // -------------------------------
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    String? subtitle,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: const Color(0xFFE8DFD0)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (iconColor ?? const Color(0xFF6B8F71)).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor ?? const Color(0xFF6B8F71)),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF4A3B2C),
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              )
            : null,
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        onTap: onTap,
      ),
    );
  }

  // Helper method to get the appropriate image widget
  Widget _buildProfileImage() {
    // Show preview of selected image
    if (_imageBytes != null) {
      return CircleAvatar(
        radius: 60,
        backgroundColor: const Color(0xFFE8DFD0),
        backgroundImage: MemoryImage(_imageBytes!),
      );
    }
    
    // Show cached network image if URL exists
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 60,
        backgroundColor: const Color(0xFFE8DFD0),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: photoUrl!,
            fit: BoxFit.cover,
            width: 120,
            height: 120,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6B8F71),
                strokeWidth: 2,
              ),
            ),
            errorWidget: (context, url, error) => Icon(
              Icons.person,
              size: 50,
              color: const Color(0xFF8B7D6B),
            ),
          ),
        ),
      );
    }
    
    // Show default icon
    return CircleAvatar(
      radius: 60,
      backgroundColor: const Color(0xFFE8DFD0),
      child: Icon(
        Icons.person,
        size: 50,
        color: const Color(0xFF8B7D6B),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF2C2418) : const Color(0xFFF5F2EB),
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A3B2C),
          ),
        ),
        backgroundColor: isDark ? const Color(0xFF2C2418) : Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: const Color(0xFF8B7D6B),
            ),
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile Header
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        _buildProfileImage(),
                        if (_isUploading)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF6B8F71),
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _isUploading ? null : pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6B8F71),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: Icon(
                                _isUploading ? Icons.hourglass_empty : Icons.camera_alt,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Tap the camera icon to change",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8B7D6B),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // User Info Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Personal Information",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A3B2C),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        labelStyle: TextStyle(color: Colors.grey.shade600),
                        prefixIcon: Icon(Icons.person_outline, color: const Color(0xFF6B8F71)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: const Color(0xFFE8DFD0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: const Color(0xFFE8DFD0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFF6B8F71), width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: updateName,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B8F71),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Stats Section
              _buildProfileStats(),

              const SizedBox(height: 20),

              // Menu Items
              _buildMenuItem(
                icon: Icons.email_outlined,
                title: "Email Address",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Email cannot be changed here"),
                      backgroundColor: Color(0xFF8B7D6B),
                    ),
                  );
                },
                iconColor: const Color(0xFF8B7D6B),
                subtitle: user?.email ?? "No email",
              ),
              
              _buildMenuItem(
                icon: Icons.lock_outline,
                title: "Change Password",
                onTap: changePassword,
                iconColor: const Color(0xFFD4A373),
              ),
              
              _buildMenuItem(
                icon: Icons.privacy_tip_outlined,
                title: "Privacy & Security",
                onTap: () {
                  // Navigate to privacy settings
                },
                iconColor: const Color(0xFF8B7D6B),
              ),
              
              _buildMenuItem(
                icon: Icons.notifications_outlined,
                title: "Notifications",
                onTap: () {
                  // Navigate to notification settings
                },
                iconColor: const Color(0xFFD4A373),
              ),

              const SizedBox(height: 20),

              // Logout Button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.logout, color: Colors.red.shade400),
                  ),
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                  trailing: Icon(Icons.chevron_right, color: Colors.red.shade300),
                  onTap: logout,
                ),
              ),

              const SizedBox(height: 20),
              
              // App Version
              Center(
                child: Text(
                  "Version 2.0.0",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}