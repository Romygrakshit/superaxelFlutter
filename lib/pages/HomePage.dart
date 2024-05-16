import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:loginuicolors/pages/NewEnquiry.dart';
import 'package:loginuicolors/pages/PastEnquiries.dart';
import 'package:loginuicolors/pages/Profile.dart';
import 'package:loginuicolors/pages/product_form_garage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('number');
    Navigator.pushReplacementNamed(context, 'login');
  }

  final List<Widget> _pages = [
    PastEnquiries(),
    NewEnquiries(),
    ProductForm(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 18, 18, 18),
          title: Text(
            'JB Super Axel',
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
        body: Center(
          child: _pages.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          color: Color.fromARGB(255, 18, 18, 18),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
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
                    icon: Icons.featured_play_list,
                    text: 'Past Enquiry',
                  ),
                  GButton(
                    icon: Icons.add_box_rounded,
                    text: 'New Enquiry',
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
        ));
  }
}
