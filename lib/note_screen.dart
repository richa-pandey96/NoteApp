import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'note_model.dart';

class NotesScreen extends StatefulWidget {
  final Note? note;
  const NotesScreen({super.key, this.note});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final CollectionReference myNotes =
      FirebaseFirestore.instance.collection('notes');
  late TextEditingController titleController;
  late TextEditingController noteController;
  late String titleString;
  late String noteString;
  late int color;
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;

    titleString = widget.note?.title ?? '';
    noteString = widget.note?.note ?? '';
    color = widget.note?.color ?? generateRandomLightColor();
    titleController = TextEditingController(text: titleString);
    noteController = TextEditingController(text: noteString);
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                    child: BackButton(color: Colors.white),
                  ),
                  Text(
                    widget.note == null ? 'Add note' : 'Edit note',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            await saveNotes();
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.save,
                            color: Colors.white,
                          ),
                        ),
                        if (widget.note !=null && widget.note!.id.isNotEmpty)
                          IconButton(
                            onPressed: () async {
                              await myNotes.doc(widget.note!.id).delete();
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText:  widget.note?.title ?? 'Note Title',
                ),
                onChanged: (value) {
                  titleString = value;
                },
              ),
              Expanded(
                child: TextField(
                  controller: noteController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Note Content",
                  ),
                  onChanged: (value) {
                    noteString = value;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveNotes() async {
    DateTime now = DateTime.now();

    if (currentUser == null) {
      print("User not logged in");
      return;
    }

    try {
      if (widget.note == null) {
        // New note creation
        await myNotes.add({
          'title': titleString,
          'note': noteString,
          'color': color,
          'createdAt': now,
          'userId': currentUser!.uid,
        });
      } else {
        //assert(widget.note!.id.isNotEmpty, "Document ID is required");
        // Existing note update
        //await myNotes.doc(widget.note!.id).update({
        await FirebaseFirestore.instance.collection('notes').doc(widget.note!.id).update({
          'title': titleString,
          'note': noteString,
          'color': color,
          'updatedAt': now,
          'userId': currentUser!.uid,
        });
      }
    } catch (e) {
      print("Error saving note: $e");
    }
  }

  int generateRandomLightColor() {
    Random random = Random();
    int r = random.nextInt(128) + 128; // Ensures light color
    int g = random.nextInt(128) + 128;
    int b = random.nextInt(128) + 128;
    return (0xFF << 24) | (r << 16) | (g << 8) | b;
  }
}
