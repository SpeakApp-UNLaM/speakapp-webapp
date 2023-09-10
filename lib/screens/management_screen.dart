import 'package:flutter/material.dart';
import 'package:speak_app_web/screens/patient_section/manage_patient_view.dart';

import '../widgets/text_primary.dart';

class ManagementScreen extends StatefulWidget {
  const ManagementScreen({Key? key}) : super(key: key);

  @override
  _ManagementScreenState createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextPrimary(text: 'Speak APP - Administración general'),
        bottom: TabBar(
          controller: _tabController, // Asignar el controlador aquí
          tabs: const <Widget>[
            Tab(
              text: 'Pacientes',
              icon: Icon(Icons.supervised_user_circle),
            ),
            Tab(
              text: 'Mensajes',
              icon: Icon(Icons.message),
            ),
            Tab(
              text: 'Calendario',
              icon: Icon(Icons.calendar_today),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController, // Asignar el controlador aquí
        children: const <Widget>[
          ManagePatientView(),
          Text("2"),
          Text("3"),
        ],
      ),
    );
  }
}
