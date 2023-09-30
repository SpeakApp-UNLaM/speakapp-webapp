import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
            return Row(
              children: [
                Expanded(
                    flex: 0,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 400,
                        child: Card(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 30),
                              child: Column(
                                children: [
                                  Text(
                                    "Datos del paciente",
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColor,
                                        fontSize: 22,
                                        fontFamily: 'IkkaRounded'),
                                  ),
                                  const SizedBox(height: 50),
                                  CircleAvatar(
                                    minRadius: 50,
                                    backgroundColor: Colors
                                        .transparent, // Establecer el fondo transparente
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: ClipOval(
                                        child: Image.network(
                                          "https://img.freepik.com/foto-gratis/nino-sonriente-aislado-rosa_23-2148984798.jpg?w=1380&t=st=1696089946~exp=1696090546~hmac=4035c3677d316811640bb086080f9a56d805c927a829156891b8bcfe83f28a28",
                                          width: 100, // Ancho de la imagen
                                          height: 100, // Alto de la imagen
                                          fit: BoxFit
                                              .cover, // Ajusta la imagen al círculo
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "${patient.lastName} ${patient.firstName} ",
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColor,
                                        fontSize: 16,
                                        fontFamily: 'IkkaRounded'),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "Sexo: Masculino ",
                                        style: GoogleFonts.nunito(
                                            color: Theme.of(context)
                                                .primaryColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(width: 20),
                                      Text(
                                        "Edad: ${patient.age}",
                                        style: GoogleFonts.nunito(
                                            color: Theme.of(context)
                                                .primaryColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "Email: ${patient.email} ",
                                        style: GoogleFonts.nunito(
                                            color: Theme.of(context)
                                                .primaryColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(width: 20),
                                      Text(
                                        "Sesiones: 15 ",
                                        style: GoogleFonts.nunito(
                                            color: Theme.of(context)
                                                .primaryColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "Email: ${patient.email} ",
                                        style: GoogleFonts.nunito(
                                            color: Theme.of(context)
                                                .primaryColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(width: 20),
                                      Text(
                                        "Sesiones: 15 ",
                                        style: GoogleFonts.nunito(
                                            color: Theme.of(context)
                                                .primaryColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                        ),
                      ),
                    )),
                Expanded(
                    child: DefaultTabController(
                  length: 5,
                  child: Column(children: [
                    TabBar(
                      overlayColor:
                          const MaterialStatePropertyAll(Colors.transparent),
                      controller: _tabController,
                      onTap: (index) {
                        switch (index) {
                          case 0:
                            context.goNamed('manage_exercises',
                                pathParameters: {
                                  'idPatient': widget.idPatient.toString()
                                });
                            break;
                          case 1:
                            context.goNamed('exercises_result',
                                pathParameters: {
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
                                color: Theme.of(context).primaryColor)),
                        Tab(
                            child: TextPrimary(
                                text: 'Resultados de ejercicios',
                                color: Theme.of(context).primaryColor)),
                        Tab(
                            child: TextPrimary(
                                text: 'Resultados TEST RFI',
                                color: Theme.of(context).primaryColor)),
                        Tab(
                            child: TextPrimary(
                                text: 'Datos del paciente',
                                color: Theme.of(context).primaryColor)),
                        Tab(
                            child: TextPrimary(
                                text: 'Pacientes',
                                color: Theme.of(context).primaryColor)),
                      ],
                    ),
                    Expanded(child: widget.child),
                  ]),
                )),
              ],
            );
          }
        });
  }
}
