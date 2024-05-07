import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:loginuicolors/utils/Globals.dart';

class SubAdminProfile extends StatelessWidget {
  const SubAdminProfile({super.key});




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Card(
              color: Color.fromARGB(255, 190, 190, 190),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/luffy2.jfif'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Garage ID: ${Globals.subAdminId}',
                              style: TextStyle(color: Color.fromARGB(255, 29, 29, 29), fontSize: 14),
                            ),
                            SizedBox(height: 4), // add space between the first and second text
                            Text(
                              Globals.subAdminName,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 29, 29, 29), fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(height: 4), // add more space between the second and third text
                            SizedBox(height: 2),
                            Text(
                              'Address:',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 19, 19, 19), fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(
                              width: 200,
                              child: Text(
                                style: TextStyle(color: Color.fromARGB(255, 29, 29, 29), fontSize: 16),
                                Globals.subAdminState,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
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
}
