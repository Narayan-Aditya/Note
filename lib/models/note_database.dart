import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:note/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;

  //INIT DB
  static Future<void> initialize() async {
    final dir = await getApplicationCacheDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

  // LIST of notes
  final List<Note> currentNotes = [];

  //--------------------------------------------------------------------------

  // CREATE NEW NOTE
  Future<void> addNote(String textFromUser) async {
    // New Text
    final newNote = Note()..text = textFromUser;
    // SAVE to DB
    await isar.writeTxn(() => isar.notes.put(newNote));
    // SHOW ALL NOTES
    fetchNotes();
  }

  //----------------------------------------------------------------------------

  // READ NOTES FROM DB
  Future<void> fetchNotes() async {
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
    notifyListeners();
  }

  //-----------------------------------------------------------------------------

  // UPDATE A NOTE
  Future<void> updateNote(int id, String newText) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.text = newText;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes();
    }
  }

  //-----------------------------------------------------------------------------

  // DELETE A NOTE
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
  }
}
