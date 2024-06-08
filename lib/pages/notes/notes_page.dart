
import 'package:flutter/material.dart';
import 'package:notesappflutter/models/note_model.dart';
import 'package:notesappflutter/models/response_model.dart';
import 'package:notesappflutter/pages/auth/login_page.dart';
import 'package:notesappflutter/pages/notes/add_note_page.dart';
import 'package:notesappflutter/pages/notes/detail_note_page.dart';
import 'package:notesappflutter/services/note_services.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final NoteServices _noteServices = NoteServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Notes",
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    " app",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              " Safeguard Your Ideas with NotesApp",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            style: const ButtonStyle(
              iconSize: MaterialStatePropertyAll(28.0),
              padding: MaterialStatePropertyAll(
                EdgeInsets.only(
                  top: 8,
                  right: 16,
                  bottom: 8,
                  left: 8,
                ),
              ) 
            ),
            onPressed: onExitButtonTapped,
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _noteServices.getNotes(), 
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if(snapshot.hasError) {
            return const Center(child: Text('Error: check your internet connection!!'));
          } else if(snapshot.hasData) {
            return noteListBuilder(responseModel: snapshot.data!);
          } else {
            return const Center(child: Text("No Data"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const AddNotePage())
          );
          setState(() {});
        },
        child: const Icon(Icons.note_add),
      ),
    );
  }

  Widget noteListBuilder({ required ResponseModel responseModel}) {
    final List notes = responseModel.data["notes"];

    final listOfNoteModel = List.generate(
      notes.length, 
      (index) => NoteModel.fromJson(notes[index])
    );

    return RefreshIndicator(
      onRefresh: () async { 
        setState(() {});
      },
      child: ListView.builder(
        itemCount: listOfNoteModel.length,
        itemBuilder: (context, index) {
          final noteModel = listOfNoteModel[index];
          return NoteCard(
            note: noteModel, 
            noteServices: _noteServices, 
            onNoteEdit: () { 
              setState(() {});
            },
          );
        },
      ),
    );
  }

  void onExitButtonTapped() async {
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Exit"),
          content: const Text("Are you sure you want to exit from this appllication?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              child: const Text("Confirm"),
              onPressed: () => Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (context) => const LoginPage())
              ),
            ),
          ],
        );
      },
    );
  }
}


class NoteCard extends StatelessWidget {
  final NoteModel note;
  final NoteServices noteServices;
  final VoidCallback onNoteEdit;

  const NoteCard({
    super.key,
    required this.note,
    required this.noteServices,
    required this.onNoteEdit
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(note.id), // Key Harus unik
      confirmDismiss: (direction) => _confirmDismiss(context),
      onDismissed: (direction) async {
        await noteServices.deleteNotes(noteId: note.id);
        onNoteEdit();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              spreadRadius: 1,
              color: Colors.black12,
            ),
          ],
        ),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => DetailNotePage(note: note)
              ),
            );
          },
          title: Text(
            note.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: Text(
                  note.tags.map((tag) => "#$tag").join(' '),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          trailing: IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNotePage(noteModel: note),
                )
              );
              onNoteEdit();
            },
            icon: const Icon(Icons.edit_document)
          ),
        ),
      ),
    );
  }

  Future<bool?> _confirmDismiss(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text("Are you sure you want to delete this note?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
