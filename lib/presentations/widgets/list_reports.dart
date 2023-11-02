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
import 'package:speak_app_web/models/report_model.dart';
import 'package:speak_app_web/models/task_model.dart';
import 'package:speak_app_web/presentations/screens/patient_section/phoneme_exercises_results.dart';
import 'package:speak_app_web/presentations/widgets/button_phoneme.dart';
import 'package:speak_app_web/shared/custom_text_form_field.dart';

class Item {
  final String body;
  final String title;
  final bool isExpanded;
  Item({
    required this.body,
    required this.title,
    this.isExpanded = false,
  });
}

class ListReports extends StatefulWidget {
  
  final int idPatient;
  const ListReports({Key? key, required this.idPatient}) : super(key: key);

  @override
  ListReportsState createState() => ListReportsState();
}

class ListReportsState extends State<ListReports>
    with SingleTickerProviderStateMixin {
  final List<ReportModel> _reports = [];
  Future? _fetchData;
  late final AnimationController _controller;

  Future fetchData() async {
    final response =
        await Api.get("${Param.getResolvedExercises}/${widget.idPatient}");

/*
    for (var element in response.data) {
      _reports.add(ReportModel(
        title: "Avance en la pronunciación del fonema R",
        subtitle: "Requerido para el estudio",
        body: "El paciente ha mostrado un avance el la pronunciacion del fonema R y el reconocimiento del mismo, sigue teniendo problemas con el fonema L",
        date: "02/08/2023",
      ));
    }
    */

    _reports.add(ReportModel(
        title: "Avance en la pronunciación del fonema R",
        subtitle: "Requerido para el estudio",
        body:
            "El paciente ha mostrado un avance el la pronunciacion del fonema R y el reconocimiento del mismo, sigue teniendo problemas con el fonema L",
        date: "02/08/2023",
        isExpanded: false));

    _reports.add(ReportModel(
        title: "Avance en la pronunciación del fonema L",
        subtitle: "Requerido para el estudio",
        body:
            "El paciente ha mostrado un avance el la pronunciacion del fonema R y el fonema L",
        date: "07/08/2023",
        isExpanded: false));

    _reports.add(ReportModel(
        title: "Avance en la pronunciación del fonema S",
        subtitle: "Requerido para el estudio",
        body:
            "El paciente ha mostrado un avance el la pronunciacion del fonema S y el reconocimiento del mismo, sigue teniendo problemas con el fonema R",
        date: "09/08/2023",
        isExpanded: false));

    _reports.add(ReportModel(
        title: "Avance en la pronunciación del fonema R",
        subtitle: "Requerido para el estudio",
        body:
            "El paciente ha mostrado un avance el la pronunciacion del fonema R y el reconocimiento del mismo, sigue teniendo problemas con el fonema L",
        date: "11/08/2023",
        isExpanded: false));

    return response;
  }

  void _openDialogEditReport(ReportModel report) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReportDialog(); // Replace MyDialogWidget with your custom dialog content
      },
    );

    if (result != null) {
      /*
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
              */
    }
  }

  void _openDialogAddReport() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReportDialog(); // Replace MyDialogWidget with your custom dialog content
      },
    );

    if (result != null) {
      /*
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
              */
    }
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
                        "El paciente aún no ha resuelto ejercicios",
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
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.grey.shade300),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              _reports[index].isExpanded = isExpanded;
                            });
                          },
                          children:
                              _reports.map<ExpansionPanel>((ReportModel item) {
                            return ExpansionPanel(
                              backgroundColor: colorList[7],
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  leading: IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: Theme.of(context).primaryColor,
                                    onPressed: () {
                                      _openDialogEditReport(item);
                                    },
                                  ),
                                  tileColor: colorList[7],
                                  title: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(item.date,
                                          style: GoogleFonts.nunito(
                                              color: Colors.grey.shade500,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500)),
                                      Text(
                                        item.title,
                                        style: GoogleFonts.nunito(
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              body: ListTile(
                                  title: Text(item.body,
                                      style: GoogleFonts.nunito(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)),
                                  subtitle: Text(
                                      'Si presiona en el cesto borrará el informe',
                                      style: GoogleFonts.nunito(
                                          color: Colors.grey.shade500,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500)),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.redAccent,
                                    onPressed: () {
                                      _reports.removeWhere(
                                          (ReportModel currentItem) =>
                                              item == currentItem);
                                    },
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _openDialogEditReport(item);
                                    });
                                  }),
                              isExpanded: item.isExpanded,
                            );
                          }).toList(),
                        ),
                      )));
            }
          },
        ),
      ),
    );
  }
}

class ReportDialog extends StatefulWidget {
  ReportDialog({Key? key}) : super(key: key);

  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
            'Consigna: Seleccionar y unir cada audio con la imágen correspondiente',
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 20),
      content: Builder(builder: (context) {
        var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          width: width * 0.5,
          height: height * 0.5,
          child: const Column(
            children: [
              CustomTextFormField(),
              const SizedBox(height: 30),
              CustomTextFormField()
            ],
          ),
        );
      }),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cerrar'),
        ),
      ],
    );
  }
}
