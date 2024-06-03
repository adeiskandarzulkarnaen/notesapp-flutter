

import 'package:flutter/material.dart';
import 'package:notesapp_flutter/models/note_model.dart';

class DetailNotePage extends StatelessWidget {
  final NoteModel note;
  const DetailNotePage({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Note"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(note.title),
          Text(note.tags.toString()),
          Text(note.updatedAt),
          Text(note.body)
        ],
      ),
    );
  }
}