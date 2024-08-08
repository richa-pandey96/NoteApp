// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:note_app/login_screen.dart';

// // class Welcome extends StatefulWidget {
// //   const Welcome({super.key});

// //   @override
// //   State<Welcome> createState() => _WelcomeState();
// // }

// // class _WelcomeState extends State<Welcome> {
// //   final FirebaseAuth _auth= FirebaseAuth.instance;
// //   @override
// //   Widget build(BuildContext context) {
// //     // ignore: unused_local_variable
    
// //     String? _email=_auth.currentUser!.email;
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Dashboard"),
// //       ),
// //       body: Center(
// //         child: Padding(
// //           padding: EdgeInsets.all(20),
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Text("Logged In With: $_email"),
// //               SizedBox(
// //                 height:50,
// //                 ),
// //                 ElevatedButton(
// //                   child: Text("Signout",),
// //                   onPressed:(){
// //                   _auth.signOut();
// //                   Navigator.push(
// //                     context,
// //                     MaterialPageRoute(
// //                       builder: (context)=>LoginScreen(),
// //                   ));
// //                   },
// //                   ),
                
// //             ],
// //             ),
// //             ),
// //             ),
// //     );
// //   }
// // }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:note_app/note_card.dart';
// import 'package:note_app/note_screen.dart';
// //import 'package:flutter/widgets.dart';
// import'package:note_app/note_model.dart';
// class NotesHomesScreen extends StatefulWidget {
//   const NotesHomesScreen({super.key});

//   @override
//   State<NotesHomesScreen> createState() => _NotesHomesScreenState();
// }

// class _NotesHomesScreenState extends State<NotesHomesScreen> {
//   final CollectionReference myNotes=
//         FirebaseFirestore.instance.collection('notes');
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
      
//         appBar:AppBar(
//           backgroundColor: Color.fromARGB(255, 239, 181, 7),
//           title: Text(
//             'Note App',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 22,
//               color: Color.fromARGB(198, 143, 0, 124),
//             ),
//           ),
//           centerTitle: true,

//         ) ,
//         body: 
//             StreamBuilder<QuerySnapshot>(
              
//               stream: myNotes.snapshots(),
//              builder:(context,snapshot){
//               // if(!snapshot.hasData){
//               //   // return Center(child: CircularProgressIndicator(),
//               //   // );
//               //   return Text("hkkkk");
//               // }
//               // else{
//                if (snapshot.connectionState == ConnectionState.waiting) {
//       return Center(child: CircularProgressIndicator());
//     }
//     else if (snapshot.hasError) {
//       return Center(child: Text("Error: ${snapshot.error}"));
//     }
//     else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//       return Center(child: Text("No notes found"));
//     }else{
                
//               final notes=snapshot.data!.docs;
//               List<NoteCard> noteCards=[];
//               for(var note in notes){
//                 var data=note.data() as Map<String, dynamic>?;
//                 if(data!=null){
//                   Note noteObject=Note(
//                     id: note.id,
//                      title: data['title']??"",
//                       note: data['note']??"", 
//                       createdAt:data.containsKey('createdAt')
//                       ?(data['createdAt'] as Timestamp).toDate()
//                       :DateTime.now(),
//                      updatedAt: data.containsKey('updatedAt')
//                      ?(data['updatedAt'] as Timestamp).toDate()
//                      :DateTime.now(),
//                      color: data.containsKey('color')?data['color']
//                      :0xFFFFFFFF,
//                     );
//                     noteCards.add(
//                       NoteCard(
//                         note:noteObject,
//                         onPressed:() {
//                           Navigator.push(context, 
//                           MaterialPageRoute(builder: (context)=>
//                           NotesScreen(note: noteObject),
//                           ),
//                           );
//                         },
//                       ),
//                     );
//                 }
//               }
//               return GridView.builder(
//                 gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                  ),
//                  itemCount: noteCards.length,
//                  itemBuilder: (context,index){
//                   return noteCards[index];
//                  },
//                  padding: EdgeInsets.all(3),
//                  );
              


//              }
//   },

  
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed:(){
//             Navigator.push(context,
//             MaterialPageRoute(
//               builder: (context)=>NotesScreen(
//               note:Note(
//                 id:'',
//                 title:'',
//                 note:'',
//                 createdAt:DateTime.now(), 
//             updatedAt:DateTime.now(),
//             ),
//             ),
//             ),
//             );
//           },
//           backgroundColor: Colors.blue,
//           child: const Icon (Icons.add,color:Colors.white),),
//     );
//   }
// }