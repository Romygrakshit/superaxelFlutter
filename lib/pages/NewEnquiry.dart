import 'package:flutter/material.dart';

class NewEnquiries extends StatefulWidget {
  const NewEnquiries({super.key});

  @override
  State<NewEnquiries> createState() => _NewEnquiriesState();
}

class _NewEnquiriesState extends State<NewEnquiries> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedOption1;
  String? _selectedOption2;
  String? _selectedOption3;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              value: _selectedOption1,
              items: const [
                DropdownMenuItem(value: 'Option 1', child: Text('Option 1st')),
                DropdownMenuItem(value: 'Option 2', child: Text('Option 2nd')),
                DropdownMenuItem(value: 'Option 3', child: Text('Option 3rd')),
              ],
              hint: const Text('Select an option'),
              onChanged: (value) {
                setState(() {
                  _selectedOption1 = value as String?;
                });
              },
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Select Car',
              ),
              value: _selectedOption2,
              items: const [
                DropdownMenuItem(value: 'Option 1', child: Text('Option 1st')),
                DropdownMenuItem(value: 'Option 2', child: Text('Option 2nd')),
                DropdownMenuItem(value: 'Option 3', child: Text('Option 3rd')),
              ],
              hint: const Text('Select an option'),
              onChanged: (value) {
                setState(() {
                  _selectedOption2 = value as String?;
                });
              },
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Select Axel (left/right)',
              ),
              value: _selectedOption3,
              items: const [
                DropdownMenuItem(value: 'Option 1', child: Text('Option 1st')),
                DropdownMenuItem(value: 'Option 2', child: Text('Option 2nd')),
                DropdownMenuItem(value: 'Option 3', child: Text('Option 3rd')),
              ],
              hint: const Text('Select an option'),
              onChanged: (value) {
                setState(() {
                  _selectedOption3 = value as String?;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Price:',
              ),
              enabled: false,
              initialValue: 'Price',
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
