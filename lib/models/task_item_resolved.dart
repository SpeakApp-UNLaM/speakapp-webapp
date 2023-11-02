class TaskItemResolved {
  String? resultExpected;
  String resultSelected;

  TaskItemResolved({
    required this.resultExpected,
    required this.resultSelected,
  });

  factory TaskItemResolved.fromJson(Map<String, dynamic> json) => TaskItemResolved(
        resultExpected: json['resultExpected'],
        resultSelected: json['resultSelected'],
      );

  Map<String, dynamic> toJson() => {
        "resultExpected": resultExpected,
        "resultSelected": resultSelected,
      };

}
