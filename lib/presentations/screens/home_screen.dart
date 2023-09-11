import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/text_primary.dart';

class HomeScreen extends StatelessWidget {
  final Widget child;
  const HomeScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const TextPrimary(text: 'Speak APP - Administración general'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(spacing: 50, children: [
                TextButton.icon(
                    onPressed: () => {context.go('/')},
                    icon: const Icon(Icons.supervised_user_circle),
                    label: const TextPrimary(text: 'Pacientes')),
                TextButton.icon(
                    onPressed: () => {context.go('/message_view')},
                    icon: const Icon(Icons.message),
                    label: const TextPrimary(text: 'Mensajes')),
                TextButton.icon(
                    onPressed: () => {context.go('/calendar_view')},
                    icon: const Icon(Icons.calendar_today),
                    label: const TextPrimary(text: 'Calendario')),
                ElevatedButton(
                    onPressed: () => {},
                    child: const TextPrimary(text: 'Generar código')),
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://4.bp.blogspot.com/-Jx21kNqFSTU/UXemtqPhZCI/AAAAAAAAh74/BMGSzpU6F48/s1600/funny-cat-pictures-047-001.jpg"),
                  backgroundColor: Colors.red,
                ),
              ]),
            ),
          )),
      body: child,
    );
  }
}
