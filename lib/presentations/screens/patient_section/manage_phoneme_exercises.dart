import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:speak_app_web/config/api.dart';
import 'package:speak_app_web/config/param.dart';
import 'package:speak_app_web/config/theme/app_theme.dart';
import 'package:speak_app_web/domain/entities/phoneme.dart';
import 'package:speak_app_web/domain/entities/task.dart';
import 'package:speak_app_web/models/patient_model.dart';
import 'package:speak_app_web/models/phoneme_model.dart';
import 'package:speak_app_web/models/task_model.dart';
import 'package:speak_app_web/providers/exercise_provider.dart';
import 'package:speak_app_web/shared/custom_dropdown_button.dart';

class ManagePhonemeExercises extends StatefulWidget {
  final int idPatient;
  final String idPhoneme;
  const ManagePhonemeExercises({
    super.key,
    required this.idPatient,
    required this.idPhoneme,
  });

  @override
  ManagePhonemeExercisesState createState() => ManagePhonemeExercisesState();
}

class ManagePhonemeExercisesState extends State<ManagePhonemeExercises>
    with TickerProviderStateMixin {
  Future<List<Task>>? _fetchData;
  late Phoneme phonemeData;
  Future<List<Task>> fetchData() async {
    // obtenemos phoneme
    final responsePhoneme =
        await Api.get("${Param.getPhonemes}/${widget.idPhoneme}");

    if (responsePhoneme.data.length != 0) {
      Task task = TaskModel.fromJson(responsePhoneme.data).toTaskEntity();
      phonemeData = task.phoneme;
    }

    final response = await Api.get(
        "${Param.getTasksByPhoneme}/${widget.idPatient}/${widget.idPhoneme}");

    List<Task> lst = [];

    if (response.data.length != 0) {
      lst.add(TaskModel.fromJson(response.data).toTaskEntity());
    }

    return lst;
  }

  @override
  void initState() {
    super.initState();
    context.read<ExerciseProvider>().refreshData();
    context.read<ExerciseProvider>().setPhonemeId = int.parse(widget.idPhoneme);
    _fetchData = fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _openDialogAddExercise() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddExerciseDialog(
          idPatient: widget.idPatient,
          namePhoneme: phonemeData.namePhoneme,
        ); // Replace MyDialogWidget with your custom dialog content
      },
    );

    if (result != null) {
      await _addExercise(widget.idPatient).then((value) {
        showToast(
          " Ejercicio agregado exitosamente",
          textPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          position: ToastPosition.bottom,
          backgroundColor: Colors.greenAccent.shade700,
          radius: 8.0,
          textStyle: GoogleFonts.nunito(fontSize: 16.0, color: Colors.white),
          duration: const Duration(seconds: 5),
        );

        context.read<ExerciseProvider>().setPhonemeId =
            int.parse(widget.idPhoneme);
        setState(() {
          _fetchData = fetchData();
        });
      },
          onError: (error) =>
              Param.showSuccessToast("Error al agregar ejercicio $error"));
    }
  }

  void _openDialogRemoveExercise(int idTask) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return RemoveExerciseDialog(
          idTask: idTask,
        ); // Replace MyDialogWidget with your custom dialog content
      },
    );

    if (result != null) {
      setState(() {
        _fetchData = fetchData();
      });
    }
  }

  Future<Response> _addExercise(idPatient) async {
    final result =
        await context.read<ExerciseProvider>().sendExercise(idPatient);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final levels = ['Inicial', 'Intermedio', 'Final'];

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.pop(context); // Cierra la página actual y vuelve atrás
            },
          ),
        ),
        body: OKToast(
            child: Container(
          width: MediaQuery.of(context)
              .size
              .width, // Ocupa todo el ancho de la pantalla
          margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 30),
          child: Stack(
            alignment: Alignment.topRight,
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
                    style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    elevation: 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(36.0),
                          child: FutureBuilder<List<Task>>(
                            future: _fetchData,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.7,
                                    child: Center(
                                        child: CircularProgressIndicator()));
                              } else if (snapshot.hasError) {
                                return Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                        child:
                                            Text('Error: ${snapshot.error}')));
                              } else {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        "Listado de Ejercicios Asignados - Fonema: ${phonemeData.namePhoneme}",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontFamily: 'IkkaRounded',
                                            fontSize: 18),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      child: DataTable(
                                        columns: const [
                                          DataColumn(label: Text('Categoria')),
                                          DataColumn(label: Text('Nivel')),
                                          DataColumn(label: Text('')),
                                        ],
                                        rows: snapshot.data![0].categories
                                            .map((ex) {
                                          return DataRow(cells: [
                                            DataCell(
                                              Text(
                                                Param.categoriesDescriptions[
                                                    ex.category] as String,
                                                style: GoogleFonts.nunito(
                                                  textStyle: TextStyle(
                                                    color: Colors.grey.shade700,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                levels[ex.level != 0
                                                    ? ex.level - 1
                                                    : 1],
                                                style: GoogleFonts.nunito(
                                                  textStyle: TextStyle(
                                                    color: Colors.grey.shade700,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: FilledButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors
                                                        .redAccent, // Cambia el color de fondo aquí
                                                  ),
                                                  onPressed: () {
                                                    _openDialogRemoveExercise(
                                                        ex.idTask as int);
                                                  },
                                                  child: const Text(
                                                    "Eliminar",
                                                    style: TextStyle(
                                                      fontFamily: 'IkkaRounded',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]);
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FloatingActionButton(
                  onPressed: _openDialogAddExercise,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        )));
  }
}

class RemoveExerciseDialog extends StatelessWidget {
  final int idTask;
  RemoveExerciseDialog({super.key, required this.idTask});
  @override
  Widget build(BuildContext context) {
    Future<Response> _removeExercise(int idTask) async {
      final result =
          await context.read<ExerciseProvider>().removeExercise(idTask);
      return result;
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Eliminar Ejercicio',
        style: TextStyle(
            fontFamily: 'IkkaRounded',
            fontSize: 24,
            color: Theme.of(context).primaryColor),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 20),
      content: Builder(builder: (context) {
        var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;

        return Container(
          height: height - 800,
          width: width - 1300,
          child: const Column(
            children: [
              Text(
                  "Si confirmas la acción, el ejercicio asignado quedará eliminado permanentemente"),
            ],
          ),
        );
      }),
      actions: [
        TextButton(
          onPressed: () async {
            await _removeExercise(idTask);
            Navigator.of(context).pop(true);
            showToast(
              "Ejercicio eliminado con éxito",
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
            'Eliminar',
            style: TextStyle(color: Colors.redAccent),
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

class AddExerciseDialog extends StatelessWidget {
  final int idPatient;
  final String namePhoneme;

  AddExerciseDialog(
      {super.key, required this.idPatient, required this.namePhoneme});
  @override
  Widget build(BuildContext context) {
    final levels = ['Inicial', 'Intermedio', 'Final'];
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Agregar Ejercicio',
        style: TextStyle(
            fontFamily: 'IkkaRounded',
            fontSize: 24,
            color: Theme.of(context).primaryColor),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      content: Builder(builder: (context) {
        var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;

        return Container(
          height: height - 400,
          width: width - 800,
          child: Column(
            children: [
              const SizedBox(
                height: 50,
                width: 500,
              ),
              CustomDropdownButton(
                options: [namePhoneme],
                label: 'Fonéma',
                onChanged: null,
                errorMessage: null,
                value: namePhoneme,
              ),
              const SizedBox(height: 30),
              CustomDropdownButton(
                options: const ['Inicial', 'Intermedio', 'Final'],
                label: 'Nivel',
                onChanged: (value) {
                  context.read<ExerciseProvider>().setLevel =
                      levels.indexOf(value as String) + 1;
                },
                errorMessage: null,
              ),
              const SizedBox(height: 30),
              CustomDropdownButton(
                options: const ['Silabas', 'Palabras', 'Frases'],
                label: 'Categoria',
                onChanged: (value) {
                  context.read<ExerciseProvider>().setCategories = [
                    Param.getCategoryFromDescription(value as String)
                  ];
                },
                errorMessage: null,
              ),
            ],
          ),
        );
      }),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop(true);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return colorList[3];
                }
                return null; // Use the component's default.
              },
            ),
          ),
          child: Text(
            'Guardar',
            style: TextStyle(color: colorList[4]),
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
