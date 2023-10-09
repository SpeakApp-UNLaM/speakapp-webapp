import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:speak_app_web/config/param.dart';
import 'package:speak_app_web/config/theme/app_theme.dart';
import 'package:speak_app_web/models/exercise_model.dart';
import 'package:speak_app_web/presentations/widgets/list_finished_exercises.dart';

class ViewExerciseResult extends StatelessWidget {
  final List<ExerciseModel> exercisesResult;
  final String namePhoneme;

  const ViewExerciseResult(
      {super.key, required this.exercisesResult, required this.namePhoneme});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding:
                EdgeInsetsDirectional.symmetric(horizontal: 23, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centra verticalmente
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularPercentIndicator(
                      radius: 40.0,
                      lineWidth: 8.0,
                      animation: true,
                      percent: 0.7,
                      center: Text(
                        "70.0%",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                            fontFamily: 'IkkaRounded',
                            color: colorList[4]),
                      ),
                      footer: Text("Correctos",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              fontFamily: 'IkkaRounded',
                              color: colorList[4])),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: colorList[4],
                      backgroundColor: Colors.grey.shade200,
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    CircularPercentIndicator(
                      radius: 40.0,
                      lineWidth: 8.0,
                      animation: true,
                      percent: 0.3,
                      center: const Text(
                        "30.0%",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                            fontFamily: 'IkkaRounded',
                            color: Colors.redAccent),
                      ),
                      footer: const Text("Incorrectos",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              fontFamily: 'IkkaRounded',
                              color: Colors.redAccent)),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Colors.redAccent,
                      backgroundColor: Colors.grey.shade200,
                    )
                  ],
                ),
                SizedBox(height: 50),
                DataTable(
                  border: TableBorder(
                    horizontalInside: BorderSide(
                      width: 3,
                      style: BorderStyle.solid,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  dataRowMinHeight: 60,
                  dataRowMaxHeight: 100,
                  columns: const [
                    DataColumn(label: Text('Ejercicios')),
                    DataColumn(label: Text('Tipo Ejercicio')),
                    DataColumn(label: Text('Resultado')),
                  ],
                  rows: exercisesResult.map((task) {
                    return DataRow(cells: [
                      DataCell(Container(
                        // Espaciado vertical
                        child: Text(
                          'Ejercicio 1',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )),
                      DataCell(Container(
                        // Espaciado vertical
                        child: Text(
                          Param.typeExercisesDescription[task.type] as String,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )),
                      DataCell(Container(
                          // Espaciado vertical
                          child: Icon(
                        Icons.check,
                        color: Colors
                            .green, // Cambia el color según tus preferencias
                        size: 32, // Cambia el tamaño según tus preferencias
                      ))),
                    ]);
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
