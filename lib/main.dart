import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_note_app/view/login_page.dart';
import 'package:flutter_firebase_note_app/view/note_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'provider/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: NoteApp()));
}

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note App',
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        accentColor: Colors.amber,
        scaffoldBackgroundColor: Colors.amber[50],
      ),
      home: Consumer(
        builder: (context, watch, child) {
          final user = watch(userNotifierProvider).user;
          return user == null ? LoginPage() : NotePage();
        },
      ),
    );
  }
}
