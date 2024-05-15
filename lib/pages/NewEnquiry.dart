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
  bool isLoading = false;

  bool loadLocation = false;

  // Locator
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;

  final ScrollController _scrollController = ScrollController();
  final PushNotifications pushNotification = PushNotifications();

  void submitEnquiry(BuildContext context) async {
    setState(() {
      isLoading = true; // Set isLoading to true
    });
    // Send Enquiry to Backend
    EnquiryService.createEnquiry(
      files,
      address,
      lat.toString(),
      long.toString(),
      _selectedCompany.toString(),
      _selectedCarName.toString(),
      _selectedAxel.toString(),
      priceOfEnquiry,
      context,
    );

    setState(() {
      isLoading = false; // Set isLoading to false after API call is completed
    });

    // Send notification to SubAdmin
    // await PushNotifications.showSimpleNotification(
    //     id: Globals.subAdminId,
    //     fcmToken: Globals.subAdminDeviceToken,
    //     title: "New Enquiry Created",
    //     body: Globals.garageName,
    //     payload: _selectedCarName.toString());
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
    setState(() {
      loadLocation = true;
    });
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
        await getLocation();
      }
    } else {
      debugPrint("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      loadLocation = false;
    });
  }

  Future<void> getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint(position.longitude.toString());
    debugPrint(position.latitude.toString());

    setState(() {
      long = position.longitude;
      lat = position.latitude;
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
              center: LatLong(lat, long),
              onPicked: (pickedData) {
                setState(() {
                  lat = pickedData.latLong.latitude;
                  long = pickedData.latLong.longitude;
                  address = pickedData.addressName;
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
                            child: Text(company.company),
                          )
                      ],
                      hint: const Text('Select an option'),
                      onChanged: (value) async {
                        setState(() {
                          companySelected = false;
                          _selectedCompany = value.toString();
                          carSelected = false;
                          _selectedCar = null;
                          _selectedCarName = null;
                        });
                        List<Cars> cars =
                            await GaragesService.getAllCars(value.toString());

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
                              value: car.id,
                              child: Text(car.carName),
                            )
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
                              const SnackBar(content: Text('No Prices Found')),
                            );
                            return;
                          }
                          setState(() {
                            _selectedCar = int.parse(value.toString());
                            carSelected = true;
                            left = response[0];
                            right = response[1];
                          });
                        },
                      ),
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
                            _selectedAxel = value.toString();
                            switch (value) {
                              case "Left":
                                axelSelected = true;
                                priceOfEnquiry = left;
                                break;
                              case "Right":
                                axelSelected = true;
                                priceOfEnquiry = right;
                                break;
                              default:
                                axelSelected = true;
                                priceOfEnquiry = 'Left: $left\nRight: $right';
                                break;
                            }
                          });
                        },
                      ),
                    ],
                    const SizedBox(
                      height: 20,
                    ),
                    if (axelSelected)
                      Center(
                        child: Text(
                          'Price : $priceOfEnquiry',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
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
                                child: const Text('Add Images'),
                              ),
                            ),
                            Text('${files.length} images selected'),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: const Text(
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
                                          true, // Always show scrollbar
                                      thickness: 4, // Width of scrollbar
                                      radius: const Radius.circular(
                                          20), // Corner radius of scrollbar
                                      controller: _scrollController,
                                      child: SingleChildScrollView(
                                        controller: _scrollController,
                                        child: Column(
                                          children: [
                                            for (var image in files)
                                              Container(
                                                margin:
                                                    const EdgeInsets.all(10),
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
                                  ? const CircularProgressIndicator.adaptive()
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
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
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
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_selectedCompany == null ||
                                    _selectedCompany!.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Please select a company")),
                                  );
                                } else if (_selectedCarName == null ||
                                    _selectedCarName!.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Please select a car")),
                                  );
                                } else if (_selectedAxel == null ||
                                    _selectedAxel!.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Please select car axle")),
                                  );
                                } else if (files.isEmpty || files.length == 0) {
                                  EnquiryService.createEnquiryWithoutImage(
                                      address,
                                      lat.toString(),
                                      long.toString(),
                                      _selectedCompany.toString(),
                                      _selectedCarName.toString(),
                                      _selectedAxel.toString(),
                                      priceOfEnquiry,
                                      context);
                                } else {
                                  submitEnquiry(context);
                                }
                              },
                              child: const Text('Submit'),
                            ),
                          ),
                          if (isLoading)
                            const Positioned.fill(
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
