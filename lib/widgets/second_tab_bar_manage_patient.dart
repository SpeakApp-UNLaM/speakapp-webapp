import 'package:flutter/material.dart';

import 'list_phonemes.dart';
import 'menu_lateral_exercise.dart';

class SecondTabBarPatient extends StatefulWidget {
  const SecondTabBarPatient({super.key});

  @override
  State<SecondTabBarPatient> createState() => _SecondTabBarPatientState();
}

class _SecondTabBarPatientState extends State<SecondTabBarPatient>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: <Widget>[
          TabBar.secondary(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(text: 'Gestionar ejercicios'),
              Tab(text: 'Resultados de ejercicios'),
              Tab(text: 'Resultados del test'),
              Tab(text: 'Datos del paciente'),
              Tab(text: 'Informes de sesiones'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 23, vertical: 50),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListLateral(),
                      SizedBox(
                        width: 50,
                      ),
                      BlockPhoneme()
                    ],
                  ),
                ),
                Text("asd"),
                Text("asd"),
                Text("asd"),
                Text("asd"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
