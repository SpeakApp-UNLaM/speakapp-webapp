import 'package:flutter/material.dart';
import 'package:speak_app_web/screens/patient_section/exercises_results.dart';
import 'package:speak_app_web/screens/patient_section/manage_exercises.dart';
import 'package:speak_app_web/screens/patient_section/patient_info.dart';
import 'package:speak_app_web/screens/patient_section/rfi_results.dart';
import 'package:speak_app_web/widgets/text_primary.dart';

import '../../widgets/session_reports.dart';

class SecondTabBarPatient extends StatefulWidget {
  const SecondTabBarPatient({super.key});

  @override
  State<SecondTabBarPatient> createState() => _SecondTabBarPatientState();
}

class _SecondTabBarPatientState extends State<SecondTabBarPatient>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: <Widget>[
          TabBar.secondary(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                  child: TextPrimary(
                text: 'Gestionar ejercicios',
              )),
              Tab(
                  child: TextPrimary(
                text: 'Resultados de ejercicios',
              )),
              Tab(
                  child: TextPrimary(
                text: 'Resultados TEST RFI',
              )),
              Tab(
                  child: TextPrimary(
                text: 'Datos del paciente',
              )),
              Tab(
                  child: TextPrimary(
                text: 'Informes de sesiones',
              )),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const <Widget>[
                ManageExercises(),
                ExercisesResults(),
                RFIResults(),
                PatientInfo(),
                SessionReports(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
