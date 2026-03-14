import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'welcome_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: CupertinoColors.white,
        middle: Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 20),

            // Profile Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.systemGrey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: CupertinoColors.activeBlue,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Center(
                      child: Icon(
                        CupertinoIcons.person_fill,
                        size: 40,
                        color: CupertinoColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    authProvider.userName ?? 'User',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    authProvider.userEmail ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Settings List
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.systemGrey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSettingsTile(
                    context: context,
                    icon: CupertinoIcons.info_circle_fill,
                    iconColor: CupertinoColors.activeBlue,
                    title: 'About',
                    onTap: () => _showAboutScreen(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Logout Button
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: CupertinoColors.systemBlue,
                  borderRadius: BorderRadius.circular(12),
                  onPressed: () => _showLogoutDialog(context),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.square_arrow_right,
                        size: 20,
                        color: CupertinoColors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: CupertinoColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 18,
              color: CupertinoColors.systemGrey,
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutScreen(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const AboutScreen(),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Logout'),
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logout();

              if (!context.mounted) return;

              Navigator.of(context).pop();
              Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(
                  builder: (context) => const WelcomeScreen(),
                ),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: CupertinoColors.white,
        middle: Text(
          'About',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 40),

            // App Icon & Name
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: CupertinoColors.activeBlue,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.activeBlue.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      CupertinoIcons.time,
                      size: 50,
                      color: CupertinoColors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'CpE Timetable',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Your Personal Schedule Manager',
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Developers Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.systemGrey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
                    child: Text(
                      'Developers',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.black,
                      ),
                    ),
                  ),
                  _buildDeveloperTile('Adrian S. Canlas', 'AC'),
                  _buildDivider(),
                  _buildDeveloperTile('Matt Julius M. Cayabyab', 'MC'),
                  _buildDivider(),
                  _buildDeveloperTile('Ronnel O. Deang', 'RD'),
                  _buildDivider(),
                  _buildDeveloperTile('Christian D. Digman', 'CD'),
                  _buildDivider(),
                  _buildDeveloperTile('John Ian Joseph M. Paragas', 'JP'),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Copyright
            Center(
              child: Text(
                '© 2025 CpE Timetable. All rights reserved.',
                style: TextStyle(
                  fontSize: 12,
                  color: CupertinoColors.systemGrey.withOpacity(0.8),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDeveloperTile(String name, String initials) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: CupertinoColors.activeBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                color: CupertinoColors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.only(left: 74),
      height: 0.5,
      color: CupertinoColors.systemGrey5,
    );
  }
}