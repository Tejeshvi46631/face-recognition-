import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../Constant/api.dart';
import '../provider/getlocation.dart';
import 'package:ntp/ntp.dart';


class attendacnce extends ChangeNotifier {
  Constants constantsInstance = Constants();

  late final Uri apiUrl;


  Future<void> attendanceapi(
      String userId,
      BuildContext context,
      LocationProvider locationProvider,
      ) async {
    try {
      print("Values of attendance");

      // Fetch the current time from NTP server
      DateTime ntpTime = await NTP.now();
      String currentDate = DateFormat("dd-MM-yyyy HH:mm:ss").format(ntpTime);
      print("currentDate ");
      print(currentDate);

      String leaveValue = true.toString();

      // Access location parameters from LocationProvider
      double? latitude = locationProvider.latitude;
      double? longitude = locationProvider.longitude;
      String? postalCode = locationProvider.postalCode;
      String? sublocality = locationProvider.sublocality;
      String? administrativeArea = locationProvider.administrativeArea;
      String? locality = locationProvider.locality;
      String? country = locationProvider.country;
      String? workLocation = locationProvider.workLocation;

      print("LATITUDE: $latitude");
      print("LONGITUDE: $longitude");
      print("POSTAL CODE: $postalCode");
      print("SUBLOCALITY: $sublocality");
      print("ADMINISTRATIVE AREA: $administrativeArea");
      print("LOCALITY: $locality");
      print("COUNTRY: $country");
      print("WORK LOCATION: $workLocation");

      // Specify the API endpoint URL
      var attendanceapi = "http://164.100.112.121/GeoFenceAttendenceMarked/api/AttendenceMarkin";
      var apiUrl = Uri.parse(attendanceapi);

      // Create the request URL with the query parameter
      var requestUrl = apiUrl.replace(
        queryParameters: {
          'emp_id': userId,
          'date': currentDate,
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
          'workinglocation': workLocation,
          'leave': leaveValue,
          'remark': "remark",
        },
      );
      print(requestUrl);

      // Make the POST request
      try {
        final response = await http.post(
          requestUrl,
          headers: {'Content-Type': 'application/json'},
        );
        print(response.statusCode);
        if (response.statusCode == 200) {
          print("Successfully");
          Navigator.pushNamed(context, '/myreport');
        } else {
          // Handle error when the server responds with an error status code
          print('Error: ${response.statusCode}');
        }
      } catch (error) {
        // Handle any exceptions that occurred during the request
        print('Error: $error');
      }
    } catch (error) {
      // Handle any exceptions that occurred during the request
      print('Error: $error');
    }

  }
}
