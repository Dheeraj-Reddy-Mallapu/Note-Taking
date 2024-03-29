import 'package:note_taking_firebase/objects/note.dart';

class DrawingNote extends Note {
  String url;
  int canvaColor;

  DrawingNote({
    required super.id,
    required super.type,
    required super.title,
    required this.url,
    required super.receivedFrom,
    required super.sentTo,
    required super.deleted,
    required super.isFav,
    required super.createdAt,
    required super.modifiedAt,
    required super.deletedAt,
    required super.restoredAt,
    required super.color,
    required this.canvaColor,
  });

  factory DrawingNote.fromMap(Map<String, dynamic> map) {
    final note = Note.fromMap(map);

    return DrawingNote(
        id: note.id,
        type: note.type,
        title: note.title,
        url: map["url"],
        receivedFrom: note.receivedFrom,
        sentTo: note.sentTo,
        deleted: note.deleted,
        isFav: note.isFav,
        createdAt: note.createdAt,
        modifiedAt: note.modifiedAt,
        deletedAt: note.deletedAt,
        restoredAt: note.restoredAt,
        color: note.color,
        canvaColor: map["canvaColor"]);
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "type": type,
        "title": title,
        "url": url,
        "receivedFrom": receivedFrom,
        "sentTo": List<String>.from(sentTo.map((x) => x)),
        "deleted": deleted,
        "isFav": isFav,
        "createdAt": createdAt,
        "modifiedAt": modifiedAt,
        "deletedAt": deletedAt,
        "restoredAt": restoredAt,
        "color": color,
        "canvaColor": canvaColor
      };
}
