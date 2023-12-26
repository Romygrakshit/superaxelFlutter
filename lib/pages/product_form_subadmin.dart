import 'package:flutter/material.dart';
import 'package:loginuicolors/services/subAdminService.dart';
import 'package:loginuicolors/utils/Globals.dart';
import 'package:share_plus/share_plus.dart';

import '../models/product_subadmin.dart';

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
    SubAdminService.getProductEnquiryListSubAdmin(Globals.subAdminId)
        .then((value) {
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
      // backgroundColor: Colors.black,
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
                        color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Car name : " +
                                          productSubadmin[index]
                                              .carName
                                              .toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Divider(color: Colors.white),
                                    Text(
                                        "Company Name : " +
                                            productSubadmin[index]
                                                .company
                                                .toString(),
                                        style: TextStyle(color: Colors.white)),
                                    Divider(color: Colors.white),
                                    Text(
                                        "Category Name : " +
                                            productSubadmin[index]
                                                .categoryName
                                                .toString(),
                                        style: TextStyle(color: Colors.white)),
                                    Divider(color: Colors.white),
                                    Text(
                                        "Garage Contact (name) : " +
                                            productSubadmin[index]
                                                .garageName
                                                .toString(),
                                        style: TextStyle(color: Colors.white)),
                                    Divider(color: Colors.white),
                                  ],
                                ),
                                subtitle: Text(
                                    "Price: " +
                                        productSubadmin[index].price.toString(),
                                    style: TextStyle(color: Colors.white)),
                                trailing: Text(
                                    "State: " +
                                        productSubadmin[index].state.toString(),
                                    style: TextStyle(color: Colors.white)),
                              ),
                              Positioned(
                                right: 20,
                                bottom: 0,
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                    ),
                                    onPressed: () async {
                                      String textToShare = """
Product Id : ${productSubadmin[index].id}
Car Name: ${productSubadmin[index].carName}
Company Name: ${productSubadmin[index].company}
Category Name: ${productSubadmin[index].categoryName}
Garage name (contact): ${productSubadmin[index].garageName}
Price: ${productSubadmin[index].price}
Map location: http://maps.google.com/maps?z=12&t=m&q=loc:${productSubadmin[index].lat}+${productSubadmin[index].lng}
                                      """;
                                      await Share.share('$textToShare');
                                    },
                                    child: Text("Share"),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
