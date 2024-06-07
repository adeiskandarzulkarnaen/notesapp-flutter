
import 'package:flutter/material.dart';
import 'package:notesappflutter/models/note_model.dart';
import 'package:notesappflutter/models/response_model.dart';
import 'package:notesappflutter/services/note_services.dart';

class AddNotePage extends StatefulWidget {
  final NoteModel? noteModel;
  const AddNotePage({super.key, this.noteModel});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final NoteServices notesServices = NoteServices();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _tagsController;
  late final TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _tagsController = TextEditingController();
    _bodyController = TextEditingController();

    if(widget.noteModel != null) {
      _titleController.text = widget.noteModel!.title;
      _tagsController.text = widget.noteModel!.tags.join(', ');
      _bodyController.text = widget.noteModel!.body;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _tagsController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.noteModel == null
            ? const Text("Add New Note")
            : const Text("Edit Note"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    hintText: "Title",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  validator: (value) {
                    if (value == "") {
                      return "title can't null";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _tagsController,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    hintText: "tags",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  validator: (value) {
                    if (value == "") {
                      return "tags can't null";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _bodyController,
                  maxLines: null,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  decoration: const InputDecoration(
                    hintText: "description",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  validator: (value) {
                    if (value == "") {
                      return "desc can't null";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onSaveButtonTapped,
        child: const Icon(Icons.save),
      ),
    );
  }

  void _onSaveButtonTapped() async {
    final ResponseModel response ;
    
    if(widget.noteModel == null) {
      response = await notesServices.saveNote(
        title: _titleController.text, 
        tags: _tagsController.text, 
        body: _bodyController.text
      );
    } else {
      response = await notesServices.updateNote(
        noteId: widget.noteModel!.id,
        title: _titleController.text, 
        tags: _tagsController.text, 
        body: _bodyController.text, 
      );
    }

    if(!mounted) return;
    await showDialog(
      context: context, 
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();  /* menghapus Alert Dialog */
          }
        });
        return AlertDialog(
          title: Text(response.status),
          content: Text(response.message),
        );
      },
    );

    if (response.status == "success") {
      if(!mounted) return;
      Navigator.pop(context); /* pindah ke halaman sebelummnya */
    }
  }
}