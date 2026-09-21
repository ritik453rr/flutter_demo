// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class ChatListPage extends StatefulWidget {
//   const ChatListPage({super.key});

//   @override
//   State<ChatListPage> createState() => _ChatListPageState();
// }

// Stream<QuerySnapshot> collectionStream = FirebaseFirestore.instance
//     .collection('chats')
//     .snapshots();

// class _ChatListPageState extends State<ChatListPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:StreamBuilder<QuerySnapshot>(
//       stream: collectionStream,
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return Center(child: Text('Something went wrong'));
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: Text("Loading"));
//         }

//         if (snapshot.data!.docs.isEmpty) {
//           return Center(
//             child: Text('No chats available'),
//           );
//         }



//         return ListView(
//           children: snapshot.data!.docs.map((DocumentSnapshot document) {
//           Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
//             return ListTile(
//               title: Text(data['chatId']??'no message'),
            
//             );
//           }).toList(),
//         );
//       },
//     )
//     );
//   }
// }
