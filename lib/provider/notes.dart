import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_note_app/model/note.dart';
import 'package:flutter_firebase_note_app/provider/tabIndex.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notesProvider =
    StateNotifierProvider.autoDispose<NotesNotifier, List<Note>>((ref) {
  ref.maintainState = true;
  return NotesNotifier(ref.watch(tabIndexProvider).state);
});

class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier(this.tabIndex) : super([]);
  final int tabIndex;

  Future<void> getNotes() async {
    late final snapshot;
    if (tabIndex == 0) {
      snapshot = await FirebaseFirestore.instance.collection('notes').get();
    } else {
      snapshot = await FirebaseFirestore.instance
          .collection('notes')
          .where('color', isEqualTo: tabIndex - 1)
          .get();
    }
    state = [...snapshot.docs.map((e) => Note.fromJson(e.data()))];
  }

  Future<void> addNote(Offset offset, int color) async {
    final docNote = FirebaseFirestore.instance.collection('notes').doc();
    final note = Note(offset: offset, color: color, id: docNote.id);
    await docNote.set(note.toJson());
    await getNotes();
  }

  Future<void> deleteNote(Note note) async {
    final docNote = FirebaseFirestore.instance.collection('notes').doc(note.id);
    await docNote.delete();
    await getNotes();
  }

  Future<void> updateNote(Note note) async {
    final docNote = FirebaseFirestore.instance.collection('notes').doc(note.id);
    await docNote.update(note.toJson());
    await getNotes();
  }
}
