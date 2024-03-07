import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loginuicolors/models/cars.dart';
import 'package:loginuicolors/models/companies.dart';
import 'package:loginuicolors/services/enquiryService.dart';
import 'package:loginuicolors/services/firebase_messaging.dart';
import 'package:loginuicolors/services/garagesService.dart';
import 'package:loginuicolors/utils/Globals.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:http/http.dart' as http;

class NewEnquiries extends StatefulWidget {
  const NewEnquiries({super.key});

  @override
  State<NewEnquiries> createState() => _NewEnquiriesState();
}

class _NewEnquiriesState extends State<NewEnquiries> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCompany;
  int? _selectedCar;
  String? _selectedCarName;
  String? _selectedAxel;
  List<File> files = [];
  bool isLocation = false;
  double lat = 0;
  double long = 0;
  String address = '';
  bool companySelected = false;
  bool carSelected = false;
  bool axelSelected = false;
  String priceOfEnquiry = '';
  String left = '';
  String right = '';

  bool loadLocation = false;

  // locator
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;

  ScrollController _scrollController = ScrollController();
  PushNotifications pushNotification = PushNotifications();

  void submitEnquiry(BuildContext context) async {
    // create an instance of pushNotification Class
    // send Enquiry on Back-end
    EnquiryService.createEnquiry(
        files,
        address,
        lat.toString(),
        long.toString(),
        _selectedCompany.toString(),
        _selectedCarName.toString(),
        _selectedAxel.toString(),
        priceOfEnquiry,
        context);

    // send notification to SubAdmin
    await PushNotifications.showSimpleNotification(
      id: Globals.subAdminId,
      fcmToken: Globals.subAdminDeviceToken,
      title: "New Enquiry Created",
      body: Globals.garageName,
      payload: _selectedCarName.toString());
  }

  pickFiles() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(allowMultiple: true);

      if (result != null) {
        files = result.paths.map((path) => File(path.toString())).toList();
        setState(() {});
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> checkGps() async {
    loadLocation = true;
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          debugPrint("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {
          //refresh the UI
        });

        await getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  Future<void> getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint(position.longitude.toString());
    debugPrint(position.latitude.toString());

    long = position.longitude;
    lat = position.latitude;

    setState(() {
      //refresh UI
      loadLocation = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLocation
        ? Scaffold(
            body: OpenStreetMapSearchAndPick(
              // center: LatLong(26.82, 75.85),
              center: LatLong(lat, long),
              onPicked: (pickedData) {
                debugPrint("${pickedData.toString()}");
                setState(() {
                  lat = pickedData.latLong.latitude;
                  long = pickedData.latLong.longitude;
                  address = pickedData.addressName;
                  log(pickedData.latLong.latitude.toString());
                  log(pickedData.latLong.longitude.toString());
                  // log(pickedData.address);
                  isLocation = false;
                });
              },
              buttonText: "Pick Location",
            ),
          )
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'Select Company',
                      ),
                      value: _selectedCompany,
                      items: [
                        for (Companies company in Globals.allCompanies)
                          DropdownMenuItem(
                              value: company.company,
                              child: Text("${company.company}"))
                      ],
                      hint: const Text('Select an option'),
                      onChanged: (value) async {
                        setState(() {
                          companySelected = false;
                        });
                        List<Cars> cars =
                            await GaragesService.getAllCars(value.toString());
                        setState(() {
                          Globals.allCars = [];
                          _selectedCompany = value.toString();
                          carSelected = false;
                          _selectedCar = null;
                          _selectedCarName = null;
                        });

                        setState(() {
                          companySelected = true;
                          Globals.allCars = cars;
                        });
                      },
                    ),
                    if (companySelected) ...[
                      const SizedBox(
                        height: 20,
                      ),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: 'Select Car',
                        ),
                        value: _selectedCar,
                        items: [
                          for (Cars car in Globals.allCars)
                            DropdownMenuItem(
                                value: car.id, child: Text("${car.carName}"))
                        ],
                        hint: const Text('Select an option'),
                        onChanged: (value) async {
                          _selectedCarName = Globals.allCars
                              .firstWhere((element) => element.id == value)
                              .carName;
                          var response = await GaragesService.getPrices(
                              int.parse(value.toString()), Globals.garageId);

                          if (response.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('No Prices Found')));
                            return;
                          }
                          left = response[0];
                          right = response[1];
                          log('$left and $right');
                          setState(() {
                            _selectedCar = int.parse(value.toString());
                            carSelected = true;
                          });
                        },
                      )
                    ],
                    if (carSelected) ...[
                      const SizedBox(
                        height: 20,
                      ),
                      DropdownButtonFormField(
                        value: _selectedAxel,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: 'Select Axel (left/right)',
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Left', child: Text('Left')),
                          DropdownMenuItem(
                              value: 'Right', child: Text('Right')),
                          DropdownMenuItem(value: 'Both', child: Text('Both'))
                        ],
                        hint: const Text('Select an option'),
                        onChanged: (value) {
                          setState(() {
                            if (value == 'Left')
                              priceOfEnquiry = left;
                            else if (value == 'Right')
                              priceOfEnquiry = right;
                            else
                              priceOfEnquiry = '\nLeft: $left\nRight: $right';
                            _selectedAxel = value as String?;
                            axelSelected = true;
                          });
                        },
                      )
                    ],

                    // if (carSelected)
                    //   DropdownButtonFormField(
                    //     value: _selectedState,
                    //     decoration: const InputDecoration(
                    //       border: UnderlineInputBorder(),
                    //       labelText: 'Enter the State',
                    //     ),
                    //     items: [
                    //       for (StateDecode state in Globals.allStates)
                    //         DropdownMenuItem(
                    //             value: state.state,
                    //             child: Text("${state.state}"))
                    //     ],
                    //     hint: const Text('Select a State'),
                    //     onChanged: (value) {
                    //       _selectedState = value.toString();
                    //     },
                    //   ),
                    //  DropdownButtonFormField(
                    //           items: [
                    //             for (StateDecode state in Globals.allStates)
                    //               DropdownMenuItem(
                    //                   value: state.state,
                    //                   child: Text("${state.state}"))
                    //           ],
                    //           decoration: InputDecoration(
                    //               fillColor: Colors.grey.shade100,
                    //               filled: true,
                    //               hintText: "Select State",
                    //               border: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.circular(10),
                    //               )),
                    //           onChanged: (value) {
                    //             dropDownValue = value.toString();
                    //           },
                    //         ),
                    SizedBox(
                      height: 20,
                    ),
                    if (axelSelected)
                      Center(
                          child: Text(
                        'Price : $priceOfEnquiry',
                        style: TextStyle(fontSize: 20),
                      )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: ElevatedButton(
                                onPressed: () => pickFiles(),
                                child: const Text('AddImages'),
                              ),
                            ),
                            Text('${files.length} images selected'),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Text(
                                '*If Uploaded Photos, we will provide guaranteed prices',
                                style: TextStyle(fontSize: 13),
                                textDirection: TextDirection.ltr,
                                maxLines: 2,
                              ),
                            ),
                            files.isEmpty
                                ? const SizedBox.shrink()
                                : Container(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    height: 300,
                                    child: Scrollbar(
                                      thumbVisibility:
                                          true, //always show scrollbar
                                      thickness: 4, //width of scrollbar
                                      radius: Radius.circular(
                                          20), //corner radius of scrollbar
                                      controller: _scrollController,
                                      child: SingleChildScrollView(
                                        controller: _scrollController,
                                        child: Column(
                                          children: [
                                            for (var image in files)
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                height: 150,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Image.file(
                                                    image,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: loadLocation
                                  ? CircularProgressIndicator.adaptive()
                                  : ElevatedButton(
                                      onPressed: () async {
                                        await checkGps();
                                        setState(() {
                                          isLocation = true;
                                        });
                                      },
                                      child: const Text('Pick Location'),
                                    ),
                            ),
                            SizedBox(
                              width: 300,
                              child: Text(
                                style: TextStyle(

                                    // color: Colors.blue,
                                    fontSize: 16),
                                address,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            submitEnquiry(context);
                            pushNotification
                                .getDeviceToken()
                                .then((value) async {
                              var data = {
                                'to': value,
                                'priority': 'high',
                                'notification': {
                                  'title': 'New Enquiry',
                                  'body': '${Globals.garageName}',
                                },
                              };
                              await http.post(
                                  Uri.parse(
                                      'https://fcm.googleapis.com/fcm/send'),
                                  body: jsonEncode(data),
                                  headers: {
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                    'Authorization':
                                        'key=AAAAp4Lx0M8:APA91bEfrvJmS8721wom0MdZd6H6tw9zHnZwISQAMhY_Kd6VhDq20nCS5DX9Q8ONMcKx1IdEdHyAer5eg5taSnUqBIFHZC_2lwqer0VltONmpyHjpnyA3z2TvBepgIXEdkSuBinu-E95'
                                  });
                            });
                          },
                          child: const Text('Submit'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
