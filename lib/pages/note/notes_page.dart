
import 'package:flutter/material.dart';
import 'package:notesapp_flutter/models/note_model.dart';
import 'package:notesapp_flutter/models/response_model.dart';
import 'package:notesapp_flutter/pages/note/addnote_page.dart';
import 'package:notesapp_flutter/pages/note/detailnote_page.dart';
import 'package:notesapp_flutter/services/http/note_service.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final NoteService _noteService = NoteService();

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
            onPressed: () {
              // todo: do something
            },
            icon: const Icon(Icons.info_outline_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) {
              return const AddNotePage();
            },)
          );
        },
        child: const Icon(Icons.note_add),
      ),
      body: FutureBuilder(
        future: _noteService.getNotes(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if(snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if(snapshot.hasData) {
            final ResponseModel responseModel = snapshot.data!;

            final List<NoteModel> notes = List.generate(
              responseModel.data["notes"].length, 
              (index) => NoteModel.fromJson(responseModel.data["notes"][index])
            );
            
            return RefreshIndicator(
              onRefresh: () async => setState((){}),
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  NoteModel note = notes[index];
                  return NoteCard(note: note);
                },
              ),
            );
          } else {
            return const Center(child: Text('no connectiom'));
          }
        },
      ),
    );
  }
}


class NoteCard extends StatelessWidget {
  final NoteModel note;
  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
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
            MaterialPageRoute(builder: (context) {
              return DetailNotePage(note: note);
            },)
          );
        },
        // leading: const Icon(Icons.note),
        title: Text(
          note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          note.createdAt,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                // todo: n
              },
              icon: const Icon(Icons.edit_note)
            ),
            IconButton(
              onPressed: () {
                // todo: n
              },
              icon: const Icon(Icons.delete_forever)
            ),
          ],
        ),
      ),
    );
  }
}