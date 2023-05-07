import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 18, 18, 18),
          title: const Text('JB Super Axel'),
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