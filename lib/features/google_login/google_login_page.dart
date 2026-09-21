// import 'dart:io';
// import 'package:demo/constants/app_keys.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class GoogleLoginPage extends StatefulWidget {
//   const GoogleLoginPage({super.key});

//   @override
//   State<GoogleLoginPage> createState() => _GoogleLoginPageState();
// }

// class _GoogleLoginPageState extends State<GoogleLoginPage> {
//   final GoogleSignIn googleSignIn = GoogleSignIn.instance;

// @override
//   initState() {
//     super.initState();
//     initGoogleSignIn();
//   }

//   void initGoogleSignIn() async {
//     if (kIsWeb) {
//       await GoogleSignIn.instance.initialize(clientId: AppKeys.serverClientId);
//     } else if (Platform.isIOS) {
//       await GoogleSignIn.instance.initialize(
//         clientId: AppKeys.iosClientId,
//         serverClientId: AppKeys.serverClientId,
//       );
//     } else {
//       await GoogleSignIn.instance.initialize(
//         serverClientId: AppKeys.serverClientId,
//       );
//     }
//   }

//   Future<UserCredential?> signInWithGoogle() async {
//     try {
//       if (kIsWeb) {
//         final provider = GoogleAuthProvider();
//         return await FirebaseAuth.instance.signInWithPopup(provider);
//       }

//       final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

//       final GoogleSignInAuthentication googleAuth = googleUser.authentication;

//       final credential = GoogleAuthProvider.credential(
//         idToken: googleAuth.idToken,
//       );

//       return await FirebaseAuth.instance.signInWithCredential(credential);
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             final userCredential = await signInWithGoogle();
//             if (userCredential != null) {
//               print("User signed in: ${userCredential.user?.displayName}");
//             }
//           },
//           child: const Text('Login with Google'),
//         ),
//       ),
//     );
//   }
// }
