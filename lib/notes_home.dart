import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/note_card.dart';
import 'package:note_app/note_screen.dart';
import 'package:note_app/note_model.dart';
import 'login_screen.dart';

class NotesHomesScreen extends StatefulWidget {
  const NotesHomesScreen({super.key});

  @override
  State<NotesHomesScreen> createState() => _NotesHomesScreenState();
}

class _NotesHomesScreenState extends State<NotesHomesScreen> {
  Query? myNotes=FirebaseFirestore.instance.collection('notes');

  @override
  void initState() {
    super.initState();
    
    // Get the current user's ID
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null && userId.isNotEmpty) {
      // Create the query to get notes for the current user
      myNotes = FirebaseFirestore.instance
          .collection('notes')
          .where('userId', isEqualTo: userId);
    } else {
      // Handle the case where the user is not logged in or the user ID is empty
      print('User is not logged in or UID is empty');
      // You may want to redirect to a login screen or show an error message here
      // Example: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  void _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("Error during logout: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error during logout')),
      );
    }
  }

  void _handleCreateNote() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to log in to create a note')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
           builder: (context) => const NotesScreen(note: null),  // Pass null to create a new note
      
          // builder: (context) => NotesScreen(
          //   note: Note(
          //     id: '',
          //     title: '',
          //     note: '',
          //     createdAt: DateTime.now(),
          //     updatedAt: DateTime.now(),
          //     userId: user.uid,
          //     color: Note.generateRandomLightColor(),
          //
          //   ),
        ),
          );
        //),
      //);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 190, 40),
        title: const Text(
          'Note App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Color.fromARGB(255, 198, 60, 0),
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'logout') {
                _handleLogout();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ];
            },
          ),
        ],
      ),
      body: myNotes != null
          ? StreamBuilder<QuerySnapshot>(
              stream: myNotes!.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No notes found"));
                } else {
                  final notes = snapshot.data!.docs;
                  List<NoteCard> noteCards = notes.map((note) {
                    var data = note.data() as Map<String, dynamic>;
                    print("Note data: $data");
                    Note noteObject = Note(
                      id: note.id,
                      title: data['title'] ?? "",
                      note: data['note'] ?? "",
                      createdAt: (data['createdAt'] is Timestamp)
                          ? (data['createdAt'] as Timestamp).toDate()
                          : DateTime.now(),
                      updatedAt: (data['updatedAt'] is Timestamp)
                          ? (data['updatedAt'] as Timestamp).toDate()
                          : DateTime.now(),
                      color: data['color'] ?? 0xFFFFFFFF,
                      userId: data['userId'] ?? '',
                    );

                    return NoteCard(
                      note: noteObject,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotesScreen(note: noteObject),
                          ),
                        );
                      },
                    );
                  }).toList();

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: noteCards.length,
                    itemBuilder: (context, index) {
                      return noteCards[index];
                    },
                    padding: const EdgeInsets.all(3),
                  );
                }
              },
            )
          : const Center(child: Text('Please log in to view your notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleCreateNote,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
