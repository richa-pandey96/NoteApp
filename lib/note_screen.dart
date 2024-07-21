import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
import 'package:note_app/note_model.dart';
 

class NotesScreen extends StatefulWidget {
  final Note note;
  const NotesScreen({super.key, required this.note});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final CollectionReference myNotes=
        FirebaseFirestore.instance.collection('notes');
  TextEditingController? titleController;
  TextEditingController? noteContoller;
  Note? note;
  String titleString="";
  String noteString="";
  int? color;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    note=widget.note;
    titleString=note!.title;
    noteString=note!.note;
    color=note!.color==0xFFFFFFFF ? generateRandomLightColor():note!.color;
    titleController=TextEditingController(text:titleString);
    noteContoller=TextEditingController(text: noteString);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Padding(padding:const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:Colors.grey,
              ),
              child:BackButton(color:Colors.white,),
            ),
            Text(
              note!.id.isEmpty?'Add note':'Edit note',
              style: const TextStyle(fontWeight: FontWeight.bold,
              fontSize: 20,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:Colors.grey,
              ),
              child:Row(children: [
                IconButton(onPressed: () {
                  saveNotes();
                  Navigator.pop(context);
                }, 
                icon: const Icon(
                  Icons.save,
                  color:Colors.white,
                ),
                ),
                if(note!.id.isNotEmpty)
                IconButton(onPressed: () {
                  myNotes.doc(note!.id).delete();
                  Navigator.pop(context);
                }, 
                icon: const Icon(
                  Icons.save,
                  color:Colors.white,
                ),
                ),
              ],)
            ),
            ],
            ),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Note Title",
            ),
            onChanged: (value){
                titleString=value;
              },
          ),
          Expanded(
            child: TextField(
              controller: noteContoller,
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Note Content",
              ),
              onChanged: (value){
                noteString=value;
              },
            ),
          ),
        ],
      ),
      ),
      ),
    );
  }

//for save and update the notes
void saveNotes() async{
  DateTime now=DateTime.now();
  //var note;
  if(note!.id.isEmpty){
    await myNotes.add({
      'title':titleString,
      'note':noteString,
      'color':color,
      'createdAt':now,
    });
  }
  else{
    await myNotes.doc(note!.id).update({
      'title':titleString,
      'note':noteString,
      'color':color,
      'updatedAt':now,

    });
  }
  }

    
}


