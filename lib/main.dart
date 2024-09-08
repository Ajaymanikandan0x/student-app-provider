import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:student_app_provider/screens/home.dart';

import 'controllers/add_studeent_provider.dart';
import 'controllers/delete_student_provider.dart';
import 'controllers/edit_student_provider.dart';
import 'controllers/student_list_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AddStudentProvider()),
          ChangeNotifierProvider(create: (_) => StudentListProvider()),
          ChangeNotifierProvider(create: (_) => EditStudentProvider()),
          ChangeNotifierProvider(create: (_) => DeleteStudentProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: const AppBarTheme(color: Colors.teal),
            textTheme: GoogleFonts.openSansTextTheme(),
          ),
          routes: {
            '/': (context) => const Home(),
          },
        ));
  }
}
