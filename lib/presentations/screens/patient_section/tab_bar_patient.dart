import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speak_app_web/config/api.dart';
import 'package:speak_app_web/config/param.dart';
import 'package:speak_app_web/models/patient_model.dart';
import '../../widgets/text_primary.dart';
import 'exercises_results.dart';
import 'manage_exercises.dart';
import 'patient_info.dart';
import 'rfi_results.dart';
import 'session_reports.dart';

class TabBarPatient extends StatefulWidget {
  final Widget child;
  final int idPatient;
  const TabBarPatient(
      {super.key, required this.child, required this.idPatient});

  @override
  State<TabBarPatient> createState() => _TabBarPatientState();
}

class _TabBarPatientState extends State<TabBarPatient>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late PatientModel patient;
  Future? _fetchData;

  Future fetchData() async {
    final response = await Api.get("${Param.getPatients}/${widget.idPatient}");

    patient = PatientModel.fromJson(response.data);
    return response;
  }

  @override
  void initState() {
    super.initState();
    _fetchData = fetchData();
    _tabController = TabController(initialIndex: 0, length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Text(
                    "Paciente: ${patient.lastName} ${patient.firstName} ",
                    style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontFamily: 'IkkaRounded',
                        fontSize: 24),
                  ),
                ),
                TabBar(
                  overlayColor:
                      const MaterialStatePropertyAll(Colors.transparent),
                  controller: _tabController,
                  onTap: (index) {
                    switch (index) {
                      case 0:
                        context.goNamed('manage_exercises', pathParameters: {
                          'idPatient': widget.idPatient.toString()
                        });
                        break;
                      case 1:
                        context.goNamed('exercises_result', pathParameters: {
                          'idPatient': widget.idPatient.toString()
                        });
                        break;
                      // Agrega casos para las otras pestañas...
                    }
                  },
                  tabs: [
                    Tab(
                        child: TextPrimary(
                            text: 'Gestionar ejercicios',
                            color: Theme.of(context).primaryColorDark)),
                    Tab(
                        child: TextPrimary(
                            text: 'Resultados de ejercicios',
                            color: Theme.of(context).primaryColorDark)),
                    Tab(
                        child: TextPrimary(
                            text: 'Resultados TEST RFI',
                            color: Theme.of(context).primaryColorDark)),
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
                Expanded(child: widget.child),
              ],
            );
          }
        });
  }
}
