import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_note_app/model/note.dart';
import 'package:flutter_firebase_note_app/provider/notes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoteWidget extends StatefulWidget {
  final Note note;
  NoteWidget(this.note);

  @override
  _NoteWidgetState createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  bool hasTapped = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.note.offset.dx,
      top: widget.note.offset.dy,
      child: Draggable(
        feedback: Image.asset(
          'assets/0_sticky.png',
          height: 110 * 0.75,
          width: 420 * 0.75,
          color: Colors.grey,
          colorBlendMode: BlendMode.modulate,
        ),
        onDraggableCanceled: (velocity, offset) async {
          setState(() {
            widget.note.offset = Offset(offset.dx, offset.dy - 50);
          });
          await context.read(notesProvider.notifier).updateNote(widget.note);
        },
        child: Row(
          children: [
            Container(
              height: 110 * 0.75,
              width: 420 * 0.75,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/${widget.note.color}_sticky.png'),
                ),
              ),
              child: hasTapped
                  ? Center(
                      child: Container(
                        height: 110 * 0.7,
                        width: 420 * 0.6,
                        child: TextFormField(
                          initialValue: widget.note.description,
                          autofocus: true,
                          maxLength: 90,
                          maxLines: 3,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontFamily: 'Anzu', fontSize: 14),
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            border: InputBorder.none,
                          ),
                          cursorColor: Colors.pink,
                          onFieldSubmitted: (value) async {
                            widget.note.description = value;
                            await context
                                .read(notesProvider.notifier)
                                .updateNote(widget.note);
                            setState(() {
                              hasTapped = false;
                            });
                          },
                        ),
                      ),
                    )
                  : Center(
                      child: Container(
                        height: 110 * 0.5,
                        width: 420 * 0.6,
                        child: Text(
                          widget.note.description,
                          style: TextStyle(fontFamily: 'Anzu', fontSize: 15),
                          textAlign: TextAlign.start,
                          softWrap: true,
                        ),
                      ),
                    ),
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.delete_forever_rounded),
                  iconSize: 21,
                  color: Colors.grey,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  tooltip: 'delete',
                  onPressed: () async {
                    await context
                        .read(notesProvider.notifier)
                        .deleteNote(widget.note);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  iconSize: 21,
                  color: Colors.grey,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  tooltip: 'edit',
                  onPressed: () {
                    setState(() {
                      hasTapped = true;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
