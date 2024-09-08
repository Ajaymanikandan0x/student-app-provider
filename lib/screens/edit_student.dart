import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:student_app_provider/base/const.dart';
import 'package:student_app_provider/base/widgets/widgets.dart';
import 'package:student_app_provider/data_base/model/model.dart';

import '../controllers/edit_student_provider.dart';
import '../data_base/db.dart';

class EditStudent extends StatelessWidget {
  EditStudent({super.key, required this.student});
  final Model student;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final batchController = TextEditingController();
  final studentIdController = TextEditingController();
  final DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    final editStudent = Provider.of<EditStudentProvider>(context, listen: false);

    nameController.text = student.name ?? '';
    ageController.text = student.age.toString();
    batchController.text = student.batch ?? '';
    studentIdController.text = student.studentId.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student',
          style: title,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min, // Add this line
                children: [
                  GestureDetector(
                    onTap: () async {
                      await getImage(context);
                    },
                    child: CircleAvatar(
                        maxRadius: 80,
                        foregroundColor: Colors.blueGrey,
                        backgroundImage: editStudent.profileImg != null
                            ? FileImage(File(editStudent.profileImg!))
                            : FileImage(File(student.profileImg!))),
                  ),
                  gapHeight,
                  formField(
                    hint: 'name',
                    icon: const Icon(Icons.person),
                    keyboardTypeUser: TextInputType.name,
                    controller: nameController,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                        return "Please enter a correct name";
                      } else {
                        return null;
                      }
                    },
                  ),
                  gapHeight,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 120,
                        child: formField(
                          hint: 'age',
                          icon: const Icon(Icons.numbers),
                          keyboardTypeUser: TextInputType.number,
                          controller: ageController,
                          validator: (value) {
                            if (value == null) {
                              return "Please enter your age.";
                            }

                            if (!RegExp(r'^\d{1,2}$').hasMatch(value)) {
                              return "Please enter a valid age (up to 2 digits).";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      gapWidth,
                      Expanded(
                        child: formField(
                          hint: 'batch',
                          icon: const Icon(Icons.batch_prediction),
                          keyboardTypeUser:
                              const TextInputType.numberWithOptions(),
                          controller: batchController,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !RegExp(r'^[a-zA-Z 0-9]+$').hasMatch(value)) {
                              return "Please enter valid batch number";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  gapHeight,
                  formField( // Remove Expanded widget
                    hint: 'id',
                    icon: const Icon(Icons.numbers),
                    keyboardTypeUser: TextInputType.number,
                    controller: studentIdController,
                    validator: (value) {
                      if (value == null) {
                        return "Please enter an ID";
                      }
                      if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                        return "Please enter a valid 6-digit ID";
                      }
                      return null; // Valid ID
                    },
                  ),
                  gapHeight,
                  Row(
                    children: [
                      elevatedButton(
                          icon: Icons.delete,
                          text: 'Delete',
                          onPressed: () {
                            saveStudent(context);
                          }),
                      elevatedButton(
                          icon: Icons.exit_to_app_outlined,
                          text: 'back',
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }

  Future<void> getImage(BuildContext context) async {
    XFile? img = await ImagePicker().pickImage(source: ImageSource.gallery);
    context.read<EditStudentProvider>().setImage(img);
  }

  void saveStudent(BuildContext context) {
    // Access the provider instance here
    if (_formKey.currentState!.validate()) {
      final name = nameController.text;
      final age = int.parse(ageController.text);
      final batch = batchController.text;
      final studentId = int.parse(studentIdController.text);
      final editStudent = Provider.of<EditStudentProvider>(context, listen: false);

      final updateStudent = Model(
        id: student.id,
        name: name,
        batch: batch,
        age: age,
        studentId: studentId,
        profileImg: editStudent.profileImg ?? student.profileImg,
      );

      // Insert the student into the database
      databaseHelper.updateStudent(updateStudent).then((id) {
        final snackBar = SnackBar(
          content: Text(
            id > 0 ? 'Student update successfully' : 'Failed to update student',
            style: TextStyle(
              color: id > 0 ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: id > 0 ? Colors.green[50] : Colors.red[50],
          action: SnackBarAction(
            label: 'DISMISS',
            textColor: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating, // For better placement
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        if (id > 0) {
          Navigator.pop(context); // Go back to the previous screen on success
        }
      });

      // Clear the image in the provider
      editStudent.clearImage();
    }
  }
}
