import 'package:flutter/material.dart';
import 'package:notesapp_flutter/models/note_model.dart';
import 'package:notesapp_flutter/utils/extensions/date_formatting.dart';

class DetailNotePage extends StatefulWidget {
  final NoteModel note;
  const DetailNotePage({super.key, required this.note});

  @override
  State<DetailNotePage> createState() => _DetailNotePageState();
}

class _DetailNotePageState extends State<DetailNotePage> {
  late TextEditingController _titleCtrl;
  late TextEditingController _descriptionCtrl;

  @override
  void initState() {
    _titleCtrl = TextEditingController(text: widget.note.title);
    _descriptionCtrl = TextEditingController(text: widget.note.body);
    super.initState();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Detail"),
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
                title: TextField(
                  controller: _titleCtrl,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  decoration: const InputDecoration(
                    hintText: "Title",
                    border: InputBorder.none,
                  ),
                ),
                subtitle: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...widget.note.tags.map(
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
                  Text(widget.note.updatedAt.formattedDatetime),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: TextFormField(
                    controller: _descriptionCtrl,
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: const InputDecoration(
                      hintText: "Description",
                      border: InputBorder.none,
                    ),
                    maxLines: null,
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
