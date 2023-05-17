import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:loginuicolors/models/enquriyModel.dart';
import 'package:loginuicolors/services/subAdminService.dart';
import 'package:loginuicolors/utils/Globals.dart';

class SubAdminEnquiries extends StatefulWidget {
  const SubAdminEnquiries({super.key});

  @override
  State<SubAdminEnquiries> createState() => _SubAdminEnquiriesState();
}

class _SubAdminEnquiriesState extends State<SubAdminEnquiries> {
  List<Enquiry> enquiries = [];
  bool first = true;

  getAllEvents() async {
    List<Enquiry> newEnquiries =
        await SubAdminService.getEnqbyState(Globals.subAdminState);
    newEnquiries = new List.from(newEnquiries.reversed);
    enquiries.addAll(newEnquiries);
    log(enquiries.toString());
    first = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    log(Globals.subAdminState);
    if (first) {
      getAllEvents();
    }
    return Scaffold(
      body: ListView.builder(
          itemCount: enquiries.length,
          itemBuilder: (context, index) {
            Enquiry enquiry = enquiries[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'EditEnqSubAdmin',
                    arguments: enquiry);
              },
              child: Container(
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
                                    'Enquiry Number: ${enquiry.id}',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 175, 175, 175),
                                        fontSize: 14),
                                  ),
                                  SizedBox(
                                      height:
                                          4), // add space between the first and second text
                                  Container(
                                    width: 200,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          enquiry.axel,
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 239, 239, 239),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        // SizedBox(width:100 ,),
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color.fromARGB(
                                                      255, 215, 0, 0)),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Text(
                                            enquiry.status.toUpperCase(),
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 215, 0, 0)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          4), // add more space between the second and third text
                                  SizedBox(height: 2),
                                  Text(
                                    'Address:',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 214, 214, 214),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 239, 239, 239),
                                          // color: Colors.blue,
                                          fontSize: 16),
                                      enquiry.address,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  SizedBox(
                                      height:
                                          4), // add space between the third and fourth text
                                  Text(
                                    'Price: ${enquiry.offered_price}',
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
              ),
            );
          }),
    );
  }
}
