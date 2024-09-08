import 'package:flutter/material.dart';

import '../data_base/db.dart';
import '../data_base/model/model.dart';

class StudentListProvider extends ChangeNotifier {
  late DatabaseHelper databaseHelper;
  List<Model> student = [];
  List<Model> filteredStudent = [];
  bool isSearching = false;
  
  StudentListProvider() {
    databaseHelper = DatabaseHelper();
    refreshStudentList();
  }
  Future<void> refreshStudentList() async {
    final studentList = await databaseHelper.getStudents();
    student = studentList;
    filteredStudent = List.from(student); // Initialize filteredStudent
    notifyListeners();
  }

  void toggleSearch() {
    isSearching = !isSearching;
    if (!isSearching) {
      filteredStudent = List.from(student);
    }
    notifyListeners();
  }

  void filterStudents(String query) {
    final trimQuery = query.trim().toLowerCase();

    if (trimQuery.isEmpty) {
      filteredStudent = List.from(student);
      notifyListeners();
      return;
    }
    filteredStudent = student
        .where((student) => student.name!.toLowerCase().contains(trimQuery))
        .toList();
    notifyListeners();
  }
}
