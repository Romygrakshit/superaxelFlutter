import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:loginuicolors/models/enquriyModel.dart';
import 'package:loginuicolors/services/subAdminService.dart';
import 'package:loginuicolors/utils/Globals.dart';
import 'package:share_plus/share_plus.dart';

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
        await SubAdminService.getEnqbyState("${Globals.subAdminId}");
    newEnquiries = new List.from(newEnquiries.reversed);
    enquiries.addAll(newEnquiries);
    //log("$enquiries");
    first = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (first) {
      getAllEvents();
    }
    return Scaffold(
      body: enquiries.isEmpty
          ? Center(
              child: Text("Enquiries are empty"),
            )
          : ListView.builder(
              itemCount: enquiries.length,
              itemBuilder: (context, index) {
                Enquiry enquiry = enquiries[index];
                String imageUrl = ' ';
                if (enquiry.imagesUrls.first.contains('../..')) {
                  imageUrl = enquiry.imagesUrls.first
                      .replaceAll('../..', Globals.restApiUrl);
                } else {
                  imageUrl = Globals.restApiUrl + enquiry.imagesUrls.first;
                  debugPrint("ImageUrl is $imageUrl");
                }
                // enquiry.imagesUrls.first.replaceAll('../..', Globals.restApiUrl);
                log("$imageUrl");
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'EditEnqSubAdmin',
                        arguments: enquiry);
                  },
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
                                    image: NetworkImage(imageUrl),
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
                                  Text(
                                    'Company: ${enquiry.company}',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 214, 214, 214),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                      height:
                                          4), // add more space between the second and third text
                                  Text(
                                    'Car: ${enquiry.carName}',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 214, 214, 214),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                      height:
                                          4), // add more space between the second and third text
                                  Text(
                                    'Mobile No: ${enquiry.mobileNumber}',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 214, 214, 214),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                      height:
                                          4), // add more space between the second and third text
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
                                      enquiry.address,
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 239, 239, 239),
                                          // color: Colors.blue,
                                          fontSize: 16),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  SizedBox(
                                      height:
                                          4), // add space between the third and fourth text
                                  Text(
                                    'Price: ${enquiry.offeredPrice}',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 215, 0, 0),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                      ),
                                      onPressed: () async {
                                        String textToShare = """
                                          Enquiry Id : ${enquiry.id}
                                          Company: ${enquiry.company}
                                          Car: ${enquiry.carName}
                                          Axel Type: ${enquiry.axel}
                                          Price: ${enquiry.offeredPrice}
                                          Status: ${enquiry.status}
                                          Garage name: ${enquiry.garageName}
                                          Garage address: ${enquiry.address}
                                          Enquiry location: http://maps.google.com/maps?z=12&t=m&q=loc:${enquiry.lat}+${enquiry.lng}
                                          Garage location: http://maps.google.com/maps?z=12&t=m&q=loc:${enquiry.Glat}+${enquiry.Glng}""";
                                        await Share.share('$textToShare');
                                      },
                                      child: Text("Share"),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
