import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;



class FoodDetectionModel extends StatefulWidget {
  const FoodDetectionModel({Key? key}) : super(key: key);

  @override
  _FoodDetectionModelState createState() => _FoodDetectionModelState();
}

class _FoodDetectionModelState extends State<FoodDetectionModel> {
  File? _image;
  String? _responseText;
  List<Map<String, dynamic>> foodItems = [];

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imagepermanent = await saveFilePermanently(image.path);
      setState(() {
        this._image = imagepermanent;
        this._responseText = null;
        this.foodItems = [];
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<File> saveFilePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');
    return File(imagePath).copy(image.path);
  }

  Future uploadImage() async {
    if (_image == null) return;
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2:5000/'),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          _image!.path,
        ),
      );
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Image uploaded successfully!');
        var responseBody = await response.stream.bytesToString();

        setState(() {
          this._responseText = responseBody;
        });

        // Parse the response body as JSON and extract the food item information
        var decodedResponse = jsonDecode(responseBody);
        if (decodedResponse is List && decodedResponse.isNotEmpty) {
          setState(() {
            this.foodItems = List.castFrom<dynamic, Map<String, dynamic>>(jsonDecode(responseBody));;
          });
        }
      } else {
        print('Failed to upload image.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Food Detector'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              _image != null
                  ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 2,color: Colors.grey)
                    ),
                    child: Image.file(
                                  _image!,
                                  width: 350,
                                  height: 500,
                                  fit: BoxFit.cover,
                                ),
                  )
                  : Container(decoration: BoxDecoration(
                      border: Border.all(width: 2,color: Colors.grey)
                    ),child: Image.network('https://roboticsandautomationnews.com/wp-content/uploads/2021/11/methode_times_prod_web_bin_5b19471e-8ae1-11ea-9ea5-63981dbe6eb1.jpeg')),
              SizedBox(
                height: 40,
              ),
              CustomButton(
                title: 'Pick from Gallery',
                icon: Icons.image_outlined,
                onClick: () => getImage(ImageSource.gallery),
              ),
              CustomButton(
                title: 'Pick from Camera',
                icon: Icons.camera,
                onClick: () => getImage(ImageSource.camera),
              ),
              CustomButton(
                title: 'Detect',
                icon: Icons.food_bank,
                onClick: () => uploadImage(),
              ),
              SizedBox(
                height: 20,
              ),
              _responseText != null
                  ? Column(
                children: foodItems.map((foodItem) {
                  return Container(
                    width: 280,
                    child: Column(
                      children: [
                        // Text(
                        //   'uri: ${foodItem['uri']}',
                        //   textAlign: TextAlign.center,
                        //   style: TextStyle(fontSize: 16),
                        // ),
                        SizedBox(height: 10),
                        Text(
                          'Name: ${foodItem['name']}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Protein: ${foodItem['protein']}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Fat: ${foodItem['fat']}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Carbohydrates: ${foodItem['carbohydrates']}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Vitamins: ${foodItem['vitamins']}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        // SizedBox(height: 20),
                        Divider(
    color: Colors.green, //color of divider
    height: 5, //height spacing of divider
    thickness: 3, //thickness of divier line
    indent: 25, //spacing at the start of divider
    endIndent: 25, //spacing at the end of divider
)
                      ],
                    ),
                  );
                }).toList(),
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget CustomButton({
  required String title,
  required IconData icon,
  required VoidCallback onClick,
}) {
  return Container(
    width: 280,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green, // Background color
  ),
      onPressed: onClick,
      child: Row(
        children: [
          Icon(icon),
          SizedBox(
            width: 20,
          ),
          Text(title),
        ],
      ),
    ),
  );
}