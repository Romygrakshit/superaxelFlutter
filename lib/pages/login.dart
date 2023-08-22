import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:loginuicolors/services/garagesService.dart';
// import 'package:loginuicolors/circle_bg.dart';

class MyLogin extends HookWidget {
  MyLogin({Key? key}) : super(key: key);

  final _loginKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final mobNumberController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLogin = useState(false);

    Future<void> login(BuildContext context) async {
      await GaragesService.signIn(context, mobNumberController.text, passwordController.text).then((value) => {
            isLogin.value = false,
          });
    }

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
                  'Welcome\nBack',
                  style: TextStyle(color: Colors.white, fontSize: 33),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.5),
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
                                controller: mobNumberController,
                                style: TextStyle(color: Colors.black),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Please enter mobile number";
                                  }
                                  return null;
                                },
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
                                controller: passwordController,
                                obscureText: true,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter password";
                                  }
                                  return null;
                                },
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
                                      onPressed: () => Navigator.pushReplacementNamed(context, 'loginSubAdmin'),
                                      child: Text(
                                        "Login as SubAdmin",
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color.fromARGB(255, 255, 255, 255),
                                          fontSize: 18,
                                        ),
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Sign in',
                                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.w700),
                                  ),
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                                    child: isLogin.value
                                        ? CircularProgressIndicator(
                                            color: Colors.black,
                                          )
                                        : IconButton(
                                            color: Color.fromARGB(255, 2, 2, 2),
                                            onPressed: () async {
                                              if (_loginKey.currentState!.validate()) {
                                                isLogin.value = true;
                                                await login(context);
                                              }
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
                                      Navigator.pushReplacementNamed(context, 'register');
                                    },
                                    child: Text(
                                      'Sign Up',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color.fromARGB(255, 255, 255, 255),
                                          fontSize: 18),
                                    ),
                                    style: ButtonStyle(),
                                  ),
                                  TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Forgot Password',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color.fromARGB(255, 255, 255, 255),
                                          fontSize: 18,
                                        ),
                                      )),
                                ],
                              )
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

class RedBlackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = Color.fromARGB(255, 184, 0, 0);
    canvas.drawPath(mainBackground, paint);

    Path ovalPath = Path();
    ovalPath.moveTo(0, height * 0.2);
    ovalPath.quadraticBezierTo(width * 0.45, height * 0.25, width * 0.5, height * 0.5);

    ovalPath.quadraticBezierTo(width * 0.6, height * 0.8, width * 0.1, height);
    ovalPath.lineTo(0, height);
    ovalPath.close();
    paint.color = Colors.black;
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
