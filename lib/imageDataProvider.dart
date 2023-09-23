
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class ImageData {
  final String imagePath;
  final String category;
  ImageData(this.imagePath,this.category);

  Map<String, dynamic> toJson() {
    return {
      'imagePath': imagePath,
      'category': category,
    };
  }

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(json['imagePath'], json['category']);
  }
}
class ImageProvider extends ChangeNotifier {
  List<ImageData> _images = [];
  List<ImageData> get images => _images;

  void addImage(ImageData imageData) {
    _images.add(imageData);
    notifyListeners();
    saveImages();
  }
  void addImageWithCategory(String imagePath, String category) {
    final imageData = ImageData(imagePath, category);
    _images.add(imageData);
    notifyListeners();
    saveImages();
  }

  void removeImage(int index) {
    _images.removeAt(index);
    notifyListeners();
    saveImages();
  }

  Future<void> saveImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> imageList =
    _images.map((imageData) => jsonEncode(imageData.toJson())).toList();
    prefs.setStringList('imageList', imageList);
  }

  Future<void> loadImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final imageList = prefs.getStringList('imageList');
    if (imageList != null) {
      _images = imageList.map((imageJson) {
        final Map<String, dynamic> imageDataMap = jsonDecode(imageJson);
        return ImageData.fromJson(imageDataMap);
      }).toList();
      notifyListeners();
    }
  }
}