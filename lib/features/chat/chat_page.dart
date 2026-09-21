// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class ChatPage extends StatefulWidget {
//   const ChatPage({super.key});

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   // controllers
//   var messageController = TextEditingController();
//   final ScrollController scrollController = ScrollController();
//   // Lists
//   var messageList = <MsgModel>[];

//   // Variables
//   bool isMe = false;

//   Future<void> scrollToBottom() async {
//     if (!scrollController.hasClients) return;
//     scrollController.animateTo(
//       scrollController.position.maxScrollExtent+80,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeOut,
//     );
//   }

//   void sendMessage() {
//     final newMessage = messageController.text.trim();
//     if (newMessage.isEmpty) return;

//     isMe = !isMe;

//     final msg = MsgModel(
//       message: newMessage,
//       senderId: "user1",
//       timestamp: DateTime.now().toIso8601String(),
//       isCurrentUser: isMe,
//     );
//     setState(() {
//       messageList.add(msg);
//       messageController.clear();
//     });
//     // Scroll AFTER the new message has been rendered.
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       scrollToBottom();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.translucent,
//       onTap: () {
//         FocusManager.instance.primaryFocus?.unfocus();
//       },
//       child: Scaffold(
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 20),
//                 Text(
//                   "Chat Page",
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 messageList.isEmpty
//                     ? Expanded(
//                         child: Center(
//                           child: Text(
//                             "No messages yet",
//                             style: TextStyle(fontSize: 16, color: Colors.grey),
//                           ),
//                         ),
//                       )
//                     : Expanded(
//                         child: ScrollConfiguration(
//                           behavior: ScrollConfiguration.of(
//                             context,
//                           ).copyWith(scrollbars: false),
//                           child: ListView.builder(
//                             // reverse: true,
//                             controller: scrollController,
//                             itemCount: messageList.length,
//                             padding: EdgeInsets.symmetric(vertical: 16),
//                             itemBuilder: (context, index) {
//                               final msg = messageList[index];
//                               return MsgBubble(
//                                 message: msg.message,
//                                 timestamp: msg.timestamp,
//                                 isCurrentUser: msg.isCurrentUser,
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                 TextField(
//                   maxLines: 6,
//                   minLines: 1,
//                   controller: messageController,
//                   decoration: InputDecoration(
//                     hintText: 'Type a message',
//                     border: OutlineInputBorder(),
//                     suffixIconConstraints: BoxConstraints(
//                       minWidth: 48,
//                       minHeight: 48,
//                     ),
//                     suffixIcon: IconButton(
//                       icon: Icon(Icons.send),
//                       onPressed: () {
//                         sendMessage();
//                       },
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MsgBubble extends StatelessWidget {
//   final String message;
//   final String timestamp;
//   final bool isCurrentUser;

//   const MsgBubble({
//     super.key,
//     required this.message,
//     required this.timestamp,
//     required this.isCurrentUser,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final time = DateFormat(
//       'hh:mm a',
//     ).format(DateTime.parse(timestamp).toLocal());

//     return Align(
//       alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * .75,
//         ),
//         margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//         decoration: BoxDecoration(
//           color: isCurrentUser ? Colors.blue : Colors.grey.shade200,
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(18),
//             topRight: const Radius.circular(18),
//             bottomLeft: Radius.circular(isCurrentUser ? 18 : 4),
//             bottomRight: Radius.circular(isCurrentUser ? 4 : 18),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               message,
//               style: TextStyle(
//                 color: isCurrentUser ? Colors.white : Colors.black87,
//                 fontSize: 15,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               time,
//               style: TextStyle(
//                 fontSize: 11,
//                 color: isCurrentUser ? Colors.white70 : Colors.grey,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MsgModel {
//   final String message;
//   final String senderId;
//   final String timestamp;
//   final bool isCurrentUser;

//   MsgModel({
//     required this.message,
//     required this.senderId,
//     required this.timestamp,
//     this.isCurrentUser = true,
//   });

//   // Converts a JSON map into a MsgModel instance.
//   factory MsgModel.fromJson(Map<String, dynamic> json) {
//     return MsgModel(
//       message: json['message'] ?? "",
//       senderId: json['senderId'] ?? "",
//       timestamp: json['timestamp'] ?? "",
//       isCurrentUser: json['isCurrentUser'] ?? false,
//     );
//   }
//   // Converts a MsgModel instance into a JSON map.
//   Map<String, dynamic> toJson() {
//     return {
//       'message': message,
//       'senderId': senderId,
//       'timestamp': timestamp,
//       'isCurrentUser': isCurrentUser,
//     };
//   }
// }

// class ChatModel {
//   final String chatId;
//   final List<String> participants;
//   final String lastMessage;
//   final String lastMessageSenderId;
//   final String lastMessageTime;
//   final String createdAt;

//   const ChatModel({
//     required this.chatId,
//     required this.participants,
//     required this.lastMessage,
//     required this.lastMessageSenderId,
//     required this.lastMessageTime,
//     required this.createdAt,
//   });

//   factory ChatModel.fromJson(Map<String, dynamic> json) {
//     return ChatModel(
//       chatId: json['chatId'] ?? '',
//       participants: List<String>.from(json['participants'] ?? []),
//       lastMessage: json['lastMessage'] ?? '',
//       lastMessageSenderId: json['lastMessageSenderId'] ?? '',
//       lastMessageTime: json['lastMessageTime'] ?? '',
//           createdAt: json['createdAt'] ?? ''
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'chatId': chatId,
//       'participants': participants,
//       'lastMessage': lastMessage,
//       'lastMessageSenderId': lastMessageSenderId,
//       'lastMessageTime': lastMessageTime,
//       'createdAt': createdAt,
//     };
//   }


// }

