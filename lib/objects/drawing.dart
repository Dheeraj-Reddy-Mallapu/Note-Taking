class Drawing {
  String id;
  String type;
  String title;
  String url;
  String sentBy;
  List<dynamic> sentTo;
  bool deleted;
  bool isFav;
  String createdAt;
  String modifiedAt;
  String deletedAt;
  String restoredAt;
  int color;
  int canvaColor;

  Drawing({
    required this.id,
    required this.type,
    required this.title,
    required this.url,
    required this.sentBy,
    required this.sentTo,
    required this.deleted,
    required this.isFav,
    required this.createdAt,
    required this.modifiedAt,
    required this.deletedAt,
    required this.restoredAt,
    required this.color,
    required this.canvaColor,
  });

  factory Drawing.fromMap(Map<String, dynamic> drawing) => Drawing(
        id: drawing["id"],
        type: drawing["type"],
        title: drawing["title"],
        url: drawing["url"],
        sentBy: drawing["sentBy"],
        sentTo: List<dynamic>.from(drawing["sentTo"].map((x) => x)),
        deleted: drawing["deleted"],
        isFav: drawing["isFav"],
        createdAt: drawing["createdAt"],
        modifiedAt: drawing["modifiedAt"],
        deletedAt: drawing["deletedAt"],
        restoredAt: drawing["restoredAt"],
        color: drawing["color"],
        canvaColor: drawing["canvaColor"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "type": type,
        "title": title,
        "url": url,
        "sentBy": sentBy,
        "sentTo": List<dynamic>.from(sentTo.map((x) => x)),
        "deleted": deleted,
        "isFav": isFav,
        "createdAt": createdAt,
        "modifiedAt": modifiedAt,
        "deletedAt": deletedAt,
        "restoredAt": restoredAt,
        "color": color,
        "canvaColor": canvaColor,
      };
}
