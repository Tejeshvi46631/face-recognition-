import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geofence/Screen/applyleave.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../API/attendanceapi.dart';
import '../API/loginapi.dart';
import '../ShowDailogAlert/registerdialog.dart';
import '../provider/getlocation.dart';
import 'package:geofence/ML/Recognition.dart';
import 'package:geofence/ML/Recognizer.dart';
import '../themes/fontsize.dart';
import 'package:image/image.dart' as img;

import 'shiftSchedule.dart';

class welcomescreen extends StatefulWidget {
  @override
  _welcomescreen createState() => _welcomescreen();
}

class _welcomescreen extends State<welcomescreen> {
  late String currentDate; // Variable to store the current date
  late FontSizeManager fontSizeManager;

  //bool _isButtonDisabled = false;
  attendacnce attendance = attendacnce();
  Rect? boundingBox;

  //final ImagePicker picker = ImagePicker();
  // File? _image;
  DialogUtils Dialogutils = DialogUtils();

  //late FaceDetector faceDetector;

  bool isFLA = false;
  String userId = "";
  bool facedetected = false;
  var image;

  //bool _isDetecting = false;

  File? imageFilestored;

  //late final XFile? image;
  String? imagePathstored;
  String? imagePathcuurent;
  String? hash1;
  bool _imageCaptured = false;
  bool _isDetecting = false;
  bool _isButtonDisabled = false;

  late ImagePicker picker;
  File? _image;

  //TODO declare detector
  late FaceDetector faceDetector;

  //TODO declare face recognizer
  late Recognizer recognizer;

  /// New face detection added here

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fontSizeManager = FontSizeManager(context);

    currentDate = DateFormat.yMd().format(DateTime.now());
    print("DATE:");
    print(currentDate);
  }

  @override
  void initState() {
    super.initState();
    picker = ImagePicker();

    //TODO initialize face detector
    final options = FaceDetectorOptions();
    faceDetector = FaceDetector(options: options);

    //TODO initialize face recognizer
    recognizer = Recognizer();
    // ApiClient.getLatLong();

    //loadBoundingBox();
    //_retrieveImage();
    // final options =
    //     FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate);
    // faceDetector = FaceDetector(options: options);
  }

  Future<void> loadBoundingBox() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isFLA = prefs.getBool('isFLA') ?? false;
  }

  List<Recognition> recognitions = [];

  @override
  Widget build(BuildContext context) {
    // double? latitude = Provider.of<LocationProvider>(context).latitude;
    // double? longitude = Provider.of<LocationProvider>(context).longitude;
    String? postalCode = Provider.of<LocationProvider>(context).postalCode;
    String? sublocality = Provider.of<LocationProvider>(context).sublocality;
    String? administrativeArea =
        Provider.of<LocationProvider>(context).administrativeArea;
    String? locality = Provider.of<LocationProvider>(context).locality;
    String? country = Provider.of<LocationProvider>(context).country;
    userId = Provider.of<LoginAPI>(context).userid;
    recognizer.empIn(userId);

    ElevatedButton captureImageButton = ElevatedButton(
      onPressed: () async {
        await captureImage();
        setState(() {
          _imageCaptured = true;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: SizedBox(
        width: 150.0, // Adjust the width as needed
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          alignment: Alignment.center,
          child: Text(
            'Capture photo',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );

    ElevatedButton submitButton = ElevatedButton(
      onPressed: _isButtonDisabled
          ? null
          : () async {
              setState(() {
                _isDetecting = true;
              });
              await doFaceDetection(context);
              setState(() {
                _isDetecting = false;
              });
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: _isButtonDisabled ? Colors.grey : Colors.blue.shade300,
      ),
      child: _isDetecting
          ? Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 8),
                Text(
                  'Face detection in progress',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            )
          : Text(
              'Submit',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
    );

    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(240.0),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Attendance\nSystem',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 41, 67, 88),
                  ),
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.schedule),
                  title: Text('Shift Schedule'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => shiftSchedule()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.assignment),
                  title: Text('My Attendance'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.pushNamed(
                        context, '/myAttendance'); // Navigate to My Attendance
                  },
                ),
                ListTile(
                  leading: Icon(Icons.assignment),
                  title: Text('Attendance in diagram'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.pushNamed(
                        context, '/piechart'); // Navigate to My Attendance
                  },
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Center(
                  // Center the text
                  child: Text(
                    "Employee ID: $userId",
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  // Center the text
                  child: Text(
                    "Location: $sublocality, $locality, $administrativeArea, $country, $postalCode",
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    width: 120.0,
                    height: 120.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.cyan, width: 2.0),
                    ),
                    child: _image != null
                        ? Image.file(_image!, fit: BoxFit.cover)
                        : Image.asset('assets/images/Image_logoright.png',
                            fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: 20),
                _imageCaptured ? submitButton : captureImageButton,
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/myreport');
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/attendanceicon.png',
                            width: 100.0,
                            height: 100.0,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "My Attendance",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Shift",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isFLA)
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/teamreport');
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/groupattendnace.png',
                              width: 100.0,
                              height: 100.0,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Team Report",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }

  captureImage() async {
    try {
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error capturing image: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  locationDetector(
      double? latitude, double? longitude, BuildContext context) async {
    // double range = 0.0002000; // You can adjust this range as needed

// Calculate the boundaries
//     double minLatitude = 19.1146424 - range;
//     double maxLatitude = 19.1146424 + range;
//     double minLongitude = 72.8338701 - range;
//     double maxLongitude = 72.8338701 + range;
//     if (latitude != null && longitude != null) {
//       if (latitude >= minLatitude &&
//           latitude <= maxLatitude &&
//           longitude >= minLongitude &&
//           longitude <= maxLongitude) {
    // Proceed with face recognition
    //await doFaceDetection(context);
    // } else {
    //   // Device is not within the predefined area, do not trigger face recognition
    //   Fluttertoast.showToast(
    //     msg: "Face recognition only available in certain area",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.black.withOpacity(0.7),
    //     textColor: Colors.white,
    //     fontSize: 16.0,
    //   );
    // }
    // } else {
    //   // Unable to obtain device location, handle accordingly
    //   Fluttertoast.showToast(
    //     msg: "Unable to get device location",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.black.withOpacity(0.7),
    //     textColor: Colors.white,
    //     fontSize: 16.0,
    //   );
    // }
  }

  List<Face> faces = [];

  doFaceDetection(BuildContext context) async {
    try {
      recognitions.clear();

      _image = await removeRotation(_image!);

      image = await _image?.readAsBytes();
      image = await decodeImageFromList(image);

      InputImage inputImage = InputImage.fromFile(_image!);
      faces = await faceDetector.processImage(inputImage);

      for (Face face in faces) {
        Rect faceRect = face.boundingBox;
        num left = faceRect.left < 0 ? 0 : faceRect.left;
        num top = faceRect.top < 0 ? 0 : faceRect.top;
        num right =
            faceRect.right > image.width ? image.width - 1 : faceRect.right;
        num bottom =
            faceRect.bottom > image.height ? image.height - 1 : faceRect.bottom;
        num width = right - left;
        num height = bottom - top;

        final bytes = _image!.readAsBytesSync();
        img.Image? faceImg = img.decodeImage(bytes!);
        img.Image faceImg2 = img.copyCrop(faceImg!,
            x: left.toInt(),
            y: top.toInt(),
            width: width.toInt(),
            height: height.toInt());

        Recognition recognition = recognizer.recognize(faceImg2, faceRect);
        recognitions.add(recognition);

        if (recognition.distance > 0.60 || recognition.distance == -4.0) {
          recognition.name = "unknown";
          await showTryAgainDialog(context);
          setState(() {
            _imageCaptured = false;
          });
        } else {
          Provider.of<LocationProvider>(context, listen: false);
          LocationProvider locationProvider =
              Provider.of<LocationProvider>(context, listen: false);
          await attendacnce().attendanceapi(userId!, context, locationProvider);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error during face detection: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> showTryAgainDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Text(
            'Face Not Recognized',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'The face was not recognized. Please try again.',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Try Again',
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  removeRotation(File inputImage) async {
    final img.Image? capturedImage =
        img.decodeImage(await File(inputImage!.path).readAsBytes());
    final img.Image orientedImage = img.bakeOrientation(capturedImage!);
    return await File(_image!.path).writeAsBytes(img.encodeJpg(orientedImage));
  }
}
