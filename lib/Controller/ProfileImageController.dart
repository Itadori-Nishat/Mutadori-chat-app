import 'package:flutter/material.dart';

class ImageUrlProvider with ChangeNotifier {
  List<String> _imageUrls = [];

  List<String> get imageUrls => _imageUrls;

  void addImageUrl(String url) {
    _imageUrls.add(url);
    notifyListeners();
  }
}
