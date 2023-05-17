import 'package:flutter/material.dart';
import 'package:loginuicolors/models/enquriyModel.dart';

class EditEnqSubAdmin extends StatelessWidget {
  EditEnqSubAdmin({super.key});

  final _newOfferedPrice = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  updateEnquiry() {

    
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
                    decoration: InputDecoration(
                      labelText: 'Enter the new Status',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                        child: Text('pending'),
                      ),
                    ],
                    onChanged: null),
                Center(
                  child: ElevatedButton(
                      onPressed: () => updateEnquiry,
                      child: Text('Submit Updates')),
                ), 
              ],
            ),
          ),
        ),
      ),
    );
  }
}
