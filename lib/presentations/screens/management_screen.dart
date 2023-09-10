import 'package:flutter/material.dart';
import '../widgets/text_primary.dart';
import 'calendar_section/calendar_view.dart';
import 'message_section/message_view.dart';
import 'patient_section/manage_patient_view.dart';

class ManagementScreen extends StatefulWidget {
  const ManagementScreen({Key? key}) : super(key: key);

  @override
  ManagementScreenState createState() => ManagementScreenState();
}

class ManagementScreenState extends State<ManagementScreen>
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
          unselectedLabelColor: Colors.white,
          labelColor: Theme.of(context).primaryColorDark,
          indicatorColor: Theme.of(context).primaryColorDark,
          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
          controller: _tabController,
          tabs: [
            const Tab(
              icon: Icon(Icons.supervised_user_circle),
              child: TextPrimary(text: 'Pacientes'),
            ),
            const Tab(
              icon: Icon(Icons.message),
              child: TextPrimary(text: 'Mensajes'),
            ),
            const Tab(
              icon: Icon(Icons.calendar_today),
              child: TextPrimary(text: 'Calendario'),
            ),
            ElevatedButton(
                onPressed: () => {},
                child: const TextPrimary(text: 'Generar código')),
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
        children: const [
          ManagePatientView(),
          MessageView(),
          CalendarView(),
        ],
      ),
    );
  }
}
