import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../const.dart';

class DeleteDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onDelete;

  const DeleteDialog({
    super.key,
    required this.onCancel,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Student', style: textButton),
      content: Text('Are you sure you want to delete this student?',
          style: textButton),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text('Cancel', style: textButton),
        ),
        TextButton(
          onPressed: onDelete,
          child: Text(
            'Delete',
            style: GoogleFonts.firaCode(
                textStyle: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        )
      ],
      backgroundColor: const Color.fromARGB(255, 51, 50, 50),
    );
  }
}
