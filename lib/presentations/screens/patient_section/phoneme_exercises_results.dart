import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:speak_app_web/config/api.dart';
import 'package:speak_app_web/config/helpers/play_audio_manager.dart';
import 'package:speak_app_web/config/param.dart';
import 'package:speak_app_web/config/theme/app_theme.dart';
import 'package:speak_app_web/domain/entities/exercise.dart';
import 'package:speak_app_web/models/category_model.dart';
import 'package:speak_app_web/models/exercise_model.dart';
import 'package:speak_app_web/models/task_resolved.dart';
import 'package:speak_app_web/presentations/screens/patient_section/view_exercise_result.dart';
import 'package:speak_app_web/presentations/widgets/button_play_audio.dart';
import 'package:speak_app_web/presentations/widgets/list_finished_exercises.dart';

class PhonemeExercisesResults extends StatefulWidget {
  final int idPatient;
  final int idPhoneme;

  const PhonemeExercisesResults(
      {Key? key, required this.idPatient, required this.idPhoneme})
      : super(key: key);
  @override
  _PhonemeExercisesResultsState createState() =>
      _PhonemeExercisesResultsState();
}

class _PhonemeExercisesResultsState extends State<PhonemeExercisesResults>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;

  final List<TaskResolvedModel> _finishedTasks = [];
  List<ExerciseModel> _finishedTaskItems = [];

  late Future _fetchData;
  late Future _fetchTaskData;
  late final AnimationController _controller;

  Future fetchData() async {
    final response = await Api.get(
        "${Param.getResolvedExercises}/${widget.idPatient}/${widget.idPhoneme}");

    _finishedTasks.add(TaskResolvedModel.fromJson(response.data));

    _fetchTaskData = fetchTaskData(
        _finishedTasks[0].categoriesModel[selectedIndex].idTask as int);
    return response;
  }

  Future fetchTaskData(int idTask) async {
    _finishedTaskItems = [];
    final response =
        await Api.get("${Param.getResolvedExercises}/task/$idTask");

    for (var element in response.data) {
      _finishedTaskItems.add(ExerciseModel.fromJson(element));
    }

    return response;
  }

  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // Asegúrate de usar "this" como TickerProvider.
      duration: Duration(seconds: 1),
    );

    _fetchData = fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.height * 0.5),
                child: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data != null && snapshot.data.data.length == 0) {
            return Center(
              child: Container(
                key: Key('box'),
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.5),
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
                        height: 50), // Espacio entre la animación y el texto
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
            return Row(
              children: [
                Column(children: [
                  /*
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
                        style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),*/
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        border: Border(
                          right:
                              BorderSide(color: Colors.grey.shade200, width: 3),
                        ),
                      ),
                      width: 300.0,
                      child: ListView.builder(
                        itemCount: _finishedTasks[0].categoriesModel.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            selectedTileColor: colorList[7],
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            shape: Border(
                                bottom: index == selectedIndex
                                    ? BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 3)
                                    : BorderSide(
                                        color: Colors.grey.shade200, width: 1),
                                top: index == selectedIndex && index != 0
                                    ? BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 3)
                                    : BorderSide(
                                        color: Colors.grey.shade200, width: 1)),
                            selected: index == selectedIndex,
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                _fetchTaskData = fetchTaskData(_finishedTasks[0]
                                    .categoriesModel[index]
                                    .idTask as int);
                              });
                            },
                            leading: ButtonStaticPhoneme(
                                idPhoneme: 1,
                                namePhoneme:
                                    _finishedTasks[0].phonemeModel.namePhoneme),
                            title: Text(
                              Param.categoriesDescriptions[_finishedTasks[0]
                                  .categoriesModel[index]
                                  .category] as String,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunito(
                                color: Theme.of(context).primaryColorDark,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Text(
                              'Nivel ${_finishedTasks[0].categoriesModel[index].level}',
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
                FutureBuilder(
                    future: _fetchTaskData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Expanded(
                            child: Center(child: CircularProgressIndicator()));
                      } else if (snapshot.hasError) {
                        return Expanded(
                          child: Center(
                            child: Container(
                              key: Key('box'),
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
                                        250, // Ajusta el ancho de la animación según tus necesidades
                                    height:
                                        250, // Ajusta el alto de la animación según tus necesidades
                                  ),
                                  const SizedBox(
                                      height:
                                          50), // Espacio entre la animación y el texto
                                  Text(
                                    "Ha ocurrido un error inesperado: 'Error: ${snapshot.error}",
                                    style: GoogleFonts.nunito(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Expanded(
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
                                      percent: _finishedTaskItems
                                              .where((element) =>
                                                  element.result == 'SUCCESS')
                                              .length /
                                          _finishedTaskItems.length,
                                      center: Text(
                                        "${(_finishedTaskItems.where((element) => element.result == 'SUCCESS').length / _finishedTaskItems.length * 100).toString()}%",
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
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
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
                                      percent: _finishedTaskItems
                                              .where((element) =>
                                                  element.result == 'FAILURE')
                                              .length /
                                          _finishedTaskItems.length,
                                      center: Text(
                                        "${(_finishedTaskItems.where((element) => element.result == 'FAILURE').length / _finishedTaskItems.length * 100).toString()}%",
                                        style: const TextStyle(
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
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      progressColor: Colors.redAccent,
                                      backgroundColor: Colors.grey.shade200,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 50),
                                Expanded(
                                    child: SingleChildScrollView(
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
                                      DataColumn(label: Text('Ejercicios')),
                                      DataColumn(label: Text('Tipo Ejercicio')),
                                      DataColumn(label: Text('Resultado')),
                                      DataColumn(label: Text('Audio')),
                                    ],
                                    rows: _finishedTaskItems
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      final index = entry.key;
                                      final task = entry.value;

                                      return DataRow(cells: [
                                        DataCell(Container(
                                          // Espaciado vertical
                                          child: Text(
                                            'Ejercicio ${index + 1}', // Muestra el índice + 1
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.nunito(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        )),
                                        DataCell(Container(
                                          // Espaciado vertical
                                          child: Text(
                                            Param.typeExercisesDescription[
                                                task.type] as String,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.nunito(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        )),
                                        DataCell(Container(
                                          // Espaciado vertical
                                          child: RawMaterialButton(
                                            onPressed: () {},
                                            elevation: 2.0,
                                            fillColor: task.result == 'SUCCESS'
                                                ? colorList[4]
                                                : Colors.redAccent,
                                            padding: EdgeInsets.all(5.0),
                                            shape: CircleBorder(),
                                            child: Icon(
                                              task.result == 'SUCCESS'
                                                  ? Icons.check
                                                  : Icons.close,
                                              size: 20.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )),
                                        DataCell(task.audio != ""
                                            ? Align(
                                              alignment: Alignment.centerLeft,
                                              child: ButtonPlayAudio(
                                                  base64: task.audio as String),
                                            )
                                            : Text('-')),
                                      ]);
                                    }).toList(),
                                  ),
                                ))
                              ],
                            ),
                          ),
                        );
                      }
                    })
              ],
            );
          }
        });
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
