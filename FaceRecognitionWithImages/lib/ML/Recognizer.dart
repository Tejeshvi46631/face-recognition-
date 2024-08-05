import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../DB/DatabaseHelper.dart';
import '../API/registrationAPI.dart';
import '../atendancetable.dart';
import 'Recognition.dart';

class Recognizer {
  late Interpreter interpreter;
  late InterpreterOptions _interpreterOptions;
  static const int WIDTH = 160;
  static const int HEIGHT = 160;
  String empid="";
  final dbHelper = DatabaseHelper();
  Map<String,Recognition> registered = Map();
  @override
  String get modelName => 'assets/facenet.tflite';

  Recognizer({int? numThreads}) {
    _interpreterOptions = InterpreterOptions();

    if (numThreads != null) {
      _interpreterOptions.threads = numThreads;
    }
    loadModel();
   // initDB();
  }

  initDB() async {
   //  await dbHelper.init();
   // // loadRegisteredFaces();
   //  print("initDB");
   //  print(empid);
    //loadRegistered(empid);
  }

   void empIn(String emp){
    //print("inside empIn : "+emp);
    empid = emp;
    print("inside empIn : ");
    print(empid);
    loadRegistered(empid);
  }

//   void loadRegisteredFaces() async {
//
//     List<dynamic> jsonResponse = await ApiClient.getAll();
//     List<Map<String, dynamic>> jsonList = jsonResponse.map((dynamic item) {
//       // Assuming each item in the list is a Map<String, dynamic>
//       return item as Map<String, dynamic>;
//     }).toList();
//
//     for (final resp in jsonList) {
//
//       String name = resp['columnName'];
//       String emd = resp['columnEmbedding'];
//       List<String> doubleStringList = resp['columnEmbedding'].split(',');
//
// // Convert each string representation of a double into an actual double value
//       List<double> doubleList = doubleStringList.map((String value) => double.parse(value.trim())).toList();
//
//     // List<double> embd = resp[DatabaseHelper.columnEmbeddingM].split(',').map((e) => double.parse(e)).toList().cast<double>();
//      Recognition recognition = Recognition(resp['columnName'],Rect.zero,doubleList,0);
//       registered.putIfAbsent(name, () => recognition);
//     }
//   }

  void loadRegistered(String empid) async {

    Map<String, dynamic> jsonResponsebyname = await ApiClient.getAllByEmpId(empid);
    print("getByEmpId : ");
    print(jsonResponsebyname['columnName']);
    String name = jsonResponsebyname['columnName'];
    String emd = jsonResponsebyname['columnEmbedding'];
    List<String> doubleStringList = emd.split(',');

// Convert each string representation of a double into an actual double value
    List<double> doubleList = doubleStringList.map((String value) => double.parse(value.trim())).toList();

    Recognition recognition = Recognition(name,Rect.zero,doubleList,0);
    registered.putIfAbsent(name, () => recognition);
  }

  // void registerFaceInDB(String name, List<double> embedding,String empid) async {
  //
  //   await ApiClient.insertData(name,embedding,empid);
  //
  // }


  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset(modelName);
    } catch (e) {
      print('Unable to create interpreter, Caught Exception: ${e.toString()}');
    }
  }

  List<dynamic> imageToArray(img.Image inputImage){
    img.Image resizedImage = img.copyResize(inputImage!, width: WIDTH, height: HEIGHT);
    List<double> flattenedList = resizedImage.data!.expand((channel) => [channel.r, channel.g, channel.b]).map((value) => value.toDouble()).toList();
    Float32List float32Array = Float32List.fromList(flattenedList);
    int channels = 3;
    int height = HEIGHT;
    int width = WIDTH;
    Float32List reshapedArray = Float32List(1 * height * width * channels);
    for (int c = 0; c < channels; c++) {
      for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
          int index = c * height * width + h * width + w;
          reshapedArray[index] = (float32Array[c * height * width + h * width + w]-127.5)/127.5;
        }
      }
    }
    return reshapedArray.reshape([1,160,160,3]);
  }

  Recognition recognize(img.Image image,Rect location) {

    //TODO crop face from image resize it and convert it to float array
    var input = imageToArray(image);
    print(input.shape.toString());

    //TODO output array
    List output = List.filled(1*512, 0).reshape([1,512]);

    //TODO performs inference
    final runs = DateTime.now().millisecondsSinceEpoch;
    interpreter.run(input, output);
    final run = DateTime.now().millisecondsSinceEpoch - runs;
    print('Time to run inference: $run ms$output');

    //TODO convert dynamic list to double list
     List<double> outputArray = output.first.cast<double>();

     //TODO looks for the nearest embeeding in the database and returns the pair
     Pair pair = findNearest(outputArray);
     print("distance= ${pair.distance}");

     return Recognition(pair.name,location,outputArray,pair.distance);
  }

  //TODO  looks for the nearest embeeding in the database and returns the pair which contain information of registered face with which face is most similar
  findNearest(List<double> emb){
    Pair pair = Pair("Unknown", -5);
    for (MapEntry<String, Recognition> item in registered.entries) {
      final String name = item.key;
      List<double> knownEmb = item.value.embeddings;
      double distance = 0;
      for (int i = 0; i < emb.length; i++) {
        double diff = emb[i] -
            knownEmb[i];
        distance += diff*diff;
      }
      distance = sqrt(distance);
      if (pair.distance == -5 || distance < pair.distance) {
        pair.distance = distance;
        pair.name = name;
      }
    }
    return pair;
  }

  void close() {
    interpreter.close();
  }

}
class Pair{
   String name;
   double distance;
   Pair(this.name,this.distance);
}


