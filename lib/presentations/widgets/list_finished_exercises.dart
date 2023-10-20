import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
    with TickerProviderStateMixin {
  final List<PhonemeTaskResolvedModel> _finishedTasks = [];
  Future? _fetchData;

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
    super.initState();
    _fetchData = fetchData();
  }

  @override
  void dispose() {
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
                    DataColumn(label: Text('Ejercicios finalizados')),
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
                        // Espaciado vertical
                        child: Text(
                          '1',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                              color: Theme.of(context).primaryColorDark,
                              fontWeight: FontWeight.w700),
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
    return SizedBox(
      height: 60.0,
      width: 60.0,
      child: Container(
        height: 60,
        width: 60,
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
