import 'package:flutter/material.dart';

import '../../widgets/list_phonemes.dart';
import '../../widgets/menu_lateral_exercise.dart';

class ManageExercises extends StatelessWidget {
  final int idPatient;
  const ManageExercises({
    super.key,
    required this.idPatient
  });

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 23, vertical: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //const ListLateral(),
          const SizedBox(
            width: 50,
          ),
          BlockPhoneme(idPatient: idPatient)
        ],
      ),
    );
  }
}
