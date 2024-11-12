import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geofence/themes/appcolor.dart';
import 'package:geofence/themes/fontsize.dart';
import 'package:geofence/ML/Recognition.dart';
import 'package:geofence/ML/Recognizer.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../API/registrationAPI.dart';
import '../ShowDailogAlert/registerdialog.dart';
import '../provider/FaceBoundingBoxProvider .dart';
import 'package:image/image.dart' as img;
import 'package:crypto/crypto.dart';
import '../API/loginapi.dart';


class Register extends StatefulWidget {
  @override
  _Register createState() => _Register();
}

class _Register extends State<Register> {
  ApiClient apiClient = ApiClient();
  late ImagePicker picker;
  LoginAPI login = LoginAPI();
  File? _image;
  File? _image1;
  File? _image2;
  Face? registeredFace;
  String? selectedDesignation;
  List<String>? designations;
  String? selectedfla;
  List<String>? flanamelist;
  bool isFlaSelected = false;
  bool isagreeterm = false;
  bool isGuidelinesSelected = false;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _employeeid = TextEditingController();
  final TextEditingController _mobilenumber = TextEditingController();
  final TextEditingController _emailid = TextEditingController();
  late FaceDetector faceDetector;
  late Recognizer recognizer;
  @override
  void initState() {
    super.initState();

    // Call the fetchDesignationList method in initState
    fetchDesignations();
    fetchfla();
    picker = ImagePicker();

    final options = FaceDetectorOptions();
    faceDetector = FaceDetector(options: options);


    //TODO initialize face recognizer
    recognizer = Recognizer();
  }

  //Capture Images
  captureImage() async {
    XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _image!.readAsBytes().then((imageBytes) {
          // Once the image is loaded, call doFaceDetection
          doFaceDetection(_image);
        });
      });
    }
  }

  List<Face> faces = [];
  doFaceDetection(File? _imageArg) async {

    _imageArg = await removeRotation(_imageArg!);
    image = await _imageArg?.readAsBytes();
    image = await decodeImageFromList(image);

    //TODO passing input to face detector and getting detected faces
    InputImage inputImage = InputImage.fromFile(_imageArg!);
    faces = await faceDetector.processImage(inputImage);
    for (Face face in faces) {
      Rect faceRect = face.boundingBox;
      num left = faceRect.left<0?0:faceRect.left;
      num top = faceRect.top<0?0:faceRect.top;
      num right = faceRect.right>image.width?image.width-1:faceRect.right;
      num bottom = faceRect.bottom>image.height?image.height-1:faceRect.bottom;
      num width = right - left;
      num height = bottom - top;

      //TODO crop face
      final bytes = _imageArg!.readAsBytesSync();//await File(cropedFace!.path).readAsBytes();
      img.Image? faceImg = img.decodeImage(bytes!);
      img.Image faceImg2 = img.copyCrop(faceImg!,x:left.toInt(),y:top.toInt(),width:width.toInt(),height:height.toInt());
      await Future.delayed(Duration(seconds: 30));

      Recognition recognition = recognizer.recognize(faceImg2, faceRect);
      // recognizer.registerFaceInDB(_name.text, recognition.embeddings,_employeeid.text);
      await ApiClient.insertDataMap(_name.text,recognition.embeddings,_employeeid.text);
      _name.text = "";
    }
  }
  Future<File> removeRotation(File inputImage) async {
    final img.Image? capturedImage = img.decodeImage(await File(inputImage!.path).readAsBytes());
    final img.Image orientedImage = img.bakeOrientation(capturedImage!);
    return await File(_image!.path).writeAsBytes(img.encodeJpg(orientedImage));
  }

  var image;
  drawRectangleAroundFaces() async {
    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);
    print("${image.width}   ${image.height}");
    setState(() {
      image;
      faces;
    });
  }

  //Method to fetch FLA List
  void fetchfla() async {
    try {
      List<String> fetchfla = await ApiClient.fetchFLAList();
      setState(() {
        flanamelist = fetchfla;
        print(flanamelist);
      });
    } on Exception catch (e) {
      print('Error fetching FlaList: $e');
    }
  }

  // Method to fetch designations
  void fetchDesignations() async {
    try {
      List<String> fetchedDesignations = await ApiClient.fetchDesignationList();
      setState(() {
        designations = fetchedDesignations;
        print(designations);
      });
    } catch (error) {
      // Handle errors if any during the API call
      print('Error fetching designations: $error');
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/register.png'),
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
                      'Register',
                      style: TextStyle(color: Colors.white, fontSize: 33),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 30),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 35),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3.0),
                          child: Container(
                            width: 150,
                            height: 150,
                            child: _image != null
                                ? Image.file(_image!)
                                : Image.asset(
                                'assets/images/Image_logo.png'),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            captureImage();
                          },
                          child: Text(
                            'Capture Photo',
                            style: TextStyle(fontSize: 16,color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black45,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Name',
                            hintText: 'Enter your name',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintStyle: TextStyle(color: Colors.black),
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          controller: _name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Employee ID',
                            hintText: 'Enter your employee ID',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintStyle: TextStyle(color: Colors.black),
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          controller: _employeeid,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your employee ID';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Mobile Number',
                            hintText: 'Enter your mobile number',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintStyle: TextStyle(color: Colors.black),
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          controller: _mobilenumber,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your mobile number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintStyle: TextStyle(color: Colors.black),
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          controller: _emailid,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            }
                            // You can add more complex email validation logic here if needed
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Select Designation',
                            hintText: 'Select your designation',
                            labelStyle: TextStyle(color: Colors.black),
                            hintStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          value: selectedDesignation,
                          onChanged: (value) {
                            setState(() {
                              selectedDesignation = value!;
                            });
                          },
                          items:designations
                              ?.map((designation)  {
                            return DropdownMenuItem<String>(
                              value: designation,
                              child: Text(designation),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your designation';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Checkbox(
                              value: isFlaSelected,
                              onChanged: (value) {
                                setState(() {
                                  isFlaSelected = value ?? false;
                                });
                              },
                              checkColor: Colors.black,
                              fillColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.white,
                              ),
                            ),
                            Text(
                              'Are you FLA?',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Select FLA',
                            hintText: 'Select your FLA',
                            labelStyle: TextStyle(color: Colors.black),
                            hintStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          value: selectedfla,
                          onChanged: (value) {
                            setState(() {
                              selectedfla = value!;
                            });
                          },
                          items: flanamelist
                              ?.map((flaname) {
                            return DropdownMenuItem<String>(
                              value: flaname,
                              child: Text(flaname),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your FLA';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 27,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Color(0xff4c505b),
                              child: IconButton(
                                color: Colors.green,
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    // If the form is valid, proceed with registration
                                    try {
                                      await ApiClient.registration(
                                        context: context,
                                        name: _name.text,
                                        password: 'abc', // Set the password as needed
                                        email: _emailid.text,
                                        mobile: _mobilenumber.text,
                                        employeeId: _employeeid.text,
                                        isFLA: isFlaSelected,
                                        isGuidelinesAccepted: isGuidelinesSelected,
                                        selecteddesignation: selectedDesignation!,
                                        selectedflaname: selectedfla!,
                                      );
                                      Fluttertoast.showToast(
                                        msg: "Register Successful",
                                        toastLength: Toast.LENGTH_SHORT,
                                        // Duration for which the toast should be displayed
                                        gravity: ToastGravity.BOTTOM,
                                        // Position of the toast on the screen
                                        timeInSecForIosWeb: 120,
                                        // Time for which the iOS toast should be displayed (in seconds)
                                        backgroundColor: Colors.black.withOpacity(0.7),
                                        // Background color of the toast
                                        textColor: Colors.white,
                                        // Text color of the toast
                                        fontSize: 16.0, // Font size of the toast message
                                      );

                                      // Registration successful, you can navigate to the next screen or show a success message
                                      // For now, print a success message
                                      print('Registration successful!');
                                    } catch (error) {
                                      // Handle any errors that occurred during the registration API call
                                      print('Error during registration: $error');
                                      // You might want to show an error message to the user
                                    }
                                  }
                                },
                                icon: Icon(Icons.arrow_forward),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: Text(
                                'Already have an account?Sign In',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

