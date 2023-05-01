// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// // import 'package:loginuicolors/circle_bg.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => HomeState();
// }

// class HomeState extends State<Home> {
//   int _selectedIndex = 0;
//   static const TextStyle optionStyle =
//       TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
//   static const List<Widget> _widgetOptions = <Widget>[
//     PastEnquiries(optionStyle: optionStyle),
//     NewEnquiry(optionStyle: optionStyle),
//     Profile(optionStyle: optionStyle),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Meri gaddi hegi kali'),
//       ),
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.featured_play_list),
//             label: 'Past Enquiries',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.add_box_rounded),
//             label: 'New Enquiry',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.account_box_rounded),
//             label: 'Profile',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

// class Profile extends StatelessWidget {
//   const Profile({
//     super.key,
//     required this.optionStyle,
//   });

//   final TextStyle optionStyle;

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       'Index 2: School',
//       style: optionStyle,
//     );
//   }
// }

// class NewEnquiry extends StatefulWidget {
//   const NewEnquiry({
//     super.key,
//     required this.optionStyle,
//   });

//   final TextStyle optionStyle;

//   @override
//   State<NewEnquiry> createState() => NewEnquiryForm();
// }

// class NewEnquiryForm extends State<NewEnquiry> {
//   final _formKey = GlobalKey<FormState>();
//   String? _selectedOption1;
//   String? _selectedOption2;
//   String? _selectedOption3;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             DropdownButtonFormField(
//               decoration: const InputDecoration(
//                 border: UnderlineInputBorder(),
//                 labelText: 'Select Company',
//               ),
//               value: _selectedOption1,
//               items: const [
//                 DropdownMenuItem(value: 'Option 1', child: Text('Option 1st')),
//                 DropdownMenuItem(value: 'Option 2', child: Text('Option 2nd')),
//                 DropdownMenuItem(value: 'Option 3', child: Text('Option 3rd')),
//               ],
//               hint: const Text('Select an option'),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedOption1 = value as String?;
//                 });
//               },
//             ),
//             DropdownButtonFormField(
//               decoration: const InputDecoration(
//                 border: UnderlineInputBorder(),
//                 labelText: 'Select Car',
//               ),
//               value: _selectedOption2,
//               items: const [
//                 DropdownMenuItem(value: 'Option 1', child: Text('Option 1st')),
//                 DropdownMenuItem(value: 'Option 2', child: Text('Option 2nd')),
//                 DropdownMenuItem(value: 'Option 3', child: Text('Option 3rd')),
//               ],
//               hint: const Text('Select an option'),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedOption2 = value as String?;
//                 });
//               },
//             ),
//             DropdownButtonFormField(
//               decoration: const InputDecoration(
//                 border: UnderlineInputBorder(),
//                 labelText: 'Select Axel (left/right)',
//               ),
//               value: _selectedOption3,
//               items: const [
//                 DropdownMenuItem(value: 'Option 1', child: Text('Option 1st')),
//                 DropdownMenuItem(value: 'Option 2', child: Text('Option 2nd')),
//                 DropdownMenuItem(value: 'Option 3', child: Text('Option 3rd')),
//               ],
//               hint: const Text('Select an option'),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedOption3 = value as String?;
//                 });
//               },
//             ),
//             TextFormField(
//               decoration: const InputDecoration(
//                 border: UnderlineInputBorder(),
//                 labelText: 'Price:',
//               ),
//               enabled: false,
//               initialValue: 'Price',
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 16.0),
//               child: ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Processing Data')),
//                     );
//                   }
//                 },
//                 child: const Text('Submit'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PastEnquiries extends StatelessWidget {
//   const PastEnquiries({
//     super.key,
//     required this.optionStyle,
//   });

//   final TextStyle optionStyle;

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       'Index 0: Home',
//       style: optionStyle,
//     );
//   }
// }
