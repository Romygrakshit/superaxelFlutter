import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  TextEditingController _garageName = TextEditingController();
  TextEditingController _mobNumber = TextEditingController();

  File _image = File('');

  bool imageloaded = false;

  addImage() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        _image = File(result.files.single.path.toString());
      }

      
      imageloaded = true;

      setState(() {});
    } catch (error) {
      log(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: CustomPaint(
          painter: BlackRedPainter(),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(left: 35, top: 30),
                child: Text(
                  'Create\nAccount',
                  style: TextStyle(color: Colors.white, fontSize: 33),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            imageloaded
                                ? GestureDetector(
                                    onTap: () => addImage(),
                                    child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(125),
                                            border: Border.all(
                                                color: Colors.red, width: 2)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(125),
                                          child: Image.file(
                                            _image,
                                            fit: BoxFit.cover,
                                            height: 250,
                                            width: 250,
                                          ),
                                        )),
                                  )
                                : DottedBorder(
                                    borderType: BorderType.Circle,
                                    radius: const Radius.circular(10),
                                    strokeCap: StrokeCap.round,
                                    dashPattern: const [10, 4],
                                    child: GestureDetector(
                                      onTap: () => addImage(),
                                      child: Container(
                                        height: 250,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        width: 250,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(Icons.add_a_photo_outlined),
                                              Text("Add Image"),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: _garageName,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: "Garage Name",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: _mobNumber,
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: "Mobile Number",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            DropdownButtonFormField(
                              items: [
                                DropdownMenuItem(
                                  value: '1234',
                                  child: Text('Garage City 1'),
                                ),
                                DropdownMenuItem(
                                  value: '5678',
                                  child: Text('Garage City 2'),
                                ),
                                DropdownMenuItem(
                                  value: '91011',
                                  child: Text('Garage City 3'),
                                ),
                              ],
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: "Select City",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              onChanged: (value) {
                                // Handle selected value
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            DropdownButtonFormField(
                              items: [
                                DropdownMenuItem(
                                  value: '1234',
                                  child: Text('Garage State 1'),
                                ),
                                DropdownMenuItem(
                                  value: '5678',
                                  child: Text('Garage State 2'),
                                ),
                                DropdownMenuItem(
                                  value: '91011',
                                  child: Text('Garage State 3'),
                                ),
                              ],
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: "Select State",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              onChanged: (value) {
                                // Handle selected value
                              },
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 27,
                                      fontWeight: FontWeight.w700),
                                ),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Color(0xff4c505b),
                                  child: IconButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        Navigator.pushNamed(context, 'Home');
                                      },
                                      icon: Icon(
                                        Icons.arrow_forward,
                                      )),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, 'login');
                                  },
                                  child: Text(
                                    'Sign In',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.white,
                                        fontSize: 18),
                                  ),
                                  style: ButtonStyle(),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
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

class BlackRedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = Color.fromARGB(255, 0, 0, 0);
    canvas.drawPath(mainBackground, paint);

    Path ovalPath = Path();
    ovalPath.moveTo(0, height * 0.2);
    ovalPath.quadraticBezierTo(
        width * 0.45, height * 0.25, width * 0.5, height * 0.5);

    ovalPath.quadraticBezierTo(width * 0.6, height * 0.8, width * 0.1, height);
    ovalPath.lineTo(0, height);
    ovalPath.close();
    paint.color = Color.fromARGB(255, 184, 0, 0);
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
