import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note/models/note.dart';
import 'package:note/models/note_database.dart';
import 'package:note/theme/theme_provider.dart';
import 'package:note/ui/notes_tiles.dart';
import 'package:provider/provider.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  // ACCESS USER TYPED TEXT
  final textControler = TextEditingController();

  @override
  void initState() {
    super.initState();
    readNotes();
  }

  // CREATE A NEW NOTE
  void createNote() {
    showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Note'),
        content: TextField(controller: textControler, autofocus: true),
        actions: [
          MaterialButton(
            onPressed: () {
              if (textControler.text == '') {
              } else {
                context.read<NoteDatabase>().addNote(textControler.text);
                textControler.clear();
                Navigator.pop(context);
              }
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }

  // READ NOTES FROM DB
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  // UPDATE A NOTE FROM DB
  void updateNote(Note note) {
    textControler.text = note.text;
    showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Note'),
        content: TextField(controller: textControler),
        actions: [
          // UPDATE BUTTON
          MaterialButton(
            onPressed: () {
              if (textControler.text == '') {
              } else {
                context.read<NoteDatabase>().updateNote(
                  note.id,
                  textControler.text,
                );
                textControler.clear();
                Navigator.pop(context);
              }
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  // DELETE A NOTE FROM DB
  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {
    // NOTE DB
    final notedatabase = context.watch<NoteDatabase>();
    // CURRENT NOTES
    List<Note> currentNotes = notedatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            icon:
                (Provider.of<ThemeProvider>(context, listen: false).isDarkMode)
                ? Icon(Icons.light_mode, size: 50)
                : Icon(Icons.dark_mode, size: 50),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // APP NAME UI
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'Notes [ ${currentNotes.length} ]',
              style: GoogleFonts.dmSerifText(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),

          // LIST OF NOTES UI
          Expanded(
            child: ListView.builder(
              itemCount: currentNotes.length,
              itemBuilder: (context, index) {
                // GET LIST OF NOTES
                final note = currentNotes[index];
                // NOTES LIST UI
                return NotesTile(
                  text: note.text,
                  onDelete: () => deleteNote(note.id),
                  onEdit: () => updateNote(note),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
