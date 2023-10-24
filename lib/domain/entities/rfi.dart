class RFI {
  final int idRfi;
  final String name;
  final String status;

  RFI({
    required this.idRfi,
    required this.name,
    required this.status,
  });

  factory RFI.fromJson(Map<String, dynamic> json) => RFI(
        idRfi: json["idRfi"],
        name: json["name"],
        status: json["status"] ?? "pending",
      );
}
