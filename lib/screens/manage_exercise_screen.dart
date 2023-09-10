import 'package:flutter/material.dart';
import 'package:speak_app_web/widgets/button_phoneme.dart';

import '../config/theme/app_theme.dart';
import '../widgets/menu.dart';
import '../widgets/tab_bar.dart';
import 'manage_exercise_view.dart';

class TabBarExample extends StatefulWidget {
  const TabBarExample({Key? key}) : super(key: key);

  @override
  _TabBarExampleState createState() => _TabBarExampleState();
}

class _TabBarExampleState extends State<TabBarExample>
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
        title: const Text('Primary and secondary TabBar'),
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
        children: <Widget>[
          Column(
            children: [
              Divider(
                thickness: 3,
                height: 3,
                color: colorList[7],
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text("Paciente       Hamiltons",
                      style: TextStyle(
                        fontSize: 36,
                        color: colorList[6],
                        fontFamily: 'IkkaRounded',
                      ))),
              const SecondTabBarMenu(),
            ],
          ),
          const Text("2"),
          const Text("3"),
        ],
      ),
    );
  }
}

class ListLateral extends StatelessWidget {
  const ListLateral({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              "Seleccione un fonema para habiltiar o\n Deshabilitar los ejercicios"),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              style: const ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(Size(230, 40))),
              onPressed: () => {},
              child: const Text("Articulema")),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
              style: const ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(Size(230, 40))),
              onPressed: () => {},
              child: const Text("Silaba")),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
              style: const ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(Size(230, 40))),
              onPressed: () => {},
              child: const Text("Palabra")),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
              style: const ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(Size(230, 40))),
              onPressed: () => {},
              child: const Text("Frase")),
        ],
      ),
    );
  }
}

class SecondTabBarMenu extends StatefulWidget {
  const SecondTabBarMenu({super.key});

  @override
  State<SecondTabBarMenu> createState() => _SecondTabBarMenuState();
}

class _SecondTabBarMenuState extends State<SecondTabBarMenu>
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

class BlockPhoneme extends StatelessWidget {
  const BlockPhoneme({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 50,
          runSpacing: 50,
          children: [
            ButtonPhoneme(),
            ButtonPhoneme(),
            ButtonPhoneme(),
            ButtonPhoneme(),
            ButtonPhoneme(),
            ButtonPhoneme(),
            ButtonPhoneme(),
            ButtonPhoneme(),
          ],
        ),
      ),
    );
  }
}
