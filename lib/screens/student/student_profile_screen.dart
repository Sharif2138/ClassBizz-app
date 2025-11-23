import 'package:flutter/material.dart';
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ----- HEADER -----
              _ProfileHeader(user: user),

              const SizedBox(height: 20),

              // ----- STATS ROW -----
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _StatsRow(),
              ),

              const SizedBox(height: 20),

              

              const SizedBox(height: 20),

              // ----- SESSION HISTORY -----
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Session History",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    _SessionHistoryTile(
                      title: "Math 101",
                      date: "2025-11-21",
                      points: 20,
                      status: "completed",
                    ),
                    _SessionHistoryTile(
                      title: "Science 102",
                      date: "2025-11-18",
                      points: 15,
                      status: "missed",
                    ),
                    _SessionHistoryTile(
                      title: "History 103",
                      date: "2025-11-10",
                      points: 10,
                      status: "completed",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Simple stats row showing basic metrics
class _StatsRow extends StatelessWidget {
  const _StatsRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: const [
              Text(
                "45",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text("Sessions", style: TextStyle(color: Colors.black54)),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: const [
              Text(
                "120",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text("Points", style: TextStyle(color: Colors.black54)),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: const [
              Text(
                "Top 10%",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text("Rank", style: TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }
}

// Session history tile used in the session history list
class _SessionHistoryTile extends StatelessWidget {
  final String title;
  final String date;
  final int points;
  final String status;
  const _SessionHistoryTile({
    Key? key,
    required this.title,
    required this.date,
    required this.points,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Icon leadingIcon;
    Color statusColor;
    if (status == "completed") {
      leadingIcon = const Icon(Icons.check_circle, color: Colors.green);
      statusColor = Colors.green;
    } else if (status == "missed") {
      leadingIcon = const Icon(Icons.cancel, color: Colors.red);
      statusColor = Colors.red;
    } else {
      leadingIcon = const Icon(Icons.help_outline, color: Colors.grey);
      statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: leadingIcon,
        title: Text(title),
        subtitle: Text(date),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "+$points",
              style: TextStyle(fontWeight: FontWeight.bold, color: statusColor),
            ),
            const SizedBox(height: 4),
            Text(
              status,
              style: TextStyle(color: statusColor),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- HEADER WIDGET ----------
class _ProfileHeader extends StatelessWidget {
  final user;
  const _ProfileHeader({this.user});

  // Logout confirmation dialog
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
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                final auth = context.read<AuthProvider>();
                auth.signOut(); // Proceed with logout
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
  void _editProfile(BuildContext context) {
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
                  onTap: () {},

                  child: Stack(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 50, color: Colors.grey,),
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
                          child: const Icon(Icons.edit, size: 16,color: Colors.white,),
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
                    border: OutlineInputBorder() ,
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
            ElevatedButton(onPressed: () {
              _saveProfileChanges(
                context,
                nameController.text,
                emailController.text
              );
            },
             child: const Text("Save Changes"),
            ) ,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
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
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _editProfile(context),
                  icon: const Icon(Icons.edit, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Column(
                  children: [
                    const CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 55, color: Colors.grey),
                    ),
                    const SizedBox(height: 15),
                    const Icon(
                      Icons.emoji_events,
                      color: Color.fromARGB(255, 208, 214, 9),
                      size: 20,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "3rd",
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? 'No Name',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Student",
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      user?.email ?? 'No Email',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child:SizedBox(
                      width: 110,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: ()  => _showLogoutDialog (context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            205,
                            36,
                            2,
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
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
