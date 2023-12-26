import 'package:flutter/material.dart';
import 'package:loginuicolors/utils/Globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<String?> getStoredUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('url');
  }

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
                        FutureBuilder<String?>(
                          future:
                              getStoredUrl(), // a previously-obtained Future<String> or null
                          builder: (BuildContext context,
                              AsyncSnapshot<String?> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // While the Future is loading
                              return CircularProgressIndicator(); // or any loading indicator
                            } else if (snapshot.hasError) {
                              // If there's an error in fetching the URL
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              // If the URL is successfully fetched, use it
                              String imageUrl = snapshot.data!;
                              return Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "${Globals.restApiUrl+imageUrl}"), // Using the fetched URL here
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              );
                            } else {
                              // If the URL is null or not fetched yet
                              return Text('URL not found');
                            }
                          },
                        ),

                        // Container(
                        //   width: 100,
                        //   height: 100,
                        //   decoration: BoxDecoration(
                        //     image: DecorationImage(
                        //       image: NetworkImage("${Globals.restApiUrl+}"),
                        //       fit: BoxFit.cover,
                        //     ),
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        // ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Garage ID: ${Globals.garageId}',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 29, 29, 29),
                                  fontSize: 14),
                            ),
                            SizedBox(
                                height:
                                    4), // add space between the first and second text
                            Text(
                              Globals.garageName,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 29, 29, 29),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            SizedBox(
                                height:
                                    4), // add more space between the second and third text
                            SizedBox(height: 2),
                            Text(
                              'Address:',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 19, 19, 19),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              width: 200,
                              child: Text(
                                style: TextStyle(
                                    color: Color.fromARGB(255, 29, 29, 29),
                                    fontSize: 16),
                                Globals.garageAddress,
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
