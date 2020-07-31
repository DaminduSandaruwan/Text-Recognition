import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File pickedImage;
  bool isImageLoaded = false;
  String sentence = "";

  Future pickImage() async{
    var tempStore = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      pickedImage =tempStore;
      isImageLoaded = true;
    });

  }

  Future readText() async{
    sentence ="";
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    for(TextBlock block in readText.blocks){
      for(TextLine line in block.lines){
        for(TextElement word in line.elements){
          setState(() {
            sentence= sentence + " " + word.text;
          });          
          print(word.text);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                isImageLoaded ? Center(
                  child: Container(
                    // color: Colors.black,
                    height: MediaQuery.of(context).size.height/2,
                    width: MediaQuery.of(context).size.width-10,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(pickedImage),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ):
                Container(),
                SizedBox(height: 15,),
                RaisedButton(
                  child: Text(
                    'Pick an Image',
                  ),
                  onPressed: (){
                    pickImage();
                  },
                ),
                RaisedButton(
                  child: Text(
                    'Recognize Text',
                  ),
                  onPressed: (){
                    readText();
                  },
                ),
                SizedBox(height: 15,),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    sentence,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}