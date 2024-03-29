import 'dart:convert';

import 'package:note_taking_firebase/objects/note.dart';

class TextNote extends Note {
  String content;

  TextNote({
    required super.id,
    required super.type,
    required super.title,
    required this.content,
    required super.receivedFrom,
    required super.sentTo,
    required super.deleted,
    required super.isFav,
    required super.createdAt,
    required super.modifiedAt,
    required super.deletedAt,
    required super.restoredAt,
    required super.color,
  });

  factory TextNote.fromMap(Map<String, dynamic> map) {
    final note = Note.fromMap(map);

    return TextNote(
      id: note.id,
      type: note.type,
      title: note.title,
      content: utf8.decode(base64Url.decode(map["content"])),
      receivedFrom: note.receivedFrom,
      sentTo: note.sentTo,
      deleted: note.deleted,
      isFav: note.isFav,
      createdAt: note.createdAt,
      modifiedAt: note.modifiedAt,
      deletedAt: note.deletedAt,
      restoredAt: note.restoredAt,
      color: note.color,
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "type": type,
        "title": title,
        "content": content,
        "receivedFrom": receivedFrom,
        "sentTo": List<String>.from(sentTo.map((x) => x)),
        "deleted": deleted,
        "isFav": isFav,
        "createdAt": createdAt,
        "modifiedAt": modifiedAt,
        "deletedAt": deletedAt,
        "restoredAt": restoredAt,
        "color": color,
      };
}

// List<Note> notes = [];
