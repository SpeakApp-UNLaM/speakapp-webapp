import 'package:flutter/material.dart';

import '../config/theme/app_theme.dart';
import '../widgets/second_tab_bar_manage_patient.dart';

class ManagePatientView extends StatelessWidget {
  const ManagePatientView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          thickness: 3,
          height: 3,
          color: colorList[7],
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
            alignment: Alignment.centerLeft,
            child: Text("Paciente       Hamiltons",
                style: TextStyle(
                  fontSize: 36,
                  color: colorList[6],
                  fontFamily: 'IkkaRounded',
                ))),
        const SecondTabBarPatient(),
      ],
    );
  }
}
