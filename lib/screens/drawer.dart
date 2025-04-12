import 'package:flutter/material.dart';
class CustomDrawer extends StatelessWidget {
  final String? username;
  final String? email;
  final String? profilePictureUrl;
  final VoidCallback navToUserDetails;
  final VoidCallback onLogIn;
  final bool isLoggedIn; // New parameter to track authentication state
  final bool isBackupEnabled;
  final Function(bool) onBackupToggle;
  final VoidCallback onLogout;
  final VoidCallback onExit;

  const CustomDrawer({
    Key? key,
    this.username,
    this.email,
    this.profilePictureUrl,
    required this.navToUserDetails,
    required this.onLogIn,
    required this.isLoggedIn, // Add this parameter
    required this.isBackupEnabled,
    required this.onBackupToggle,
    required this.onLogout,
    required this.onExit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: profilePictureUrl != null && profilePictureUrl!.isNotEmpty 
                      ? NetworkImage(profilePictureUrl!) as ImageProvider
                      : const AssetImage("assets/images/annie.jpg"),
                ),
                const SizedBox(height: 10),
                Text(
                  username ?? "Guest User",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  email ?? "",
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          // Show different options based on login state
          if (isLoggedIn) ...[
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: navToUserDetails,
            ),
            SwitchListTile(
              title: const Text('Enable Backup'),
              value: isBackupEnabled,
              onChanged: onBackupToggle,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: onLogout,
            ),
          ] else ...[
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: onLogIn,
            ),
          ],
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Exit App'),
            onTap: onExit,
          ),
        ],
      ),
    );
  }
}