import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
    with SingleTickerProviderStateMixin {
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
    _tabController = TabController(initialIndex: 0, length: 4, vsync: this);
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
                          width: 450,
                          child: Card(
                            elevation: 5, // Agregar sombra al card
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 60),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Datos del paciente",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 22,
                                      fontFamily: 'IkkaRounded',
                                      fontWeight: FontWeight
                                          .bold, // Hacer el título en negrita
                                    ),
                                  ),
                                  const SizedBox(height: 50),
                                  patient.imageData == null
                                      ? PhysicalModel(
                                          color: Theme.of(context).primaryColor,
                                          shadowColor:
                                              Theme.of(context).primaryColor,
                                          elevation: 12,
                                          shape: BoxShape.circle,
                                          child: CircleAvatar(
                                            radius: 60,
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            foregroundColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            child: const ClipOval(
                                              child:
                                                  Icon(Icons.person, size: 80),
                                            ),
                                          ),
                                        )
                                      : PhysicalModel(
                                          color: Theme.of(context).primaryColor,
                                          shape: BoxShape.circle,
                                          shadowColor:
                                              Theme.of(context).primaryColor,
                                          elevation: 12,
                                          child: CircleAvatar(
                                              radius: 60,
                                              //TODO GET IMAGE FROM USER
                                              backgroundImage:
                                                  (patient.imageData as Image)
                                                      .image),
                                        ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "${patient.lastName} ${patient.firstName}",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize:
                                          18, // Aumentar el tamaño de la fuente del nombre
                                      fontFamily: 'IkkaRounded',
                                      fontWeight: FontWeight
                                          .bold, // Hacer el nombre en negrita
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Card(
                                    surfaceTintColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    elevation: 3, // Agregar sombra al sub-card
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            "Información del paciente",
                                            style: GoogleFonts.nunito(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Sexo: ${patient.gender != null ? (patient.gender == 'M' ? 'Masculino' : 'Femenino') : 'No especificado'}",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight
                                                      .w500, // Reducir el peso de la fuente
                                                ),
                                              ),
                                              Text(
                                                "Edad: ${patient.age}",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 15),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Email: ${patient.email}",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                "Sesiones: 15",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 15),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Tutor: ${patient.tutor}",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                "Fecha Alta: ${DateFormat('dd/MM/yyyy')
                                          .format(
                                              (DateTime.parse(patient.createdAt as String))
                                                  .subtract(Duration(hours: 3)))
                                          .toString()} ",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 15),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Tel: ${patient.phone}",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                "DNI: 47888233",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 40),
                  child: DefaultTabController(
                    length: 4,
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
                            case 2:
                              context.goNamed('rfi_result', pathParameters: {
                                'idPatient': widget.idPatient.toString()
                              });
                              break;
                            case 3:
                              context.goNamed('reports', pathParameters: {
                                'idPatient': widget.idPatient.toString()
                              });
                              break;
                            // Agrega casos para las otras pestañas...
                          }
                        },
                        tabs: [
                          Tab(
                              child: Text('Gestionar Prácticas',
                                  style: GoogleFonts.nunito(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800))),
                          Tab(
                              child: Text('Resultados de Prácticas',
                                  style: GoogleFonts.nunito(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800))),
                          Tab(
                              child: Text('Resultados de TEST RFI',
                                  style: GoogleFonts.nunito(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800))),
                          Tab(
                              child: Text(
                            'Informes',
                            style: GoogleFonts.nunito(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w800),
                          )),
                        ],
                      ),
                      Expanded(child: widget.child),
                    ]),
                  ),
                )),
              ],
            );
          }
        });
  }
}
