import 'package:flutter/material.dart';
import 'package:marshalassignment/screens/deviceinfopage.dart';
import 'package:marshalassignment/screens/login_page.dart';
import 'package:marshalassignment/screens/profile_page.dart';
import 'package:marshalassignment/screens/recipes.dart';
import 'package:provider/provider.dart';

import '../utils/batteryoverlay.dart';
import '../providers/profileprovider.dart';

class homePage extends StatefulWidget {
  final Map<String, dynamic> userData;
  const homePage({super.key, required this.userData});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  int _selectedIndex = 0;
  bool _showBatteryOverlay = true; // Toggle switch

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ProfileProvider>(context, listen: false).fetchProfile());

    _pages = [
      const Center(child: Text('Welcome! Open the drawer to navigate')),
      ProfilePage(),
      DeviceInfoScreen(),
      const Center(child: Text('Gallery')),
      RecipeListPage(),
    ];
  }

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final profile = profileProvider.profile;

    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            GestureDetector(
              onTap: () => _selectPage(1),
              child: DrawerHeader(
                decoration: const BoxDecoration(color: Colors.blue),
                child: Text(
                  "${profile?['firstName']} ${profile?['lastName']}",
                  style: const TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SwitchListTile(
              value: _showBatteryOverlay,
              title: const Text("Show Battery Overlay"),
              secondary: const Icon(Icons.battery_charging_full),
              onChanged: (value) {
                setState(() {
                  _showBatteryOverlay = value;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Device Info'),
              onTap: () => _selectPage(2),
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Gallery'),
              onTap: () => _selectPage(3),
            ),
            ListTile(
              leading: const Icon(Icons.food_bank),
              title: const Text('Recipes'),
              onTap: () => _selectPage(4),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  final provider = Provider.of<ProfileProvider>(context, listen: false);
                  await provider.logout();
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const loginPage()),
                        (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [

          _pages[_selectedIndex],
          BatteryOverlay(isVisible: _showBatteryOverlay),

        ],
      ),
    );
  }
}
