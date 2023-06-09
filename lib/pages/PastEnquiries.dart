import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:loginuicolors/models/pastEnquiry.dart';

import '../services/enquiryService.dart';

class PastEnquiries extends StatefulWidget {
  const PastEnquiries({super.key});

  @override
  State<PastEnquiries> createState() => _PastEnquiriesState();
}

class _PastEnquiriesState extends State<PastEnquiries> {
  List<PastEnquiry> enquiries = [];
  bool first = true;

  testApi() async {
    List<PastEnquiry> newEnquiries = await EnquiryService.pastEnquiryList();
    newEnquiries = new List.from(newEnquiries.reversed);
    enquiries.addAll(newEnquiries);
    log(enquiries.toString());
    first = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (first) {
      testApi();
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.maxFinite,
        child: ListView.builder(
            itemCount: enquiries.length,
            itemBuilder: (context, index) {
              PastEnquiry enquiry = enquiries[index];
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
                                        Container(padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color.fromARGB(
                                                      255, 215, 0, 0)),borderRadius: BorderRadius.circular(10)),
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
              );
            }),
      ),
    );
  }
}
