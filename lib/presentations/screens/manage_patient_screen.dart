import 'package:flutter/material.dart';
import 'package:speak_app_web/presentations/screens/patient_section/tab_bar_patient.dart';
import 'package:speak_app_web/presentations/widgets/text_primary.dart';
import '../../../config/theme/app_theme.dart';

class ManagePatientScreen extends StatelessWidget {
  const ManagePatientScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
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
              child: TextPrimary(text: "Paciente: Hamiltons", color: Theme.of(context).primaryColorDark)),
          const SizedBox(
            height: 30,
          ),
          //const TabBarPatient(),
        ],
      ),
    );
  }
}
