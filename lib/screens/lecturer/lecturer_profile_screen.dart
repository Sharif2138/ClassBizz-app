import 'package:classbizz_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LecturerProfileScreen extends StatelessWidget {
  const LecturerProfileScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
  final user = context.watch<AuthProvider>().currentUser;
    return Scaffold(
      backgroundColor: Colors.grey[50],

      body: Column(
        children: [
          // ---------------- HEADER ----------------
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [

                        const Spacer(),
                        const Text(
                          "Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => _editProfile(context, user),
                          icon: const Icon(Icons.edit, color: Colors.white),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            const CircleAvatar(
                              radius: 45,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person, size: 55, color: Colors.grey),
                            ),
                            const SizedBox(height: 15),
                            Icon(
                              Icons.star,
                              color: Color.fromARGB(255, 208, 214, 9),
                              size: 20,
                            ),
                            SizedBox(height: 5),
                            Text(
                              "4.8",
                              style: TextStyle(
                                color: Color.fromARGB(255, 3, 8, 13),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 50),
                        
                        Column(
                          children: [
                            Text(
                              user?.displayName ?? 'No Name',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                            const Text(
                      "Lecturer",
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      user?.email ?? 'No Email',
                      style: const TextStyle(color: Colors.white70),
                    ), 
                    
                    const SizedBox(height: 20),
                  SizedBox(
                      width: 110,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () => _showLogoutDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 205, 36, 2
                          ),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                      ),
                  ),
                        
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),                   
                 ],
               ),
            ],
         ),
                  ],
                ),
              ),
            ),
          ),

         

          // ---------------- MAIN CONTENT (SCROLLABLE) ----------------
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------- Recent Reviews ----------
                  const Text(
                    "Recent Reviews",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  // Review 1
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 17,
                              backgroundColor: Color(0xFF4A90E2),
                              child: Text(
                                "G",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Grace N.",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            Text(
                              "2 days ago",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(
                            5,
                            (index) => const Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Excellent teaching style and very engaging!",
                        ),
                      ],
                    ),
                  ),

                  // Review 2
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 17,
                              backgroundColor: Color(0xFF4A90E2),
                              child: Text(
                                "J",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "John M.",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            Text(
                              "1 week ago",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ...List.generate(
                              4,
                              (i) => const Icon(
                                Icons.star,
                                size: 14,
                                color: Colors.orange,
                              ),
                            ),
                            Icon(Icons.star, size: 14, color: Colors.grey[300]),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Clear explanations, could use more examples.",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                 
                  const SizedBox(height: 20),

                  // ---------- Settings ----------
                  const Text(
                    "Settings",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  // Setting 1
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.notifications_outlined),
                        SizedBox(width: 16),
                        Text("Notifications"),
                        Spacer(),
                        Switch(value: true, onChanged: null),
                      ],
                    ),
                  ),

                  // Setting 2
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.language),
                        SizedBox(width: 16),
                        Text("Language"),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),

                  // Setting 3
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.privacy_tip_outlined),
                        SizedBox(width: 16),
                        Text("Privacy"),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout Confirmation"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog
                final auth = context.read<AuthProvider>();
                await auth.signOut();
                
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', 
                    (route) => false
                  );
              },
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  // Edit profile functionality
  void _editProfile(BuildContext context, user) {
    final TextEditingController nameController = 
      TextEditingController(text: user?.displayName ?? '');
    final TextEditingController emailController =
      TextEditingController(text: user?.email ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Profile"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    // Add profile picture change logic here
                  },
                  child: Stack(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 50, color: Colors.grey),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle
                          ),
                          child: const Icon(Icons.edit, size: 16, color: Colors.white),
                        ),
                      )
                    ],
                  ), 
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
            ElevatedButton(
              onPressed: () {
                _saveProfileChanges(
                  context,
                  nameController.text,
                  emailController.text,
                );
              },
              child: const Text("Save Changes"),
            ),
          ],
        );
      },
    );
  }

  void _saveProfileChanges(
    BuildContext context, 
    String newName, 
    String newEmail, 
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
  }
}
