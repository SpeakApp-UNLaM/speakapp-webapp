import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:oktoast/oktoast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:speak_app_web/config/api.dart';
import 'package:speak_app_web/config/helpers/play_audio_manager.dart';
import 'package:speak_app_web/config/param.dart';
import 'package:speak_app_web/config/theme/app_theme.dart';
import 'package:speak_app_web/domain/entities/exercise.dart';
import 'package:speak_app_web/models/category_model.dart';
import 'package:speak_app_web/models/exercise_model.dart';
import 'package:speak_app_web/models/task_item_resolved.dart';
import 'package:speak_app_web/models/task_resolved.dart';
import 'package:speak_app_web/presentations/screens/patient_section/view_exercise_result.dart';
import 'package:speak_app_web/presentations/widgets/button_play_audio.dart';
import 'package:speak_app_web/presentations/widgets/list_finished_exercises.dart';
import 'package:speak_app_web/providers/exercise_provider.dart';

class ShowExerciseResultDialog extends StatefulWidget {
  final int idTaskItem;
  final TypeExercise typeExercise;
  final String? audio;
  final String? resultExpected;
  String? result;

  ShowExerciseResultDialog(
      {Key? key,
      required this.idTaskItem,
      required this.typeExercise,
      this.audio,
      this.resultExpected,
      this.result})
      : super(key: key);

  @override
  _ShowExerciseResultDialogState createState() =>
      _ShowExerciseResultDialogState();
}

class _ShowExerciseResultDialogState extends State<ShowExerciseResultDialog> {
  bool cambiarResultado = false;
  bool existCambio = false;

  String getExerciseDescription(TypeExercise exerciseType) {
    switch (exerciseType) {
      case TypeExercise.speak:
        return 'Consigna: Pronunciar la palabra o imágen visualizada';
      case TypeExercise.multiple_match_selection:
        return 'Consigna: Seleccionar y unir cada audio con la imagen correspondiente';
      case TypeExercise.minimum_pairs_selection:
        return 'Consigna: Seleccionar y unir los pares mínimos';
      case TypeExercise.single_selection_syllable:
        return 'Consigna: Seleccionar la imágen que contiene la sílaba que se escucha en el audio';
      case TypeExercise.single_selection_word:
        return 'Consigna: Seleccionar la imágen que corresponde a la palabra que se escucha en el audio';
      case TypeExercise.multiple_selection:
        return 'Consigna: Seleccionar las imagénes que corresponden al audio';
      case TypeExercise.consonantal_syllable:
        return 'Consigna: Seleccionar la sílaba que contiene la palabra asociada a la imágen';
      case TypeExercise.order_syllable:
        return 'Consigna: Ordenar las sílabas de la palabra';
      case TypeExercise.order_word:
        return 'Consigna: Ordenar las palabras de la frase';
      // Agrega más casos para otros tipos de ejercicio
      default:
        return 'Consigna: Descripción del ejercicio no disponible';
    }
  }

  List<TaskItemResolved> _taskItemsResolved = [];

  late Future _fetchData;

  Future fetchData() async {
    final response = await Api.get(
        "${Param.getResolvedExercises}${Param.getTaskItems}detail/${widget.idTaskItem}");

    for (var element in response.data) {
      _taskItemsResolved.add(TaskItemResolved.fromJson(element));
    }

    return response;
  }

  void initState() {
    super.initState();

    _fetchData = fetchData();
  }

  String quitarDiacriticos(String palabra) {
    var conDiacriticos = 'áéíóúüÁÉÍÓÚÜ'; // Caracteres con diacríticos
    var sinDiacriticos = 'aeiouuAEIOUU'; // Caracteres sin diacríticos

    var result = '';

    for (int i = 0; i < palabra.length; i++) {
      var character = palabra.characters.elementAt(i);
      var index = conDiacriticos.indexOf(character);
      result += index >= 0 ? sinDiacriticos[index] : character;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          children: [
            Text(
              'Detalle de ejercicio realizado',
              style: TextStyle(
                fontFamily: 'IkkaRounded',
                fontSize: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 10),
            Text(
              getExerciseDescription(widget.typeExercise),
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
        content: FutureBuilder(
            future: _fetchData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Center(child: CircularProgressIndicator()));
              } else if (snapshot.hasError) {
                return Center(
                  child: Container(
                    key: Key('box'),
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.5,
                        minWidth: MediaQuery.of(context).size.width * 0.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /*
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
                                  ),*/
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
                );
              } else {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: () {
                    switch (widget.typeExercise) {
                      case TypeExercise.order_syllable:
                      case TypeExercise.multiple_match_selection:
                        return Padding(
                          padding: EdgeInsets.all(30),
                          child: SingleChildScrollView(
                            child: DataTable(
                              border: TableBorder(
                                horizontalInside: BorderSide(
                                  width: 1,
                                  style: BorderStyle.solid,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                              dataRowMinHeight: 40,
                              dataRowMaxHeight: 60,
                              columns: const [
                                DataColumn(
                                    label: Text('Audio/Resultado Esperado')),
                                DataColumn(label: Text('Seleccionado')),
                              ],
                              rows: _taskItemsResolved
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final index = entry.key;
                                final resolvedTask = entry.value;

                                return DataRow(cells: [
                                  DataCell(Container(
                                    // Espaciado vertical
                                    child: Text(
                                      resolvedTask.resultExpected!.replaceFirst(
                                          resolvedTask.resultExpected![0],
                                          resolvedTask.resultExpected![0]
                                              .toUpperCase()), // Muestra el índice + 1
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.nunito(
                                        color: resolvedTask.resultExpected ==
                                                    resolvedTask
                                                        .resultSelected ||
                                                resolvedTask.resultExpected ==
                                                    null
                                            ? colorList[4]
                                            : Colors.redAccent,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )),
                                  DataCell(Container(
                                    // Espaciado vertical
                                    child: Text(
                                      resolvedTask.resultSelected.replaceFirst(
                                          resolvedTask.resultSelected[0],
                                          resolvedTask.resultSelected[0]
                                              .toUpperCase()),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.nunito(
                                        color: resolvedTask.resultExpected ==
                                                resolvedTask.resultSelected
                                            ? colorList[4]
                                            : Colors.redAccent,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )),
                                ]);
                              }).toList(),
                            ),
                          ),
                        );
                      // // Aquí puedes devolver el widget deseado para este caso
                      case TypeExercise.order_syllable:
                        return Padding(
                          padding: EdgeInsets.all(30),
                          child: SingleChildScrollView(
                            child: DataTable(
                              border: TableBorder(
                                horizontalInside: BorderSide(
                                  width: 1,
                                  style: BorderStyle.solid,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                              dataRowMinHeight: 40,
                              dataRowMaxHeight: 60,
                              columns: const [
                                DataColumn(label: Text('Selección')),
                                DataColumn(label: Text('Opciones')),
                              ],
                              rows: _taskItemsResolved
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final index = entry.key;
                                final resolvedTask = entry.value;

                                return DataRow(cells: [
                                  DataCell(Container(
                                    // Espaciado vertical
                                    child: resolvedTask.resultExpected != null
                                        ? Icon(Icons.arrow_forward,
                                            color: resolvedTask.resultSelected
                                                    .contains(resolvedTask
                                                            .resultExpected ??
                                                        '-')
                                                ? colorList[4]
                                                : Colors.redAccent)
                                        : Text(
                                            "", // Muestra el índice + 1
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
                                      resolvedTask.resultSelected.replaceFirst(
                                          resolvedTask.resultSelected[0],
                                          resolvedTask.resultSelected[0]
                                              .toUpperCase()),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.nunito(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )),
                                ]);
                              }).toList(),
                            ),
                          ),
                        );
                      case TypeExercise.single_selection_syllable:
                      case TypeExercise.single_selection_word:
                      case TypeExercise.multiple_selection:
                      case TypeExercise.minimum_pairs_selection:
                        return Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Palabra del audio: ",
                                    style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    (_taskItemsResolved
                                            .firstWhere((objeto) =>
                                                objeto.resultExpected != "-" &&
                                                objeto.resultExpected != null)
                                            .resultExpected as String)
                                        .toUpperCase(),
                                    style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60.0),
                                child: SingleChildScrollView(
                                  child: DataTable(
                                    border: TableBorder(
                                      horizontalInside: BorderSide(
                                        width: 1,
                                        style: BorderStyle.solid,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                    ),
                                    dataRowMinHeight: 40,
                                    dataRowMaxHeight: 60,
                                    columns: const [
                                      DataColumn(
                                          label: Text(
                                        '',
                                        textAlign: TextAlign.right,
                                      )),
                                      DataColumn(label: Text('Opciones')),
                                    ],
                                    rows: _taskItemsResolved
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      final index = entry.key;
                                      final resolvedTask = entry.value;

                                      return DataRow(cells: [
                                        DataCell(Container(
                                          // Espaciado vertical
                                          child: resolvedTask.resultExpected !=
                                                  null
                                              ? Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Icon(
                                                      Icons.arrow_forward,
                                                      color: Theme.of(context)
                                                          .primaryColorDark),
                                                )
                                              : const Text(""),
                                        )),
                                        DataCell(Container(
                                          // Espaciado vertical
                                          child: Text(
                                            resolvedTask.resultSelected
                                                .replaceFirst(
                                                    resolvedTask
                                                        .resultSelected[0],
                                                    resolvedTask
                                                        .resultSelected[0]
                                                        .toUpperCase()),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.nunito(
                                              color: resolvedTask
                                                              .resultExpected !=
                                                          null &&
                                                      quitarDiacriticos(resolvedTask
                                                              .resultSelected)
                                                          .contains(quitarDiacriticos(resolvedTask
                                                                  .resultExpected
                                                              as String))
                                                  ? colorList[4]
                                                  : (resolvedTask
                                                              .resultExpected !=
                                                          null
                                                      ? Colors.redAccent
                                                      : Theme.of(context)
                                                          .primaryColorDark),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        )),
                                      ]);
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      case TypeExercise.speak:
                        return Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.resultExpected?.split(' ').length ==
                                            1
                                        ? "Palabra del audio: "
                                        : "Frase del audio: ",
                                    style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    (widget.resultExpected as String)
                                        .toUpperCase(),
                                    style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60.0),
                                child: Center(
                                    child: Align(
                                  alignment: Alignment.center,
                                  child: ButtonPlayAudio(
                                      base64: widget.audio as String),
                                )),
                              ),
                              const SizedBox(height: 10),
                              Center(
                                child: RawMaterialButton(
                                  onPressed: () {},
                                  elevation: 2.0,
                                  fillColor: widget.result == 'SUCCESS'
                                      ? colorList[4]
                                      : Colors.redAccent,
                                  padding: EdgeInsets.all(5.0),
                                  shape: CircleBorder(),
                                  child: Icon(
                                    widget.result == 'SUCCESS'
                                        ? Icons.check
                                        : Icons.close,
                                    size: 20.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "¿Desea cambiar el resultado?",
                                    style: GoogleFonts.nunito(
                                        fontSize: 14,
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                  TextButton(
                                      onPressed: () async {
                                        setState(() {
                                          cambiarResultado = !cambiarResultado;
                                        });

                                        if (cambiarResultado == false) {
                                          String nuevoResult =
                                              widget.result == 'SUCCESS'
                                                  ? 'FAILURE'
                                                  : 'SUCCESS';
                                          context
                                              .read<ExerciseProvider>()
                                              .updateSpeakExercise(
                                                  widget.idTaskItem,
                                                  nuevoResult)
                                              .then((value) {
                                            //context.read<ReportProvider>().setPhonemeId = int.parse(widget.idPhoneme);
                                            showToast(
                                              "Estado cambiado exitosamente",
                                              textPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 10),
                                              position: ToastPosition.bottom,
                                              backgroundColor:
                                                  Colors.greenAccent.shade700,
                                              radius: 8.0,
                                              textStyle: GoogleFonts.nunito(
                                                  fontSize: 16.0,
                                                  color: Colors.white),
                                              duration:
                                                  const Duration(seconds: 5),
                                            );
                                            setState(() {
                                              widget.result = nuevoResult;
                                              existCambio = true;
                                            });
                                          },
                                                  onError: (error) =>
                                                      Param.showSuccessToast(
                                                          "Error al cambiar estado $error"));
                                        }
                                      },
                                      child: Text(
                                        cambiarResultado
                                            ? 'Presione para confirmar'
                                            : 'Cambiar Resultado',
                                        style: GoogleFonts.nunito(
                                            color: cambiarResultado
                                                ? colorList[4]
                                                : Theme.of(context)
                                                    .primaryColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900),
                                      ))
                                ],
                              ),
                            ],
                          ),
                        );
                      default:
                        return Padding(
                          padding: EdgeInsets.all(30),
                          child: SingleChildScrollView(
                            child: DataTable(
                              border: TableBorder(
                                horizontalInside: BorderSide(
                                  width: 1,
                                  style: BorderStyle.solid,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                              dataRowMinHeight: 40,
                              dataRowMaxHeight: 60,
                              columns: const [
                                DataColumn(
                                    label: Text('Audio/Resultado Esperado')),
                                DataColumn(label: Text('Seleccionado')),
                              ],
                              rows: _taskItemsResolved
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final index = entry.key;
                                final resolvedTask = entry.value;

                                return DataRow(cells: [
                                  DataCell(Container(
                                    // Espaciado vertical
                                    child: Text(
                                      resolvedTask.resultExpected != null
                                          ? resolvedTask.resultExpected!
                                              .replaceFirst(
                                                  resolvedTask
                                                      .resultExpected![0],
                                                  resolvedTask
                                                      .resultExpected![0]
                                                      .toUpperCase())
                                          : "-", // Muestra el índice + 1
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.nunito(
                                        color: resolvedTask.resultExpected ==
                                                resolvedTask.resultSelected
                                            ? colorList[4]
                                            : Colors.redAccent,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )),
                                  DataCell(Container(
                                    // Espaciado vertical
                                    child: Text(
                                      resolvedTask.resultSelected.replaceFirst(
                                          resolvedTask.resultSelected[0],
                                          resolvedTask.resultSelected[0]
                                              .toUpperCase()),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.nunito(
                                        color: resolvedTask.resultExpected ==
                                                resolvedTask.resultSelected
                                            ? colorList[4]
                                            : Colors.redAccent,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ); // Otra opción para el caso por defecto
                    }
                  }(),
                );
              }
            }),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(existCambio); // Close the dialog
            },
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
