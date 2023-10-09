import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:speak_app_web/config/param.dart';
import 'package:speak_app_web/config/theme/app_theme.dart';
import 'package:speak_app_web/domain/entities/exercise.dart';
import 'package:speak_app_web/models/category_model.dart';
import 'package:speak_app_web/models/exercise_model.dart';
import 'package:speak_app_web/presentations/screens/patient_section/view_exercise_result.dart';
import 'package:speak_app_web/presentations/widgets/list_finished_exercises.dart';

class PhonemeExercisesResults extends StatefulWidget {
  final List<CategoryModel> exercises;
  final String namePhoneme;

  const PhonemeExercisesResults(
      {Key? key, required this.namePhoneme, required this.exercises})
      : super(key: key);
  @override
  _PhonemeExercisesResultsState createState() =>
      _PhonemeExercisesResultsState();
}

class _PhonemeExercisesResultsState extends State<PhonemeExercisesResults> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey.shade200, width: 3),
                ),
              ),
              width: 300.0,
              child: ListView.builder(
                itemCount: widget.exercises.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    shape: Border(
                        bottom: index == selectedIndex
                            ? BorderSide(
                                color: Theme.of(context).primaryColor, width: 2)
                            : BorderSide(color: Colors.grey.shade200, width: 1),
                        top: index == selectedIndex
                            ? BorderSide(
                                color: Theme.of(context).primaryColor, width: 2)
                            : BorderSide(
                                color: Colors.grey.shade200, width: 1)),
                    selected: index == selectedIndex,
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    leading: ButtonStaticPhoneme(
                        idPhoneme: 1, namePhoneme: widget.namePhoneme),
                    title: Text(
                      Param.categoriesDescriptions[
                          widget.exercises[index].category] as String,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      'Nivel ${widget.exercises[index].level.toString()}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ]),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
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
                          color: colorList[4],
                        ),
                      ),
                      footer: Text(
                        "Correctos",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          fontFamily: 'IkkaRounded',
                          color: colorList[4],
                        ),
                      ),
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
                          color: Colors.redAccent,
                        ),
                      ),
                      footer: const Text(
                        "Incorrectos",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          fontFamily: 'IkkaRounded',
                          color: Colors.redAccent,
                        ),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Colors.redAccent,
                      backgroundColor: Colors.grey.shade200,
                    ),
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
                  rows: (widget.exercises[selectedIndex].exercisesResult
                          as List<ExerciseModel>)
                      .map((task) {
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
                          color: Colors.green,
                          size: 32,
                        ),
                      )),
                    ]);
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


/*
class PhonemeExercisesResults extends StatelessWidget {
  final List<CategoryModel> exercisesResult;
  final String namePhoneme;

  const PhonemeExercisesResults(
      {super.key, required this.exercisesResult, required this.namePhoneme});

  @override
  Widget build(BuildContext context) {
    
    return Expanded(
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 23, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                  color: Theme.of(context).primaryColor,
                ),
                Text(
                  'Volver',
                  style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: Theme.of(context).primaryColor),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Theme(
                      data:
                          Theme.of(context).copyWith(dividerColor: Colors.red),
                      child: DataTable(
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
                          DataColumn(label: Text('Fonema')),
                          DataColumn(label: Text('Nivel')),
                          DataColumn(label: Text('Categoría')),
                          DataColumn(label: Text('Acción')),
                        ],
                        rows: exercisesResult.map((task) {
                          return DataRow(cells: [
                            DataCell(Container(
                              // Espaciado vertical
                              child: ButtonStaticPhoneme(
                                idPhoneme: 1,
                                namePhoneme: this.namePhoneme,
                              ),
                            )),
                            DataCell(Container(
                              // Espaciado vertical
                              child: Text(
                                task.level.toString(),
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
                                Param.categoriesDescriptions[task.category]
                                    as String,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                  color: Theme.of(context).primaryColorDark,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )),
                            DataCell(Container(
                              child: FilledButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorList[4],
                                ),
                                onPressed: () {
                                 Navigator.push(
                                context,
                                MaterialPageRoute(
                                    maintainState: true,
                                    builder: (context) =>
                                        ViewExerciseResult(
                                            exercisesResult:
                                                task.exercisesResult as List<ExerciseModel>,
                                            namePhoneme: namePhoneme)));
                                },
                                child: const Text(
                                  "Ver resultado",
                                  style: TextStyle(
                                    fontFamily: 'IkkaRounded',
                                  ),
                                ),
                              ),
                            )),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

*/
