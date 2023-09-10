import 'package:flutter/material.dart';
import 'package:speak_app_web/widgets/list_phonemes.dart';
import 'package:speak_app_web/widgets/menu_lateral_exercise.dart';

class ManageExercises extends StatelessWidget {
  const ManageExercises({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 23, vertical: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListLateral(),
          SizedBox(
            width: 50,
          ),
          BlockPhoneme()
        ],
      ),
    );
  }
}
