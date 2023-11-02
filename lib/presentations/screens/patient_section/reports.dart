import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speak_app_web/presentations/widgets/list_finished_exercises.dart';
import 'package:speak_app_web/presentations/widgets/list_reports.dart';

class Reports extends StatelessWidget {
  final int idPatient;
  const Reports({super.key, required this.idPatient});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 23, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Informes del paciente",
                style: GoogleFonts.nunito(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FloatingActionButton(
                  onPressed: () {

                  },
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          Divider(),
          const SizedBox(
            height: 30,
          ),
          ListReports(idPatient: idPatient)
        ],
      ),
    );
  }
}
