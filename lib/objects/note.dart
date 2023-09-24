class Note {
  String id;
  String? type;
  String title;
  String content;
  String? sentBy;
  List<dynamic>? sentTo;
  bool? deleted;
  bool? isFav;
  String createdAt;
  String? modifiedAt;
  String? deletedAt;
  String? restoredAt;
  int? color;

  Note({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.sentBy,
    required this.sentTo,
    required this.deleted,
    required this.isFav,
    required this.createdAt,
    required this.modifiedAt,
    required this.deletedAt,
    required this.restoredAt,
    required this.color,
  });

  factory Note.fromMap(Map<String, dynamic> note) => Note(
        id: note["id"],
        type: note["type"],
        title: note["title"],
        content: note["content"],
        sentBy: note["sentBy"],
        sentTo: List<dynamic>.from(note["sentTo"] ?? [].map((x) => x)),
        deleted: note["deleted"],
        isFav: note["isFav"] is bool ? note["isFav"] : bool.parse(note["isFav"] ?? 'false'),
        createdAt: note["createdAt"],
        modifiedAt: note["modifiedAt"],
        deletedAt: note["deletedAt"],
        restoredAt: note["restoredAt"],
        color: note["color"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "type": type ?? 'note',
        "title": title,
        "content": content,
        "sentBy": sentBy ?? '',
        "sentTo": List<dynamic>.from(sentTo?.map((x) => x) ?? []),
        "deleted": deleted ?? false,
        "isFav": isFav ?? false,
        "createdAt": createdAt,
        "modifiedAt": modifiedAt ?? '',
        "deletedAt": deletedAt ?? '',
        "restoredAt": restoredAt ?? '',
        "color": color ?? 0,
      };
}

// List<Note> notes = [];
