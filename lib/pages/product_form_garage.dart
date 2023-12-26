import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loginuicolors/models/cars.dart';
import 'package:loginuicolors/models/category.dart';
import 'package:loginuicolors/models/companies.dart';
import 'package:loginuicolors/models/price.dart';
import 'package:loginuicolors/services/garagesService.dart';
import 'package:loginuicolors/utils/Globals.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({super.key});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedCompany;
  int? _selectedCar;
  int? _selectedCategory;
  List<File> files = [];
  bool isLocation = false;
  double lat = 0;
  double long = 0;
  String address = '';
  bool companySelected = false;
  bool carSelected = false;
  bool categorySelected = false;
  int priceOfEnquiry = 0;
  String left = '';
  String right = '';

  bool isSubmitProduct = false;

  // locator
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;

  bool loadLocation = false;

  void submitProduct(BuildContext context) async {
    setState(() {
      isSubmitProduct = true;
    });
    final res = await GaragesService.submitProduct(
      carId: _selectedCar!,
      categoryId: _selectedCategory!,
      garageId: Globals.garageId,
      companyId: _selectedCompany!,
      price: priceOfEnquiry,
      lat: lat.toString(),
      long: long.toString(),
      address: address,
    );

    setState(() {
      isSubmitProduct = false;
    });

    debugPrint("res: $res");

    if (res['success'] == true) {
      // clear the form
      setState(() {
        _formKey.currentState!.reset();

        _selectedCompany = null;
        _selectedCar = null;
        _selectedCategory = null;
        priceOfEnquiry = 0;
        companySelected = false;
        carSelected = false;
        categorySelected = false;
        lat = 0;
        long = 0;
        address = '';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product Added Successfully'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product Not Added'),
        ),
      );
    }
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

  bool checkIfTheDataForSubmitComplete() {
    if (_selectedCompany == null ||
        _selectedCar == null ||
        _selectedCategory == null ||
        priceOfEnquiry == 0) {
      return false;
    }

    return true;
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
  Widget build(BuildContext context) {
    return isLocation
        ? OpenStreetMapSearchAndPick(
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
          )
        : Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Select Company',
                      ),
                      value: _selectedCompany,
                      items: [
                        for (Companies company in Globals.allCompanies)
                          DropdownMenuItem(
                            value: company.id,
                            child: Text("${company.company}"),
                          )
                      ],
                      hint: const Text('Select an option'),
                      onChanged: (value) async {
                        final selectedCardName = Globals.allCompanies
                            .where((element) => element.id == value)
                            .first
                            .company;
                        setState(() {
                          companySelected = false;
                        });
                        List<Cars> cars =
                            await GaragesService.getAllCars(selectedCardName);
                        setState(() {
                          Globals.allCars = [];
                          _selectedCompany = value as int;
                          carSelected = false;
                          _selectedCar = null;
                        });

                        setState(() {
                          companySelected = true;
                          Globals.allCars = cars;
                        });
                      },
                    ),
                    if (companySelected) ...[
                      const SizedBox(height: 20),
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
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
                          var response = await GaragesService.getAllCategory();

                          if (response.isNotEmpty) {
                            setState(() {
                              carSelected = true;
                              Globals.allCategoryItems = response;
                              _selectedCar = value as int;
                            });
                          }
                          debugPrint("response: ${response.toString()}");
                        },
                      )
                    ],
                    if (carSelected) ...[
                      const SizedBox(height: 20),
                      DropdownButtonFormField(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Select Category',
                        ),
                        items: [
                          for (CategoryItems catItems
                              in Globals.allCategoryItems)
                            DropdownMenuItem(
                                value: catItems.id,
                                child: Text("${catItems.categoryName}"))
                        ],
                        hint: const Text('Select an option'),
                        onChanged: (value) async {
                          setState(() {
                            _selectedCategory = value as int;
                            categorySelected = true;
                          });
                          List<Price> price =
                              await GaragesService.getProductPrice(
                                  carId: _selectedCar!,
                                  categoryId: _selectedCategory!,
                                  garageId: Globals.garageId);

                          if (price.isNotEmpty) {
                            setState(() {
                              priceOfEnquiry = price[0].price;
                            });
                          } else {
                            setState(() {
                              priceOfEnquiry = 0;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Price not available'),
                              ),
                            );
                          }
                          debugPrint("price $price");
                        },
                      ),
                    ],
                    if (categorySelected && priceOfEnquiry != 0) ...[
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          'Price : $priceOfEnquiry',
                          style: TextStyle(fontSize: 25),
                        ),
                      )
                    ],
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          width: 200,
                          height: 40,
                          child: loadLocation
                              ? Center(
                                  child: CircularProgressIndicator.adaptive())
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
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 300,
                          child: Text(
                            style: TextStyle(fontSize: 16),
                            address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    isSubmitProduct
                        ? Center(
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Container(
                            width: 200,
                            height: 40,
                            // padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: checkIfTheDataForSubmitComplete()
                                  ? () => submitProduct(context)
                                  : null,
                              child: const Text('Submit'),
                            ),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
