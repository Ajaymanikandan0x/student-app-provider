import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student_app_provider/base/const.dart';
import 'package:student_app_provider/base/widgets/widgets.dart';

import '../base/widgets/button.dart';
import '../data_base/model/model.dart';

class StudentProfile extends StatelessWidget {
  final Model student;
  const StudentProfile({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'STUDENT PROFILE',
          style: title,
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 128, 128),
              Color.fromARGB(255, 212, 212, 212)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: student.profileImg!.isNotEmpty
                        ? FileImage(File(student.profileImg!))
                        : null,
                    backgroundColor:
                        student.profileImg!.isEmpty ? Colors.cyan : null,
                    child: student.profileImg!.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  gapHeight,
                  Text(
                    "Name: ${student.name}",
                    style: styleDetails(),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "School: ${student.batch}",
                    style: styleDetails(),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Age: ${student.age}",
                    style: styleDetails(),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "StudentId: ${student.studentId}",
                    style: styleDetails(),
                  ),
                  gapHeight,
                  ButtonWidget(student: student),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
