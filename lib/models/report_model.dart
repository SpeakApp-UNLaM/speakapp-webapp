class ReportModel {
  int id;
  String title;
  String body;
  String createdAt;
  bool isExpanded;

  ReportModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isExpanded = true
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        id: json['id'],
        title: json['title'],
        body: json['body'],
        createdAt: json['createdAt'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "body": body,
        "createdAt": createdAt,
      };
}
