import 'package:flutter/material.dart';
import 'package:notesappflutter/models/note_model.dart';
import 'package:notesappflutter/utils/extensions/date_formatting.dart';

class DetailNotePage extends StatelessWidget {
  final NoteModel note;
  const DetailNotePage({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Detail Note"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                visualDensity: VisualDensity.compact,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  note.title,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...note.tags.map(
                        (tag) => Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Text("#$tag"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.access_time, size: 16),
                  const SizedBox(width: 5),
                  Text(note.updatedAt.formattedDatetime),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    note.body,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}