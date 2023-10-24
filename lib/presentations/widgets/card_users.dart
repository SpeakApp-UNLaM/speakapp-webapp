import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:speak_app_web/config/api.dart';
import 'package:speak_app_web/config/param.dart';
import 'package:speak_app_web/models/patient_model.dart';

import '../../config/theme/app_theme.dart';

class CardUser extends StatefulWidget {
  const CardUser({
    super.key,
  });

  @override
  CardUserState createState() => CardUserState();
}

class CardUserState extends State<CardUser>
    with SingleTickerProviderStateMixin {
  final List<PatientModel> _patientsList = [];
  Future? _fetchData;
  late final AnimationController _controller;

  Future fetchData() async {
    final response = await Api.get(Param.getPatients);

    for (var element in response.data) {
      _patientsList.add(PatientModel.fromJson(element));
    }

    return response;
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this, // Asegúrate de usar "this" como TickerProvider.
      duration: Duration(seconds: 1),
    );

    super.initState();
    _fetchData = fetchData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context)
          .size
          .width, // Ocupa todo el ancho de la pantalla
      margin: const EdgeInsets.all(30.0),
      child: Card(
        color: Theme.of(context).cardColor,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: const EdgeInsets.all(23),
              child: Center(
                child: SearchBar(
                    side: MaterialStateProperty.all(
                        BorderSide(color: Theme.of(context).primaryColor)),
                    hintText: 'Buscar paciente',
                    hintStyle: MaterialStateProperty.all(
                        const TextStyle(color: Colors.grey)),
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                      maxHeight: 100,
                    ),
                    trailing: [
                      IconButton(
                        icon: Icon(Icons.search,
                            color: Theme.of(context).primaryColor),
                        onPressed: () {},
                      ),
                    ],
                    backgroundColor: MaterialStateProperty.all(Colors.white)),
              ),
            ),
            const SizedBox(height: 10.0),
            FutureBuilder(
                future: _fetchData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Container(
                        key: Key('no-results'),
                        constraints: BoxConstraints(
                            minHeight:
                                MediaQuery.of(context).size.height * 0.5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/animations/NoResults.json',
                              controller: _controller,
                              onLoaded: (composition) {
                                _controller
                                  ..duration = composition.duration
                                  ..repeat();
                              },
                              width:
                                  200, // Ajusta el ancho de la animación según tus necesidades
                              height:
                                  200, // Ajusta el alto de la animación según tus necesidades
                            ),
                            const SizedBox(
                                height:
                                    50), // Espacio entre la animación y el texto
                            Text(
                              "Ha ocurrido un error inesperado: ${snapshot.error}",
                              style: GoogleFonts.nunito(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColorDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (snapshot.data != null &&
                      (snapshot.data.data).length == 0) {
                    return Center(
                      child: Container(
                        key: Key('box'),
                        constraints: BoxConstraints(
                            minHeight:
                                MediaQuery.of(context).size.height * 0.5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/animations/NoResultsBox.json',
                              controller: _controller,
                              onLoaded: (composition) {
                                _controller
                                  ..duration = composition.duration
                                  ..repeat();
                              },
                              width:
                                  250, // Ajusta el ancho de la animación según tus necesidades
                              height:
                                  250, // Ajusta el alto de la animación según tus necesidades
                            ),
                            const SizedBox(
                                height:
                                    50), // Espacio entre la animación y el texto
                            Text(
                              "No se encontraron pacientes",
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColorDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 400,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Nombre')),
                            DataColumn(label: Text('Apellido')),
                            DataColumn(label: Text('Edad')),
                            DataColumn(label: Text('Email')),
                            DataColumn(label: Text('')),
                          ],
                          rows: _patientsList.map((patient) {
                            return DataRow(cells: [
                              DataCell(
                                Text(
                                  '${patient.firstName}',
                                  style: GoogleFonts.nunito(
                                    textStyle: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${patient.lastName}',
                                  style: GoogleFonts.nunito(
                                    textStyle: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${patient.age}',
                                  style: GoogleFonts.nunito(
                                    textStyle: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${patient.email}',
                                  style: GoogleFonts.nunito(
                                    textStyle: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                FilledButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colorList[4],
                                  ),
                                  onPressed: () {
                                    // TODO: GET PATIENT ID
                                    context.goNamed("manage_exercises",
                                        pathParameters: {
                                          'idPatient':
                                              patient.idPatient.toString(),
                                        });
                                  },
                                  child: const Text(
                                    "Ingresar",
                                    style: TextStyle(
                                      fontFamily: 'IkkaRounded',
                                    ),
                                  ),
                                ),
                              ),
                            ]);
                          }).toList(),
                        ),
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
