import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_firebase_note_app/main.dart';
import 'package:flutter_firebase_note_app/provider/notes.dart';
import 'package:flutter_firebase_note_app/provider/tabIndex.dart';
import 'package:flutter_firebase_note_app/provider/user.dart';
import 'package:flutter_firebase_note_app/view/widget/note_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class NotePage extends StatefulWidget {
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 5,
      vsync: this,
    );
    Future(() async {
      await context.read(notesProvider.notifier).getNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text(
          'Double click on blank space to add notes. Note color depends on the tab you are in.',
          style: TextStyle(color: Colors.white54, fontSize: 12),
        ),
        leadingWidth: 240,
        title: Text('Note App'),
        centerTitle: true,
        actions: [
          context.read(userNotifierProvider).user!.isAnonymous
              ? Tooltip(
                  message:
                      'User ID: ${context.read(userNotifierProvider).user!.uid}',
                  child: CircleAvatar(
                    child: Icon(Icons.person),
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.blueGrey,
                  ),
                )
              : Tooltip(
                  message:
                      context.read(userNotifierProvider).user!.displayName!,
                  child: CircleAvatar(
                    foregroundImage: NetworkImage(
                        context.read(userNotifierProvider).user!.photoURL!),
                    backgroundColor: Colors.amber,
                  ),
                ),
          SizedBox(width: 21),
          _buildSignOutButton(),
          TextButton(
            onPressed: () => _launchURL(
                'https://github.com/sukesukejijii/flutter_firebase_note_app'),
            child: Image.asset('assets/github.png'),
          ),
        ],
        bottom: _buildTabBar(),
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _buildNotes(context),
        ),
      ),
    );
  }

  Widget _buildNotes(BuildContext context) {
    late Offset offset;

    return GestureDetector(
      onDoubleTap: () async {
        final color = tabController.index == 0
            ? Random().nextInt(4)
            : tabController.index - 1;
        await context.read(notesProvider.notifier).addNote(offset, color);
        await context.read(notesProvider.notifier).getNotes();
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.copy,
        onHover: (event) =>
            offset = Offset(event.position.dx, event.position.dy - 50),
        child: SizedBox(
          width: 1920,
          height: 1080,
          child: Consumer(
            builder: (context, watch, child) {
              final notes = watch(notesProvider);

              return Stack(
                children: <NoteWidget>[
                  for (var note in notes) NoteWidget(note),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSignOutButton() {
    return IconButton(
      icon: Icon(Icons.logout),
      iconSize: 30,
      tooltip: 'Sign Out',
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        context.read(userNotifierProvider).user = null;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NoteApp(),
            fullscreenDialog: true,
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildTabBar() {
    return TabBar(
      controller: tabController,
      indicatorWeight: 6,
      onTap: (value) async {
        context.read(tabIndexProvider).state = value;
        await context.read(notesProvider.notifier).getNotes();
      },
      tabs: [
        Tab(text: 'All'),
        Tab(
          icon: Icon(
            Icons.sticky_note_2_rounded,
            color: Colors.lightBlue[200],
          ),
        ),
        Tab(
          icon: Icon(
            Icons.sticky_note_2_rounded,
            color: Colors.pink[200],
          ),
        ),
        Tab(
          icon: Icon(
            Icons.sticky_note_2_rounded,
            color: Colors.amber[200],
          ),
        ),
        Tab(
          icon: Icon(
            Icons.sticky_note_2_rounded,
            color: Colors.lightGreen[200],
          ),
        ),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    await canLaunch(url)
        ? await launch(url)
        : throw Exception('Could not launch');
  }
}
