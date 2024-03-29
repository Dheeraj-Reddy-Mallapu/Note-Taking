import 'dart:convert';

class Note {
  String id;
  String type;
  String title;
  String receivedFrom;
  List<String> sentTo;
  bool deleted;
  bool isFav;
  String createdAt;
  String modifiedAt;
  String deletedAt;
  String restoredAt;
  int color;

  Note({
    required this.id,
    required this.type,
    required this.title,
    required this.receivedFrom,
    required this.sentTo,
    required this.deleted,
    required this.isFav,
    required this.createdAt,
    required this.modifiedAt,
    required this.deletedAt,
    required this.restoredAt,
    required this.color,
  });

  Note copyWith({
    String? id,
    String? type,
    String? title,
    String? content,
    String? receivedFrom,
    List<String>? sentTo,
    bool? deleted,
    bool? isFav,
    String? createdAt,
    String? modifiedAt,
    String? deletedAt,
    String? restoredAt,
    int? color,
  }) =>
      Note(
        id: id ?? this.id,
        type: type ?? this.type,
        title: title ?? this.title,
        receivedFrom: receivedFrom ?? this.receivedFrom,
        sentTo: sentTo ?? this.sentTo,
        deleted: deleted ?? this.deleted,
        isFav: isFav ?? this.isFav,
        createdAt: createdAt ?? this.createdAt,
        modifiedAt: modifiedAt ?? this.modifiedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        restoredAt: restoredAt ?? this.restoredAt,
        color: color ?? this.color,
      );

  factory Note.fromMap(Map<String, dynamic> note) => Note(
        id: note["id"],
        type: note["type"] ?? "note",
        title: utf8.decode(base64Url.decode(note["title"])).toString(),
        receivedFrom: note["sentBy"] ?? note["receivedFrom"] ?? "",
        sentTo: note["sentTo"] == null ? [] : List<String>.from(note["sentTo"]!.map((x) => x)),
        deleted: note["deleted"] ?? false,
        isFav: note["isFav"] is String ? bool.parse(note["isFav"]) : note["isFav"] ?? false,
        createdAt: note["createdAt"],
        modifiedAt: note["modifiedAt"] ?? "",
        deletedAt: note["deletedAt"] ?? "",
        restoredAt: note["restoredAt"] ?? "",
        color: note.containsKey("color") ? note["color"] : 0,
      );
}
