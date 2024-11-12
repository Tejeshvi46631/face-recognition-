import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geofence/Screen/login.dart';
import 'package:geofence/Screen/myreport.dart';
import 'package:provider/provider.dart';
import 'API/loginapi.dart';
import 'Screen/piechartdata.dart';
import 'Screen/teamreport.dart';
import 'provider/FaceBoundingBoxProvider .dart';
import 'provider/getlocation.dart';
import 'provider/Image_Provider.dart'
    as CustomImageProvider; // Use alias for the custom ImageProvider

import 'Screen/datewisereport.dart';
import 'Screen/register.dart';
import 'Screen/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocationProvider()),
          ChangeNotifierProvider(create: (_) => LoginAPI()),
          ChangeNotifierProvider(create: (_) => FaceBoundingBoxProvider()),
          ChangeNotifierProvider<CustomImageProvider.ImageProvider>(
              create: (_) =>
                  CustomImageProvider.ImageProvider()), // Use the alias here
          // Add ImageProvider here

          // Add more providers if needed
        ],
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geofence Attendance System',
      theme: ThemeData(),

      //home: piechart(),
      home: const Login(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/register': (context) => Register(),
        '/login': (context) => const Login(),
        '/welcomescreen': (context) => welcomescreen(),
        '/myreport': (context) => const MyReportScreen(),
        '/datewise': (context) => const Datewise(),
        '/teamreport': (context) => const Teamreport(),
        '/piechart': (context) => const piechart(),
      },
    );
  }
}
