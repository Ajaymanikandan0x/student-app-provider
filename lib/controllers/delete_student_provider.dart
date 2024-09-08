import 'package:flutter/material.dart';

import '../data_base/db.dart';

class DeleteStudentProvider extends ChangeNotifier {
  final DatabaseHelper db = DatabaseHelper();
  Future<void> deleteStudent(int studentId) async {
    db.deleteStudent(studentId);
  }
}
