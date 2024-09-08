import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditStudentProvider extends ChangeNotifier {
  XFile? image;
  String? profileImg;
  void setImage(XFile? img) {
    image = img;
    profileImg = img?.path;
    notifyListeners();
  }

  void clearImage() {
    image = null;
    profileImg = null;
    notifyListeners();
  }
}
