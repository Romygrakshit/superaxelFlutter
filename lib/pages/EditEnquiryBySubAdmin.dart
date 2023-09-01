// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:loginuicolors/models/enquriyModel.dart';
import 'package:loginuicolors/services/subAdminService.dart';

class EditEnqSubAdmin extends StatefulWidget {
  EditEnqSubAdmin({
    Key? key,
  }) : super(key: key);

  @override
  State<EditEnqSubAdmin> createState() => _EditEnqSubAdminState();
}

class _EditEnqSubAdminState extends State<EditEnqSubAdmin> {
  final _newOfferedPrice = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String status = '';

  updateEnquiry(BuildContext context, Enquiry enq) async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fill the new fields')));
      return;
    }
    bool success = await SubAdminService.updateEnquiry(
        body: {'id': enq.id.toString(), 'price': _newOfferedPrice.text.trim().toString(), 'status': status});
    if (success) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enquiry Updated Successfully')));
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, 'HomeSubAdmin');
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error in updating enquiry')));
    }
  }

  @override
  Widget build(BuildContext context) {
    Enquiry enqury = ModalRoute.of(context)!.settings.arguments as Enquiry;
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('The id is : ' + enqury.id.toString()),
                Text('The address is : ' + enqury.address),
                Text('The guaranted price is : ' + enqury.offered_price),
                Text('The status is ' + enqury.status),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _newOfferedPrice,
                  validator: (value) {
                    if (value == null) {
                      return 'Enter some value';
                    }
                    if (value.length > 0) {
                      return null;
                    }
                    return 'Enter valid price';
                  },
                  decoration: InputDecoration(
                    label: Text('Enter the new offered price'),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField(
                    isDense: true,
                    value: enqury.status,
                    decoration: InputDecoration(
                      labelText: 'Enter the new Status',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'pending',
                        child: Text('pending'),
                      ),
                      DropdownMenuItem(
                        value: 'Out for delivery',
                        child: Text('Out for delivery'),
                      ),
                      DropdownMenuItem(
                        value: 'Delivered',
                        child: Text('Delivered'),
                      ),
                      DropdownMenuItem(
                        value: 'Cancel',
                        child: Text('Cancel'),
                      ),
                    ],
                    onChanged: (value) {
                      status = value.toString();
                    }),
                Center(
                  child: ElevatedButton(onPressed: () => updateEnquiry(context, enqury), child: Text('Submit Updates')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
