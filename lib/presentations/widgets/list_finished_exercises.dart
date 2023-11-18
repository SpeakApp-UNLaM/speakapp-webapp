import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:speak_app_web/config/api.dart';
import 'package:speak_app_web/config/param.dart';
import 'package:speak_app_web/config/theme/app_theme.dart';
import 'package:speak_app_web/models/category_model.dart';
import 'package:speak_app_web/models/exercise_model.dart';
import 'package:speak_app_web/models/phoneme_model.dart';
import 'package:speak_app_web/models/phoneme_task_resolved.dart';
import 'package:speak_app_web/models/task_model.dart';
import 'package:speak_app_web/presentations/screens/patient_section/phoneme_exercises_results.dart';
import 'package:speak_app_web/presentations/widgets/button_phoneme.dart';

class ListFinishedExercises extends StatefulWidget {
  final int idPatient;
  const ListFinishedExercises({Key? key, required this.idPatient})
      : super(key: key);

  @override
  ListFinishedExercisesState createState() => ListFinishedExercisesState();
}

class ListFinishedExercisesState extends State<ListFinishedExercises>
    with SingleTickerProviderStateMixin {
  final List<PhonemeTaskResolvedModel> _finishedTasks = [];
  Future? _fetchData;
  late final AnimationController _controller;

  Future fetchData() async {
    final response =
        await Api.get("${Param.getResolvedExercises}/${widget.idPatient}");

    for (var element in response.data) {
      _finishedTasks.add(PhonemeTaskResolvedModel(
        idPhoneme: element["idPhoneme"],
        namePhoneme: element["namePhoneme"],
      ));
    }

    return response;
  }

  void initState() {
    _controller = AnimationController(
      vsync: this, // Asegúrate de usar "this" como TickerProvider.
      duration: Duration(seconds: 1),
    );

    super.initState();
    _fetchData = fetchData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: FutureBuilder(
          future: _fetchData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data != null &&
                snapshot.data.data.length == 0) {
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
                        "El paciente aún no ha resuelto prácticas",
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
                  child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.red),
                child: DataTable(
                  border: TableBorder(
                      horizontalInside: BorderSide(
                          width: 3,
                          style: BorderStyle.solid,
                          color: Colors.grey.shade200)),
                  dataRowMinHeight: 60,
                  dataRowMaxHeight: 100,
                  columns: const [
                    DataColumn(label: Text('Fonema')),
                    DataColumn(label: Text('Acción')),
                  ],
                  rows: _finishedTasks.map((task) {
                    return DataRow(cells: [
                      DataCell(Container(
                        // Espaciado vertical
                        child: ButtonStaticPhoneme(
                          idPhoneme: task.idPhoneme,
                          namePhoneme: task.namePhoneme,
                        ),
                      )),
                      DataCell(Container(
                        child: FilledButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorList[4],
                          ),
                          onPressed: () {
                            // TODO: GET PATIENT ID
                            context.goNamed("phoneme_exercises_result",
                                pathParameters: {
                                  'idPatient': widget.idPatient.toString(),
                                  'idPhoneme': task.idPhoneme.toString(),
                                });
                          },
                          child: const Text(
                            "Ingresar",
                            style: TextStyle(
                              fontFamily: 'IkkaRounded',
                            ),
                          ),
                        ),
                      )),
                    ]);
                  }).toList(),
                ),
              ));
            }
          },
        ),
      ),
    );
  }
}

class ButtonStaticPhoneme extends StatelessWidget {
  final String namePhoneme;
  final int idPhoneme;

  const ButtonStaticPhoneme({
    required this.idPhoneme,
    required this.namePhoneme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: colorList[2],
      shadowColor: colorList[2],
      elevation: 12,
      shape: BoxShape.rectangle,
      borderRadius: const BorderRadius.all(
        Radius.circular(8),
      ),
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: colorList[0],
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(namePhoneme.replaceAll("CONSONANTICA", "").trim(),
                style: GoogleFonts.nunito(
                    fontSize: 24,
                    color: colorList[2],
                    fontWeight: FontWeight.w900)),
            if (namePhoneme.length > 3)
              Text("Consonántica",
                  style: GoogleFonts.nunito(
                      fontSize: 8,
                      color: colorList[2],
                      fontWeight: FontWeight.w900))
          ],
        ),
      ),
    );
  }
}
