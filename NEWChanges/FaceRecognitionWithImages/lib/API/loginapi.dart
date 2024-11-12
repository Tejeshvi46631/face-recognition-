import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../Constant/api.dart';
import '../ShowDailogAlert/registerdialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginAPI extends ChangeNotifier {
  String userid="";
  Constants constantsInstance = Constants();
  DialogUtils dialogutil = DialogUtils();
  Future<void> Login(String userId, BuildContext context) async {
    try {
      // Specify the API endpoint URL
      var LoginAPI = "${Constants.IP_HEADER}/AttendenceLoginService";
      //var LoginAPI = "http://10.210.5.208:8081/api/AttendenceLoginService";
      var apiUrl = Uri.parse(LoginAPI);

      // Create the request URL with the query parameter
      var requestUrl = apiUrl.replace(queryParameters: {'userid': userId});

      // Make the GET request
      final response = await http.post(requestUrl);
      print("LOGIN RESPONSE");
      print(response.statusCode);
      print(response.toString());
      String result = response.toString();
      String resp = response.body;
      print("RESULT "+response.body);
      // Check the response status code
      if (resp.isNotEmpty) {
        // Set the userId in the LoginAPI class
    
          Navigator.pushNamed(context, '/welcomescreen');
          // Handle the successful response
          print('API call successful');
          print(response.body);
          notifyListeners();
        
       } 
      else {
        DialogUtils.showdailoginvalidemployeeid(context);
        // Handle error when the server responds with an error status code
        print('Error: ${response.statusCode}');
        print(response.body);
        // Show an error message to the user
      }
    } catch (error) {
      // Handle any exceptions that occurred during the request
      print('Error: $error');
      // Show an error message to the user
    }
  }
  Future<void> LoginReg(String userId, BuildContext context) async {
    try {
      // Specify the API endpoint URL
      var LoginAPI = "${Constants.IP_HEADER}/AttendenceLoginService";
     // var LoginAPI = "http://10.210.5.208:8081/api/AttendenceLoginService";
      var apiUrl = Uri.parse(LoginAPI);

      // Create the request URL with the query parameter
      var requestUrl = apiUrl.replace(queryParameters: {'userid': userId});

      // Make the GET request
      final response = await http.post(requestUrl);
      print("LOGIN RESPONSE");
      print(response.statusCode);
      print(response.toString());
      String result = response.toString();
      String resp = response.body;
      print("RESULT "+response.body);
      // Check the response status code
      if (resp == "true") {
        Fluttertoast.showToast(
          msg: "already register, Please login",
          toastLength: Toast.LENGTH_SHORT, // Duration for which the toast should be displayed
          gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
          timeInSecForIosWeb: 120, // Time for which the iOS toast should be displayed (in seconds)
          backgroundColor: Colors.black.withOpacity(0.7), // Background color of the toast
          textColor: Colors.white, // Text color of the toast
          fontSize: 20.0, // Font size of the toast message
        );
        Navigator.pushNamed(context, '/login');
      }
    } catch (error) {
      // Handle any exceptions that occurred during the request
      print('Error: $error');
      // Show an error message to the user
    }
  }
}
