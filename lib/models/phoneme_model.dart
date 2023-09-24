import '../domain/entities/phoneme.dart';

class PhonemeModel {
  int idPhoneme;
  String namePhoneme;

  PhonemeModel({
    required this.idPhoneme,
    required this.namePhoneme,
  });

  factory PhonemeModel.fromJson(Map<String, dynamic> json) => PhonemeModel(
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
