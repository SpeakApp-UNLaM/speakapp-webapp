import 'package:flutter/material.dart';

class TabBarW extends StatelessWidget {
  final TabController tabController;
  const TabBarW({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      tabs: [
        Tab(
          text: 'Gestionar ejercicios',
        ),
        Tab(
          text: 'Resultados ejercicios',
        ),
        Tab(
          text: 'Resultados TEST RFI',
        ),
        Tab(
          text: 'Datos del paciente',
        ),
        Tab(
          text: 'Informes de sesiones',
        ),
      ],
    );
  }
}
