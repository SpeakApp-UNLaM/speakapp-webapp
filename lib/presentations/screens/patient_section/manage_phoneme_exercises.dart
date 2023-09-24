import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speak_app_web/config/api.dart';
import 'package:speak_app_web/config/param.dart';
import 'package:speak_app_web/config/theme/app_theme.dart';
import 'package:speak_app_web/domain/entities/task.dart';
import 'package:speak_app_web/models/patient_model.dart';
import 'package:speak_app_web/models/task_model.dart';
import 'package:speak_app_web/shared/custom_dropdown_button.dart';

class ManagePhonemeExercises extends StatefulWidget {
  final int idPatient;
  final String idPhoneme;
  const ManagePhonemeExercises(
      {super.key, required this.idPatient, required this.idPhoneme});

  @override
  ManagePhonemeExercisesState createState() => ManagePhonemeExercisesState();
}

class ManagePhonemeExercisesState extends State<ManagePhonemeExercises>
    with TickerProviderStateMixin {
  Future<List<Task>>? _fetchData;

  Future<List<Task>> fetchData() async {
    final response = await Api.get("${Param.getTasks}/1");
    List<Task> lst = [];
    for (var element in response.data) {
      lst.add(TaskModel.fromJson(element).toTaskEntity());
    }

    return lst;
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

  void _openDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddExerciseDialog(); // Replace MyDialogWidget with your custom dialog content
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
                            ListView.separated(
                              shrinkWrap: true,
                              itemCount:
                                  snapshot.data?[0].categories.length as int,
                              separatorBuilder: ((context, index) => Divider()),
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        title: Text(
                                          Param.categoriesDescriptions[snapshot
                                              .data?[0]
                                              .categories[index]
                                              .category] as String,
                                          style: GoogleFonts.nunito(
                                            textStyle: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: FilledButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors
                                              .redAccent, // Cambia el color de fondo aquí
                                        ),
                                        onPressed: () {},
                                        child: const Text(
                                          "Eliminar",
                                          style: TextStyle(
                                            fontFamily: 'IkkaRounded',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton(
              onPressed: _openDialog,
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

class AddExerciseDialog extends StatelessWidget {
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
          height: height - 400,
          width: width - 800,
          child: Column(
            children: [
              const SizedBox(
                height: 50,
                width: 500,
              ),
              CustomDropdownButton(
                options: const ['R'],
                label: 'Fonéma',
                onChanged: null,
                errorMessage: null,
                value: 'R',
              ),
              const SizedBox(height: 30),
              CustomDropdownButton(
                options: const ['Nivel 1', 'Nivel 2', 'Nivel 3'],
                label: 'Nivel',
                onChanged: (value) => print(value),
                errorMessage: null,
              ),
              const SizedBox(height: 30),
              CustomDropdownButton(
                options: const ['Silabas', 'Palabras', 'Frases'],
                label: 'Categoria',
                onChanged: (value) => print(value),
                errorMessage: null,
              ),
            ],
          ),
        );
      }),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
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
