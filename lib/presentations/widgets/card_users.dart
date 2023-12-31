import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:speak_app_web/config/api.dart';
import 'package:speak_app_web/config/param.dart';
import 'package:speak_app_web/models/patient_model.dart';
import 'package:speak_app_web/providers/patient_provider.dart';

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
  List<PatientModel> _patientsList = [];

  Future? _fetchData;
  late final AnimationController _controller;
  late final TextEditingController _searchController;
  String _searchQuery = '';

  Future fetchData() async {
    _patientsList = [];
    final response = await Api.get(Param.getPatients);

    for (var element in response.data) {
      _patientsList.add(PatientModel.fromJson(element));
    }

    _patientsList.sort((a, b) => a.lastName.compareTo(b.lastName));

    return response;
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this, // Asegúrate de usar "this" como TickerProvider.
      duration: Duration(seconds: 1),
    );

    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);

    super.initState();
    _fetchData = fetchData();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();

    super.dispose();
  }

  void _openDialogRemovePatient(int idPatient) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return RemovePatientDialog(
          idPatient: idPatient,
        ); // Replace MyDialogWidget with your custom dialog content
      },
    );

    if (result != null) {
      setState(() {
        _fetchData = fetchData();
      });
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  List<PatientModel> get _filteredPatientsList {
    if (_searchQuery.isEmpty) {
      return _patientsList;
    } else {
      return _patientsList.where((patient) {
        final fullName = '${patient.firstName} ${patient.lastName}';
        return fullName.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height *
          0.7, // Ocupa todo el ancho de la pantalla
      margin: const EdgeInsets.all(30.0),
      child: Card(
        color: Theme.of(context).cardColor,
        elevation: 10,
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
                    controller: _searchController,
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
                    return Center(
                        child: Container(
                            key: Key('loading'),
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: Column(
                              children: [
                                Spacer(),
                                CircularProgressIndicator(),
                                Spacer(),
                              ],
                            )));
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Container(
                        key: Key('no-results'),
                        height: MediaQuery.of(context).size.height * 0.5,
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
                  } else if ((snapshot.data != null &&
                          (snapshot.data.data).length == 0) ||
                      _filteredPatientsList.isEmpty) {
                    return Center(
                      child: Container(
                        key: Key('box'),
                        height: MediaQuery.of(context).size.height * 0.5,
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
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('')),
                            DataColumn(label: Text('Apellido')),
                            DataColumn(label: Text('Nombre')),
                            DataColumn(label: Text('Edad')),
                            DataColumn(label: Text('Email')),
                            DataColumn(label: Text('')),
                            DataColumn(label: Text('')),
                          ],
                          rows: _filteredPatientsList.map((patient) {
                            return DataRow(cells: [
                              DataCell(
                                patient.imageData == null
                                    ? CircleAvatar(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        foregroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        radius: 18,
                                        child: ClipOval(
                                          child: Icon(Icons.person),
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: 18,
                                        //TODO GET IMAGE FROM USER
                                        backgroundImage:
                                            (patient.imageData as Image).image),
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
                              DataCell(
                                IconButton(
                                  tooltip: "Desvincular paciente",
                                  color: Colors.grey.shade600,
                                  onPressed: () {
                                    _openDialogRemovePatient(patient.idPatient);
                                  },
                                  icon: const Icon(
                                    Icons.person_remove,
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

class RemovePatientDialog extends StatelessWidget {
  final int idPatient;
  RemovePatientDialog({super.key, required this.idPatient});
  @override
  Widget build(BuildContext context) {
    Future<Response> _removePatient(int id) async {
      final result = await context.read<PatientProvider>().removePatient(id);
      return result;
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Desvincular Paciente',
        style: GoogleFonts.nunito(
            fontSize: 24,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w700),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      content: Builder(builder: (context) {
        var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;

        return Container(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 0.3,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Si confirmas la acción, el paciente quedará desvinculado"),
            ],
          ),
        );
      }),
      actions: [
        TextButton(
          onPressed: () async {
            await _removePatient(idPatient);
            Navigator.of(context).pop(true);
            showToast(
              "Paciente desvinculado con éxito",
              textPadding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              position: ToastPosition.bottom,
              backgroundColor: Colors.greenAccent.shade700,
              radius: 8.0,
              textStyle:
                  GoogleFonts.nunito(fontSize: 16.0, color: Colors.white),
              duration: const Duration(seconds: 5),
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.redAccent.shade100;
                }
                return null; // Use the component's default.
              },
            ),
          ),
          child: Text(
            'Desvincular',
            style: TextStyle(color: Colors.orangeAccent),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancelar'),
        ),
      ],
    );
  }
}
