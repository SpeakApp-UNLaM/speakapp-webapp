class ReportModel {
  String title;
  String subtitle;
  String body;
  String date;
  bool isExpanded;

  ReportModel({
    required this.title,
    required this.subtitle,
    required this.body,
    required this.date,
    this.isExpanded = false
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        title: json['title'],
        subtitle: json['subtitle'],
        body: json['body'],
        date: json['date'],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "body": body,
        "date": date,
      };
}
