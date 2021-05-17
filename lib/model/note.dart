import 'package:flutter/material.dart';

class Note {
  String? id;
  String description;
  int? color;
  Offset offset;

  Note({
    this.id,
    this.description = 'Drag me, edit me, delete me. ',
    this.color,
    required this.offset,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'color': color,
      'offsetX': offset.dx,
      'offsetY': offset.dy,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      description: json['description'],
      color: json['color'],
      offset: Offset(json['offsetX'], json['offsetY']),
    );
  }
}
