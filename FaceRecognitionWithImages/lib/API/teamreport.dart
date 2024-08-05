import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../Constant/api.dart';

class TeamreportAPI {
  Constants constantsInstance = Constants();

  Future<List<Map<String, dynamic>>> teamreport(
      String employeeId, BuildContext context) async {
    try {
      print("Date: ");

      var myReportApi = "${Constants.IP_HEADER}/GetListEmplyeeForfla";
      var requestUrl = Uri.parse(myReportApi);

      // Make the API call
      var response = await http.post(
        requestUrl,
        body: {
          'emp_id': '215801',
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.body);
        // Parse the JSON response
        List<Map<String, dynamic>> responseData =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        print("DateWiseData");
        print(responseData);
        // Handle the data
        for (var data in responseData) {
          print('Date: ${data['empname']}, empid: ${data['empid']}');
          // Add your logic to handle each data entry
        }

        return responseData; // Return the list of maps
      } else {
        // API call failed, handle the error
        print('API Call Failed: ${response.statusCode}');
        return []; // Return an empty list or handle the error case
      }
    } catch (e) {
      // Handle exceptions
      print('Exception during API call: $e');
      return []; // Return an empty list or handle the error case
    }
  }
}
