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
          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
          controller: _tabController,
          tabs: [
            const Tab(
              text: 'Pacientes',
              icon: Icon(Icons.supervised_user_circle),
            ),
            const Tab(
              text: 'Mensajes',
              icon: Icon(Icons.message),
            ),
            const Tab(
              text: 'Calendario',
              icon: Icon(Icons.calendar_today),
            ),
            ElevatedButton(
                onPressed: () => {}, child: const Text("Generar código")),
            const CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://4.bp.blogspot.com/-Jx21kNqFSTU/UXemtqPhZCI/AAAAAAAAh74/BMGSzpU6F48/s1600/funny-cat-pictures-047-001.jpg"),
              backgroundColor: Colors.red,
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
