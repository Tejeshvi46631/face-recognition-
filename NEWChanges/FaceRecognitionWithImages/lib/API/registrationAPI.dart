import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../atendancetable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geofence/Screen/register.dart';
import '../Constant/api.dart';

class ApiClient {
  Constants constantsInstance = Constants();
// Select Designation API Call
  static Future<List<String>> fetchDesignationList() async {
    var designationAPI =
        "${Constants.IP_HEADER}/DesignationList"; // Use constantsInstance here
    print(designationAPI);

    final apiUrl = Uri.parse(designationAPI);

    String serverUrl = "http://164.100.112.121/GeoFenceAPI";

    try {
      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Parse the response JSON and return the list of designations
        List<dynamic> jsonResponse = jsonDecode(response.body);
        List<String> designations =
            jsonResponse.map((item) => item['designation'].toString()).toList();

        return designations;
      } else {
        // Handle error when the server responds with an error status code
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      // Handle any exceptions that occurred during the request
      print('Error: $error');
      return [];
    }
  }

  // Select FLA List
  static Future<List<String>> fetchFLAList() async {
    var designationAPI =
        "${Constants.IP_HEADER}/FetchflalistService"; // Use constantsInstance here
    print(designationAPI);

    final apiUrl = Uri.parse(designationAPI);

    try {
      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Parse the response JSON and return the list of designations
        List<dynamic> jsonResponse = jsonDecode(response.body);
        List<String> flanamelist = jsonResponse
            .map((item) => item['employeeName'].toString())
            .toList();

        return flanamelist;
      } else {
        // Handle error when the server responds with an error status code
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      // Handle any exceptions that occurred during the request
      print('Error: $error');
      return [];
    }
  }

  // Registration API Call

  static Future<void> registration({
    required BuildContext context,
    required String name,
    required String password,
    required String email,
    required String mobile,
    required String selectedflaname,
    required String selecteddesignation,
    required String employeeId,
    required bool isFLA,
    required bool isGuidelinesAccepted,
  }) async {
    var registrationAPI =
        "${Constants.IP_HEADER}/AttendenceRegistrationService";
    final apiUrl = Uri.parse(registrationAPI);
    print(apiUrl);

    var requestUrl = apiUrl.replace(queryParameters: {
      "employeeName": name,
      "emailId": email,
      "mobileNumber": mobile,
      "designation": selecteddesignation,
      "isFlaSla": isFLA ? "true" : "false",
      "empId": employeeId,
      "workingLocation": "Mumbai",
      "reportingOfficer": selectedflaname,
      "isVerify": "1",
      "isGuidelinesAccepted": "1",
    });
    try {
      final response = await http.post(
        requestUrl,
        headers: {'Content-Type': 'application/json'},
      );
      // print(response.statusCode);
      // print("RESPONCESS");
      // print(response.body);
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('empid', employeeId);
        prefs.setBool("isFLA", isFLA);
        prefs.setString('name', name);
        Navigator.pushNamed(context, '/login');
        // Parse the response JSON and handle success
        // You can show a success message or navigate to another screen
        // print('Registration Successful');
      } else {
        // Handle error when the server responds with an error status code
        print('Error: ${response.statusCode}');
        // Show an error message to the user
      }
    } catch (error) {
      // Handle any exceptions that occurred during the request
      print('Error: $error');
      // Show an error message to the user
    }
  }

  static Future<void> insertData(
      String name, List<double> embedding, String empid) async {
    print("embdedding----------------------------------");
    print(embedding);
    AttendanceTable data = AttendanceTable(
      columnName: name,
      columnEmbedding: embedding.join(','),
      columnEmpid: empid,
    );

    // Convert the data object to JSON
    Map<String, dynamic> jsonData = data.toJson();

    // Define the URL of your API endpoint
    var url = Uri.parse('http://164.100.112.121/GeoFenceAPI/insert');

    try {
      // Send an HTTP POST request with the JSON data in the body
      var response = await http.post(
        url,
        body: jsonEncode(jsonData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        // Data inserted successfully
        print('Data inserted successfully');
      }
    } catch (e) {
      // Handle any exceptions that occur during the HTTP request
      print('Error: $e');
    }
  }

  static Future<void> insertDataMap(
      String name, List<double> embedding, String empid) async {
    // Convert the data object to JSON
    Map<String, dynamic> jsonData = {};
    jsonData['columnName'] = name;
    jsonData['columnEmbedding'] = embedding.join(',');
    jsonData['columnEmpid'] = empid;

    var url = Uri.parse('http://164.100.112.121/GeoFenceAPI/insert');

    try {
      // Send an HTTP POST request with the JSON data in the body
      var response = await http.post(
        url,
        body: jsonEncode(jsonData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        // Data inserted successfully
        print('Data inserted successfully');
      }
    } catch (e) {
      // Handle any exceptions that occur during the HTTP request
      print('Error: $e');
    }
  }

  static Future<Map<String, dynamic>> insertDataName(
      String name, List<double> embedding, String empid) async {
    String emd = embedding.join(',');

    //Map<String, dynamic> jsonResponse=[];
    var url = Uri.parse('http://164.100.112.121/GeoFenceAPI/getByEmpId?name=' +
        name +
        '?embedding' +
        emd +
        '?empid=' +
        empid);

    Map<String, dynamic> jsonResponse = {};

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Parse the response JSON and return the list of designations
      jsonResponse = jsonDecode(response.body);
      // List<AttendanceTable> attendaceUser = jsonDecode(response.body);
      print("getAllByName");
      print(jsonResponse['columnName']);
    }
    return jsonResponse;
  }

  static Future<List<dynamic>> getAll() async {
    List<dynamic> jsonResponse = [];
    var url = Uri.parse('http://164.100.112.121/GeoFenceAPI/get');

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Parse the response JSON and return the list of designations
      jsonResponse = jsonDecode(response.body);
      // List<AttendanceTable> attendaceUser = jsonDecode(response.body);
      print("jsonResponse");
      print(jsonResponse);
    }
    return jsonResponse;
  }

  static Future<Map<String, dynamic>> getAllByEmpId(String empid) async {
    //Map<String, dynamic> jsonResponse=[];
    var url = Uri.parse(
        'http://164.100.112.121/GeoFenceAPI/getByEmpId?empid=' + empid);

    Map<String, dynamic> jsonResponse = {};

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Parse the response JSON and return the list of designations
      jsonResponse = jsonDecode(response.body);
      // List<AttendanceTable> attendaceUser = jsonDecode(response.body);
      print("getAllByName");
      print(jsonResponse['columnName']);
    }
    return jsonResponse;
  }

  static Future<List<dynamic>> getLatLong() async {
    List<dynamic> jsonResponse = [];
    var url = Uri.parse('http://10.210.8.124:8080/getLatLong');

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Parse the response JSON and return the list of designations
      jsonResponse = jsonDecode(response.body);
      // List<AttendanceTable> attendaceUser = jsonDecode(response.body);
      print("getLatLong");
      print(jsonResponse);
    }
    return jsonResponse;
  }
}
