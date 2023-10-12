import '../domain/entities/phoneme.dart';

class PhonemeTaskResolvedModel {
  int idPhoneme;
  String namePhoneme;

  PhonemeTaskResolvedModel({
    required this.idPhoneme,
    required this.namePhoneme,
  });

  factory PhonemeTaskResolvedModel.fromJson(Map<String, dynamic> json) => PhonemeTaskResolvedModel(
        idPhoneme: json['idPhoneme'],
        namePhoneme: json['namePhoneme'],
      );

  Map<String, dynamic> toJson() => {
        "idPhoneme": idPhoneme,
        "namePhoneme": namePhoneme,
      };

  Phoneme toPhonemeEntity() =>
      Phoneme(idPhoneme: idPhoneme, namePhoneme: namePhoneme);
}
