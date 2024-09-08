import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:student_app_provider/base/const.dart';
import 'package:student_app_provider/base/widgets/widgets.dart';
import 'package:student_app_provider/controllers/add_studeent_provider.dart';
import 'package:student_app_provider/data_base/model/model.dart';

import '../data_base/db.dart';

class AddStudent extends StatelessWidget {
  AddStudent({super.key});
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final batchController = TextEditingController();
  final studentIdController = TextEditingController();
  final DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
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
            child: Consumer<AddStudentProvider>(
              builder: (BuildContext context, studentValue, _) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await getImage(context);
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: CircleAvatar(
                          maxRadius: 80,
                          foregroundColor: Colors.blueGrey,
                          backgroundImage: studentValue.profileImg != null
                              ? FileImage(File(studentValue.profileImg!))
                              : null,
                          child: studentValue.profileImg == null
                              ? const Icon(Icons.add_a_photo,
                                  size: 50, color: Colors.white)
                              : null,
                        ),
                      ),
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
                        Expanded(
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
                            keyboardTypeUser: TextInputType.text,
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
                    formField(
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
                            icon: Icons.save,
                            text: 'Save',
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getImage(BuildContext context) async {
    XFile? img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) {
      context.read<AddStudentProvider>().setImageUser(img);
    }
  }

  void saveStudent(BuildContext context) {
    // Access the provider instance here
    final studentValue = context.read<AddStudentProvider>();

    if (_formKey.currentState!.validate()) {
      final student = Model(
        id: 0, // Auto increment ID
        name: nameController.text,
        age: int.parse(ageController.text),
        batch: batchController.text,
        studentId: int.parse(studentIdController.text),
        profileImg: studentValue.profileImg ?? '',
      );

      // Insert the student into the database
      databaseHelper.insertStudent(student).then((id) {
        final snackBar = SnackBar(
          content: Text(
            id > 0 ? 'Student added successfully' : 'Failed to add student',
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
      studentValue.clearImageUser();
    }
  }
}
