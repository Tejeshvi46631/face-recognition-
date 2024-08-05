import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../API/loginapi.dart';
import '../Animation/signuptext.dart';
import '../Network/NetworkSensitiveScreen.dart';
import '../ShowDailogAlert/registerdialog.dart';
import '../ShowDailogAlert/rootdetection.dart';
import '../provider/getlocation.dart';
import '../themes/appcolor.dart';
import '../themes/fontsize.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  LoginAPI login = LoginAPI();
  Color rgbaColor(int r, int g, int b, int a) {
    return Color.fromRGBO(r, g, b, a / 255);
  }

  late SlideAnimationManager _slideAnimationManager;
  late final TextEditingController _employeId = TextEditingController();
  LocationProvider locationscreen = LocationProvider();
  Rect? boundingBox;
  @override
  void initState() {
    super.initState();
    _slideAnimationManager = SlideAnimationManager(this);
    _slideAnimationManager.startAnimation();
   // RootDetection.checkJailbreakOnInit(context);
    Provider.of<LocationProvider>(context, listen: false).getDeviceInfo();
  }

  @override
  void dispose() {
    _slideAnimationManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: EdgeInsets.only(left: 35, top: 130),
              child: Text(
                'Attendance\nSystem',
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
                      child: Column(
                        children: [
                          TextField(
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Employee Id",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )
                            ),
                            keyboardType: TextInputType.number,
                            controller: _employeId,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sign in',
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () async {
                                      if (_employeId.text.isNotEmpty) {
                                        await login.Login(_employeId.text, context);
                                        Provider.of<LoginAPI>(context, listen: false)
                                            .userid = _employeId.text;
                                      } else {
                                        DialogUtils.showdailoginvalidemployeeid(
                                            context);
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
                                  Navigator.pushNamed(context, '/register');
                                },
                                child: Text(
                                  "Don't have an account? Sign up",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18),
                                ),
                                style: ButtonStyle(),
                              ),
                              // TextButton(
                              //     onPressed: () {},
                              //     child: Text(
                              //       'Forgot Password',
                              //       style: TextStyle(
                              //         decoration: TextDecoration.underline,
                              //         color: Color(0xff4c505b),
                              //         fontSize: 18,
                              //       ),
                              //     )),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
        Visibility(
          child: Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Image.asset(
                    'assets/footer.jpg',
                    width: 120,
                    height: 90,
                  ),
                ),
                Text(
                  'Powered by Mobile Seva',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ],
              ),
            ),

          )

          ],
        ),
      ),
    );
  }
}
