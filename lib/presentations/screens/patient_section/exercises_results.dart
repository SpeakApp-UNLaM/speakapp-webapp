import 'package:flutter/material.dart';
import 'package:speak_app_web/presentations/widgets/list_finished_exercises.dart';

class ExercisesResults extends StatelessWidget {
  final int idPatient;
  const ExercisesResults({
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
          ListFinishedExercises(idPatient: idPatient)
        ],
      ),
    );
  }
}
