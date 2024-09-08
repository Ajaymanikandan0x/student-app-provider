import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:student_app_provider/screens/student_profile.dart';

import '../base/const.dart';
import '../controllers/student_list_provider.dart';
import 'add_student.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<StudentListProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: title,
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.grid_on,
                color: Colors.white,
              ))
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: CupertinoSearchTextField(
              onChanged: (query) {
                homeProvider.filterStudents(query);
              },
              backgroundColor: Colors.cyan.shade100,
            ),
          ),
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: homeProvider.filteredStudent.isEmpty
            ? const Center(
                child: Text(
                  'No students found',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: homeProvider.filteredStudent.length,
                itemBuilder: (BuildContext context, int index) {
                  final students = homeProvider.filteredStudent[index];
                  return Padding(
                    padding: EdgeInsets.all(15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentProfile(
                              student: students,
                            ),
                          ),
                        ).then((value) => homeProvider.refreshStudentList());
                      },
                      child: Container(
                        height: 90,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(237, 255, 255, 255),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(4, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: ListTile(
                            leading: CircleAvatar(
                              radius:
                                  30.0, // Adjust the radius to fit the container
                              backgroundImage:
                                  FileImage(File(students.profileImg ?? '')),
                              onBackgroundImageError: (_, __) {
                                // Handle image loading error
                                print('Error loading image');
                              },
                            ),
                            title: Text(
                              students.name ?? '',
                              style: GoogleFonts.crimsonPro(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.blueGrey,
                              ),
                            ),
                            subtitle: Text(
                              students.batch ?? '',
                              style: GoogleFonts.crimsonPro(
                                fontSize: 16,
                                color: Colors.blueGrey,
                              ),
                            ),
                            trailing: Text(
                              "Age: ${students.age.toString()}",
                              style: GoogleFonts.crimsonPro(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.blueGrey,
                              ),
                            ),
                            minVerticalPadding: 10,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddStudent()),
          ).then((value) => homeProvider.refreshStudentList());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
