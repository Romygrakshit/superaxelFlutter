import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:loginuicolors/models/cars.dart';
import 'package:loginuicolors/models/companies.dart';
import 'package:loginuicolors/services/enquiryService.dart';
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
  String? _selectedCar;
  String? _selectedAxel;
  List<File> files = [];
  bool isLocation = false;
  double lat = 0;
  double long = 0;
  String address = '';
  TextEditingController _price = TextEditingController();

  void submitEnquiry(BuildContext context) async {
     EnquiryService.createEnquiry(
        files,
        address,
        lat.toString(),
        long.toString(),
        _selectedCompany.toString(),
        _selectedCar.toString(),
        _selectedAxel.toString(),
        _price.text , context);
    
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
                      onChanged: (value) {
                        setState(() {
                          _selectedCompany = value.toString();
                        });
                      },
                    ),
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Select Car',
                      ),
                      items: [
                        for (Cars car in Globals.allCars)
                          DropdownMenuItem(
                              value: car.car_name,
                              child: Text("${car.car_name}"))
                      ],
                      hint: const Text('Select an option'),
                      onChanged: (value) {
                        setState(() {
                          _selectedCar = value.toString();
                        });
                      },
                    ),
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Select Axel (left/right)',
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Left', child: Text('Left')),
                        DropdownMenuItem(value: 'Right', child: Text('Right')),
                      ],
                      hint: const Text('Select an option'),
                      onChanged: (value) {
                        setState(() {
                          _selectedAxel = value as String?;
                        });
                      },
                    ),
                    TextFormField(
                      controller: _price,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Price:',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
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
                            Text(lat.toString()),
                            Text(long.toString()),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () => submitEnquiry(context),
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
