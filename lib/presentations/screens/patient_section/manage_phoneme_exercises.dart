import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final responsePhoneme = await Api.get("${Param.getPhonemes}/${widget.idPhoneme}");

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

  void _openDialogAddExercise() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddExerciseDialog(
          idPatient: widget.idPatient,
          namePhoneme: phonemeData.namePhoneme,
        ); // Replace MyDialogWidget with your custom dialog content
      },
    );
  }

  void _openDialogRemoveExercise(int idTask) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RemoveExerciseDialog(
          idTask: idTask,
        ); // Replace MyDialogWidget with your custom dialog content
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context)
          .size
          .width, // Ocupa todo el ancho de la pantalla
      margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 30),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Card(
            color: Theme.of(context).scaffoldBackgroundColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 6,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: FutureBuilder<List<Task>>(
                    future: _fetchData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "Listado de Ejercicios Asignados - Fonema: ${phonemeData.namePhoneme}",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontFamily: 'IkkaRounded',
                                    fontSize: 18),
                              ),
                            ),
                            SingleChildScrollView(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: DataTable(
                                  columns: const [
                                    DataColumn(label: Text('Categoria')),
                                    DataColumn(label: Text('Nivel')),
                                    DataColumn(label: Text('')),
                                  ],
                                  rows: snapshot.data![0].categories.map((ex) {
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
                                          'Nivel 1',
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
                                          padding: const EdgeInsets.all(10.0),
                                          child: FilledButton(
                                            style: ElevatedButton.styleFrom(
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
                            )
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton(
              onPressed: _openDialogAddExercise,
              backgroundColor: colorList[4],
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RemoveExerciseDialog extends StatelessWidget {
  final int idTask;
  RemoveExerciseDialog({super.key, required this.idTask});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Eliminar Ejercicio',
        style: TextStyle(
            fontFamily: 'IkkaRounded',
            fontSize: 24,
            color: Theme.of(context).primaryColor),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
          onPressed: () {
            context.read<ExerciseProvider>().removeExercise(idTask);
            Navigator.of(context).pop();
            Param.showSuccessToast(
                "Ejercicio eliminado con éxito"); // Close the dialog
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
          height: height - 550,
          width: width - 1200,
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
                options: const ['Nivel 1', 'Nivel 2', 'Nivel 3'],
                label: 'Nivel',
                onChanged: (value) {
                  context.read<ExerciseProvider>().setLevel = int.parse(
                      (value as String).replaceAll(RegExp(r'[^0-9]'), ''));
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
          onPressed: () {
            context.read<ExerciseProvider>().sendExercise(idPatient);
            Navigator.of(context).pop();
            Param.showSuccessToast(
                "Ejercicio Agregado con éxito");          
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
