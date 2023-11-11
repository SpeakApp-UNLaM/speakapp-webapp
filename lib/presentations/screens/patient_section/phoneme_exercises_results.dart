import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:speak_app_web/config/api.dart';
import 'package:speak_app_web/config/helpers/play_audio_manager.dart';
import 'package:speak_app_web/config/param.dart';
import 'package:speak_app_web/config/theme/app_theme.dart';
import 'package:speak_app_web/domain/entities/exercise.dart';
import 'package:speak_app_web/models/category_model.dart';
import 'package:speak_app_web/models/exercise_model.dart';
import 'package:speak_app_web/models/task_item_resolved.dart';
import 'package:speak_app_web/models/task_resolved.dart';
import 'package:speak_app_web/presentations/screens/patient_section/show_exercise_result_dialog.dart';
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

    _finishedTaskItems.sort((a, b) => a.idTaskItem.compareTo(b.idTaskItem));

    return response;
  }

  void _openDialogShowExerciseResult(int idTaskItem, TypeExercise typeExercise,
      String? audio, String? resultExpected, String? result) async {
    final _result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ShowExerciseResultDialog(
            idTaskItem: idTaskItem,
            typeExercise: typeExercise,
            audio: audio,
            resultExpected: resultExpected,
            result:
                result); // Replace MyDialogWidget with your custom dialog content
      },
    );

    if (_result) {
      setState(() {
        _fetchTaskData = fetchTaskData(
            _finishedTasks[0].categoriesModel[selectedIndex].idTask as int);
      });
    }
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
                        itemCount: _finishedTasks[0].categoriesModel.length + 1,
                        itemBuilder: (context, index) {
                          if (index != 0) {
                            return ListTile(
                              selectedTileColor: colorList[7],
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              shape: Border(
                                  bottom: index - 1 == selectedIndex
                                      ? BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2)
                                      : BorderSide(
                                          color: Colors.grey.shade200,
                                          width: 1),
                                  top: index - 1 == selectedIndex && index != 1
                                      ? BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2)
                                      : BorderSide(
                                          color: Colors.grey.shade200,
                                          width: 1)),
                              selected: index - 1 == selectedIndex,
                              onTap: () {
                                setState(() {
                                  selectedIndex = index - 1;
                                  _fetchTaskData = fetchTaskData(
                                      _finishedTasks[0]
                                          .categoriesModel[index - 1]
                                          .idTask as int);
                                });
                              },
                              title: Text(
                                Param.categoriesDescriptions[_finishedTasks[0]
                                    .categoriesModel[index - 1]
                                    .category] as String,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.nunito(
                                  color: Theme.of(context).primaryColorDark,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Text(
                                'Nivel ${_finishedTasks[0].categoriesModel[index - 1].level}',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.nunito(
                                  color: Theme.of(context).primaryColorDark,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              trailing: Text(
                                DateFormat('dd/MM/yyyy HH:mm').format(
                                    _finishedTasks[0]
                                        .categoriesModel[index - 1]
                                        .endDate),
                                style: GoogleFonts.nunito(
                                    color: Colors.grey.shade500,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            );
                          } else {
                            return ListTile(
                              selectedTileColor: colorList[7],
                              visualDensity: const VisualDensity(vertical: 4),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              shape: Border(
                                bottom: BorderSide(
                                    color: Colors.grey.shade200, width: 1),
                                top: BorderSide(
                                    color: Colors.grey.shade200, width: 1),
                              ),
                              subtitle: Container(
                                alignment: Alignment.topCenter,
                                child: ButtonStaticPhoneme(
                                  idPhoneme: 1,
                                  namePhoneme: _finishedTasks[0]
                                      .phonemeModel
                                      .namePhoneme,
                                ),
                              ),
                              title: Container(
                                alignment: Alignment
                                    .centerLeft, // Alinea el contenido a la izquierda
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.arrow_back),
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            );
                          }
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
                                      DataColumn(label: Text('Detalle')),
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
                                        DataCell(Container(
                                          // Espaciado vertical
                                          child: RawMaterialButton(
                                            onPressed: () {
                                              _openDialogShowExerciseResult(
                                                  task.idTaskItem,
                                                  task.type,
                                                  task.type ==
                                                          TypeExercise.speak
                                                      ? task.audio
                                                      : "",
                                                  task.type ==
                                                          TypeExercise.speak
                                                      ? task.resultExpected
                                                      : "",
                                                  task.type ==
                                                          TypeExercise.speak
                                                      ? task.result
                                                      : "");
                                            },
                                            elevation: 2.0,
                                            fillColor:
                                                Theme.of(context).primaryColor,
                                            padding: EdgeInsets.all(5.0),
                                            shape: CircleBorder(),
                                            child: Icon(
                                              Icons.search,
                                              size: 20.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )),
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
