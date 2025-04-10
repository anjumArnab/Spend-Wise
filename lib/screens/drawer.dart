import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final String username;
  final String email;
  final String profilePictureUrl;
  final VoidCallback onLogIn;
  final bool isBackupEnabled;
  final ValueChanged<bool> onBackupToggle;
  final VoidCallback navToUserDetails;
  final VoidCallback onLogout;
  final VoidCallback onExit;

  const CustomDrawer({
    super.key,
    required this.username,
    required this.email,
    required this.profilePictureUrl,
    required this.onLogIn,
    required this.isBackupEnabled,
    required this.onBackupToggle,
    required this.navToUserDetails,
    required this.onLogout,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header Section with User Profile
          GestureDetector(
            onTap: navToUserDetails,
            child: UserAccountsDrawerHeader(
              accountName: Text(username, style: const TextStyle(color: Colors.black),),
              accountEmail: Text(email, style:const TextStyle(color: Colors.black)),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    profilePictureUrl), // Replace with user's profile picture URL
              ),
              decoration: const BoxDecoration(
                color: Colors.white// Set background color
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.login_outlined, color: Colors.black),
            title: const Text('Log In'),
            onTap: onLogIn,
          ),
          // Backup Tasks Section
          ListTile(
            leading: const Icon(Icons.cloud, color: Colors.black),
            title: const Text('Backup to Cloud'), // Backup Tasks to Cloud
            trailing: Switch(
              focusColor: Colors.white,
              value: isBackupEnabled,
              onChanged: onBackupToggle,
            ),
          ),

          const Divider(),

          // Logout Button
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.black),
            title: const Text('Logout'),
            onTap: onLogout, // Add logout functionality here
          ),

          // Exit Button
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.black),
            title: const Text('Exit'),
            onTap: onExit, // Add exit functionality here
          ),
        ],
      ),
    );
  }
}