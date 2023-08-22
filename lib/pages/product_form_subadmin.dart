import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:loginuicolors/models/cars.dart';
import 'package:loginuicolors/models/companies.dart';
import 'package:loginuicolors/models/product_subadmin.dart';
import 'package:loginuicolors/models/statesDecode.dart';
import 'package:loginuicolors/services/enquiryService.dart';
import 'package:loginuicolors/services/garagesService.dart';
import 'package:loginuicolors/services/subAdminService.dart';
import 'package:loginuicolors/utils/Globals.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class ProductFormSubAdmin extends StatefulWidget {
  const ProductFormSubAdmin({super.key});

  @override
  State<ProductFormSubAdmin> createState() => _ProductFormSubAdminState();
}

class _ProductFormSubAdminState extends State<ProductFormSubAdmin> {
  List<ProductSUbadmin> productSubadmin = [];
  bool isFetchLoading = true;
  @override
  void initState() {
    super.initState();
    SubAdminService.getProductEnquiryListSubAdmin(Globals.subAdminId).then((value) {
      setState(() {
        isFetchLoading = false;
        productSubadmin = [];
        productSubadmin.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("subAdmin id is ${Globals.subAdminId}");
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: isFetchLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : productSubadmin.isEmpty
                ? Center(
                    child: Text("Products are empty"),
                  )
                : ListView.builder(
                    itemCount: productSubadmin.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Car Id : " + productSubadmin[index].carId.toString()),
                                Divider(),
                                Text("Company Id : " + productSubadmin[index].companyId.toString()),
                                Divider(),
                                Text("Category Id : " + productSubadmin[index].categoryId.toString()),
                                Divider(),
                                Text("Garage Id : " + productSubadmin[index].garageId.toString()),
                              ],
                            ),
                            subtitle: Text("Price: " + productSubadmin[index].price.toString()),
                            trailing: Text("State: " + productSubadmin[index].state.toString()),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
