
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
class PhotoSelectScreen extends StatefulWidget {


  PhotoSelectScreen();

  @override
  _PhotoSelectScreenState createState() => _PhotoSelectScreenState();
}

class _PhotoSelectScreenState extends State<PhotoSelectScreen> {
  File? selectedPhoto1;
  File? selectedPhoto2;


  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageProvider>(context, listen: false);
    final picker = ImagePicker();
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Select Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final pickedImage = await picker.pickImage(
                        maxHeight: 200.0,
                        maxWidth: 200.0, source:ImageSource.gallery,
                      );

                      if (pickedImage != null) {
                        final imagePath = pickedImage.path;
                        setState(() {
                          selectedPhoto1 = File(imagePath);
                        });
                      }
                    },
                    child: Text('Select Photo 1'),
                  ),
                  if (selectedPhoto1 != null)
                    Image.file(selectedPhoto1!),
                ],
              ),
            ),
          ),
          Divider(
            thickness: 2.0,
            height: 0.0,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final pickedImage = await picker.pickImage(
                        maxHeight: 200.0,
                        maxWidth: 200.0, source: ImageSource.gallery,
                      );

                      if (pickedImage != null) {
                        final imagePath = pickedImage.path;
                        setState(() {
                          selectedPhoto2 = File(imagePath);
                        });
                      }
                    },
                    child: Text('Select Photo 2'),
                  ),
                  if (selectedPhoto2 != null)
                    Image.file(selectedPhoto2!),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
