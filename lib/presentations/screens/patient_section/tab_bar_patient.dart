import 'package:flutter/material.dart';
import '../../widgets/text_primary.dart';
import 'exercises_results.dart';
import 'manage_exercises.dart';
import 'patient_info.dart';
import 'rfi_results.dart';
import 'session_reports.dart';

class TabBarPatient extends StatefulWidget {
  const TabBarPatient({super.key});

  @override
  State<TabBarPatient> createState() => _TabBarPatientState();
}

class _TabBarPatientState extends State<TabBarPatient>
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
        children: [
          TabBar(
            overlayColor: const MaterialStatePropertyAll(Colors.transparent),
            controller: _tabController,
            tabs: [
              Tab(
                  child: TextPrimary(
                text: 'Gestionar ejercicios',
                color: Theme.of(context).primaryColorDark)
              ),
              Tab(
                  child: TextPrimary(
                text: 'Resultados de ejercicios',
                color: Theme.of(context).primaryColorDark)
              ),
              Tab(
                  child: TextPrimary(
                text: 'Resultados TEST RFI',
                 color: Theme.of(context).primaryColorDark)
              ),
              Tab(
                  child: TextPrimary(
                      text: 'Datos del paciente',
                      color: Theme.of(context).primaryColorDark)),
              Tab(
                  child: TextPrimary(
                      text: 'Pacientes',
                      color: Theme.of(context).primaryColorDark)),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
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
