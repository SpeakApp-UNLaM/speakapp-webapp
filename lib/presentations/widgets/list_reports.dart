import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
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
import 'package:speak_app_web/providers/exercise_provider.dart';
import 'package:speak_app_web/providers/report_provider.dart';
import 'package:speak_app_web/shared/custom_text_area_form_field.dart';
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
  List<ReportModel> _reports = [];
  Future? _fetchData;
  late final AnimationController _controller;

  Future fetchData() async {
    _reports = [];
    final response = await Api.get("${Param.getReports}/${widget.idPatient}");

    for (var element in response.data) {
      _reports.add(ReportModel.fromJson(element));
    }

    return response;
  }

  void _openDialogEditReport(ReportModel report) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReportDialog(
            report:
                report); // Replace MyDialogWidget with your custom dialog content
      },
    );

    if (result != null) {
      await _editReport(report.id).then((value) {
        /*
        showToast(
          " Ejercicio agregado exitosamente",
          textPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          position: ToastPosition.bottom,
          backgroundColor: Colors.greenAccent.shade700,
          radius: 8.0,
          textStyle: GoogleFonts.nunito(fontSize: 16.0, color: Colors.white),
          duration: const Duration(seconds: 5),
        );*/

        setState(() {
          _fetchData = fetchData();
        });
      },
          onError: (error) =>
              Param.showSuccessToast("Error al editar informe $error"));
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
      await _addReport(widget.idPatient).then((value) {
        //context.read<ReportProvider>().setPhonemeId = int.parse(widget.idPhoneme);
        setState(() {
          _fetchData = fetchData();
        });
      },
          onError: (error) =>
              Param.showSuccessToast("Error al agregar ejercicio $error"));
    }
  }

  void _openDialogRemoveReport(int id) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return RemoveReportDialog(
          id: id,
        ); // Replace MyDialogWidget with your custom dialog content
      },
    );

    if (result != null) {
      setState(() {
        _fetchData = fetchData();
      });
    }
  }

  Future<Response> _addReport(idPatient) async {
    final result = await context.read<ReportProvider>().sendReport(idPatient);
    return result;
  }

  Future<Response> _editReport(idPatient) async {
    final result = await context.read<ReportProvider>().updateReport(idPatient);
    return result;
  }

  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this, // Asegúrate de usar "this" como TickerProvider.
      duration: Duration(seconds: 1),
    );

    context.read<ReportProvider>().refreshData();

    _fetchData = fetchData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton(
              onPressed: _openDialogAddReport,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
        FutureBuilder(
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
                        "Aún no se han realizado informes para este paciente",
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
              return Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.grey.shade300),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ExpansionPanelList(
                      elevation: 3,
                      dividerColor: Theme.of(context).primaryColor,
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
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text( DateTime.parse(item.createdAt).toString(),
                                      style: GoogleFonts.nunito(
                                          color: Colors.grey.shade500,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                  Text(
                                    item.title,
                                    style: GoogleFonts.nunito(
                                        color:
                                            Theme.of(context).primaryColorDark,
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
                                      color: Theme.of(context).primaryColorDark,
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
                                  _openDialogRemoveReport(item.id);
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
                  ));
            }
          },
        ),
      ],
    );
  }
}

class ReportDialog extends StatefulWidget {
  final ReportModel? report;
  ReportDialog({Key? key, this.report}) : super(key: key);

  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  void initState() {
    super.initState();

    context.read<ReportProvider>().refreshData();
    if (widget.report != null) {
      context.read<ReportProvider>().setId = widget.report?.id as int;
      context.read<ReportProvider>().setTitle = widget.report?.title as String;
      context.read<ReportProvider>().setBody = widget.report?.body as String;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Column(
        children: [
          Text(
            'Nuevo Informe',
            style: TextStyle(
              fontFamily: 'IkkaRounded',
              fontSize: 20,
              color: Theme.of(context).primaryColor,
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
          child: Column(
            children: [
              CustomTextFormField(
                  label: 'Titulo',
                  initialValue: widget.report?.title ?? "",
                  onChanged: (value) {
                    context.read<ReportProvider>().setTitle = value;
                  }),
              const SizedBox(height: 30),
              CustomTextAreaFormField(
                  label: 'Cuerpo',
                  initialValue: widget.report?.body ?? "",
                  onChanged: (value) {
                    context.read<ReportProvider>().setBody = value;
                  })
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

class RemoveReportDialog extends StatelessWidget {
  final int id;
  RemoveReportDialog({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    Future<Response> _removeReport() async {
      final result = await context.read<ReportProvider>().removeReport(id);
      return result;
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Eliminar Informe',
        style: GoogleFonts.nunito(
            fontSize: 24,
            color: Theme.of(context).primaryColor),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 20),
      content: Builder(builder: (context) {
        var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;

        return Container(
          width: width * 0.4,
          height: height * 0.2,
          child: const Column(
            children: [
              Text(
                "Si confirmas la acción, el informe quedará eliminado permanentemente",
                textAlign: TextAlign.left,
              ),
            ],
          ),
        );
      }),
      actions: [
        TextButton(
          onPressed: () async {
            await _removeReport();
            Navigator.of(context).pop(true);
            /*
            showToast(
              "Reporte eliminado con éxito",
              textPadding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              position: ToastPosition.bottom,
              backgroundColor: Colors.greenAccent.shade700,
              radius: 8.0,
              textStyle:
                  GoogleFonts.nunito(fontSize: 16.0, color: Colors.white),
              duration: const Duration(seconds: 5),
            );*/
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
