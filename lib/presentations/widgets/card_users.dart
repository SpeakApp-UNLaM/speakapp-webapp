import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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

class CardUserState extends State<CardUser> with TickerProviderStateMixin {
  final List<PatientModel> _patientsList = [];
  Future? _fetchData;

  Future fetchData() async {
    final response = await Api.get(Param.getPatients);

    for (var element in response.data) {
      _patientsList.add(PatientModel.fromJson(element));
    }

    return response;
  }

  @override
  void initState() {
    super.initState();
    _fetchData = fetchData();
  }

  @override
  void dispose() {
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 6,
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
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: _patientsList.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    _patientsList[index].firstName +
                                        ' ' + _patientsList[index].lastName,                                   
                                    style: GoogleFonts.nunito(
                                        textStyle: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: FilledButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colorList[
                                          4], // Cambia el color de fondo aquí
                                    ),
                                    onPressed: () {
                                      //TODO GET PATIENT ID
                                      context.goNamed("manage_exercises", pathParameters: {'idPatient': _patientsList[index].idPatient.toString()});
                                    },
                                    child: const Text(
                                      "Ingresar",
                                      style: TextStyle(
                                        fontFamily: 'IkkaRounded',
                                      ),
                                    )),
                              ),
                            ],
                          );
                        });
                  }
                })
          ],
        ),
      ),
    );
  }
}
