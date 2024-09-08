import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddStudentProvider extends ChangeNotifier {
  XFile? image;
  String? profileImg;

  void setImageUser(XFile? img) {
    image = img;
    profileImg = img?.path;
    notifyListeners();
  }

  void clearImageUser() {
    image = null;
    profileImg = null;
    notifyListeners();
  }
}
