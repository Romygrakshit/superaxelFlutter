import 'package:flutter/material.dart';
import 'package:loginuicolors/pages/login.dart';
import 'package:loginuicolors/services/garagesService.dart';

class LoginSubAdmin extends StatefulWidget {
  const LoginSubAdmin({super.key});

  @override
  State<LoginSubAdmin> createState() => _LoginSubAdminState();
}

class _LoginSubAdminState extends State<LoginSubAdmin> {
  TextEditingController mobNumber = TextEditingController();
  TextEditingController _password = TextEditingController();
  final _loginKey = GlobalKey<FormState>();

  login(BuildContext context) async {
    GaragesService().loginSubAdmin(context, mobNumber.text, _password.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomPaint(
          painter: RedBlackPainter(),
          child: Stack(
            children: [
              Container(),
              Container(
                padding: EdgeInsets.only(left: 35, top: 130),
                child: Text(
                  'Welcome\nAdmin',
                  style: TextStyle(color: Colors.white, fontSize: 33),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 35, right: 35),
                        child: Form(
                          key: _loginKey,
                          child: Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: mobNumber,
                                style: TextStyle(color: Colors.black),
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
                              TextFormField(
                                style: TextStyle(),
                                controller: _password,
                                obscureText: true,
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "Password",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pushReplacementNamed(
                                              context, 'login'),
                                      child: Text(
                                        "Login as Garage Owner",
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 18,
                                        ),
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Sign in',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 27,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                    child: IconButton(
                                        color: Color.fromARGB(255, 2, 2, 2),
                                        onPressed: () {
                                          login(context);
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
                            ],
                          ),
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
