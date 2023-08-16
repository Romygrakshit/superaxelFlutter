import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:loginuicolors/models/cars.dart';
import 'package:loginuicolors/models/companies.dart';
import 'package:loginuicolors/models/statesDecode.dart';
import 'package:loginuicolors/services/enquiryService.dart';
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
  String? _selectedAxel;
  List<File> files = [];
  bool isLocation = false;
  double lat = 0;
  double long = 0;
  String address = '';
  bool CompanySelected = false;
  bool CarSelected = false;
  bool AxelSelected = false;
  String priceOfEnquiry = '';
  String left = '';
  String right = '';

  void submitEnquiry(BuildContext context) async {
    EnquiryService.createEnquiry(
        files,
        address,
        lat.toString(),
        long.toString(),
        _selectedCompany.toString(),
        _selectedCar.toString(),
        _selectedAxel.toString(),
        priceOfEnquiry,
        context);
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

  @override
  Widget build(BuildContext context) {
    return isLocation
        ? Scaffold(
            body: OpenStreetMapSearchAndPick(
              center: LatLong(26.82, 75.85),
              onPicked: (pickedData) {
                lat = pickedData.latLong.latitude;
                long = pickedData.latLong.longitude;
                address = pickedData.address;
                log(pickedData.latLong.latitude.toString());
                log(pickedData.latLong.longitude.toString());
                log(pickedData.address);
                isLocation = false;
                setState(() {});
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
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
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
                        List<Cars> cars =
                            await GaragesService.getAllCars(value.toString());
                        Globals.allCars = cars;
                        setState(() {
                          _selectedCompany = value.toString();
                          CompanySelected = true;
                        });
                      },
                    ),
                    if (CompanySelected)
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Select Car',
                        ),
                        value: _selectedCar,
                        items: [
                          for (Cars car in Globals.allCars)
                            DropdownMenuItem(
                                value: car.id, child: Text("${car.car_name}"))
                        ],
                        hint: const Text('Select an option'),
                        onChanged: (value) async {
                          var response = await GaragesService.getPrices(
                              int.parse(value.toString()), Globals.garageId);
                          left = response[0];
                          right = response[1];
                          log('$left and $right');
                          setState(() {
                            _selectedCar = int.parse(value.toString());
                            CarSelected = true;
                          });
                        },
                      ),
                    if (CarSelected)
                      DropdownButtonFormField(
                        value: _selectedAxel,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
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
                            AxelSelected = true;
                          });
                        },
                      ),

                    // if (CarSelected)
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
                    if (AxelSelected)
                      Center(
                          child: Text(
                        'Price : $priceOfEnquiry',
                        style: TextStyle(fontSize: 25),
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
                                  'If Uploaded Photos, we will provide guaranteed prices',
                                  style: TextStyle(fontSize: 13),
                                  textDirection: TextDirection.ltr,
                                  maxLines: 2,
                                )),
                            Column(
                              children: [
                                for (var image in files)
                                  Container(
                                      margin: EdgeInsets.all(10),
                                      height: 100,
                                      child: Image.file(image))
                              ],
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  isLocation = true;
                                  setState(() {});
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
                          onPressed: () => submitEnquiry(context),
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
