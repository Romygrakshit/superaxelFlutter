import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:loginuicolors/pages/SubAdminProfile.dart';
import 'package:loginuicolors/pages/createInventory.dart';
import 'package:loginuicolors/pages/product_form_subadmin.dart';
import 'package:loginuicolors/pages/subAdminEnquiries.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubAdminHome extends StatefulWidget {
  const SubAdminHome({super.key});

  @override
  State<SubAdminHome> createState() => _SubAdminHomeState();
}

class _SubAdminHomeState extends State<SubAdminHome> {
  logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('number');
    Navigator.pushReplacementNamed(context, 'login');
  }

  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    SubAdminEnquiries(),
    CreateInventory(),
    ProductFormSubAdmin(),
    SubAdminProfile()
  ];

  @override
  void initState() {
    super.initState();
    checkForUpdate();
  }

  Future<void> checkForUpdate() async {
    print('checking for Update');
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          print('update available');
          update();
        }
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  void update() async {
    print('Updating');
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        color: Color.fromARGB(255, 18, 18, 18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: GNav(
              backgroundColor: Color.fromARGB(255, 18, 18, 18),
              color: Color.fromARGB(255, 239, 239, 239),
              tabBackgroundColor: Color.fromARGB(255, 0, 0, 0),
              activeColor: Color.fromARGB(255, 215, 0, 0),
              padding: EdgeInsets.all(8),
              gap: 5,
              onTabChange: (index) {
                _navigateBottomBar(index);
              },
              tabs: const [
                GButton(
                  icon: Icons.card_giftcard_sharp,
                  text: 'Enquiries',
                ),
                GButton(
                  icon: Icons.add_box_rounded,
                  text: 'Add Inventory',
                ),
                GButton(
                  icon: Icons.category,
                  text: 'Product Enquiry',
                ),
                GButton(
                  icon: Icons.account_box_rounded,
                  text: 'Profile',
                )
              ]),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 18, 18, 18),
        title: Text(
          'JB Super Axel subAd',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () => logout(),
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              )),
          SizedBox(
            width: 15,
          )
        ],
      ),
    );
  }
}
