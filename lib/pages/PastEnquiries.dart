import 'package:flutter/material.dart';

import '../services/enquiryService.dart';

class PastEnquiries extends StatefulWidget {
  const PastEnquiries({super.key});

  @override
  State<PastEnquiries> createState() => _PastEnquiriesState();
}

class _PastEnquiriesState extends State<PastEnquiries> {
  testApi() async {
    EnquiryService.pastEnquiryList();
  }

  @override
  Widget build(BuildContext context) {
    testApi();

    return Scaffold(
      body: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Card(
                  color: Color.fromARGB(255, 10, 10, 10),
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
                                  image: AssetImage('assets/trag.jfif'),
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
                                  'Enquiry Number: 65',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 175, 175, 175),
                                      fontSize: 14),
                                ),
                                SizedBox(
                                    height:
                                        4), // add space between the first and second text
                                Text(
                                  ' left axel',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 239, 239, 239),
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
                                      color: Color.fromARGB(255, 214, 214, 214),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  width: 220,
                                  child: Text(
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 239, 239, 239),
                                        fontSize: 16),
                                    "Kahin toh hai yeh address soch kar batao",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                SizedBox(
                                    height:
                                        4), // add space between the third and fourth text
                                Text(
                                  'Price: 5000',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 215, 0, 0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
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
            );
          }),
    );
  }
}
