import 'package:flutter/material.dart';

class MenuWeb extends StatelessWidget {
  const MenuWeb({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text(
          'Pacientes',
        ),
        const Text(
          'Mensajes',
        ),
        const Text(
          'Calendario',
        ),
        ElevatedButton(
            onPressed: () => {}, child: const Text("Generar Codigo")),
        Container(
          width: 50,
          height: 50,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: const Text("asd"),
        ),
      ],
    );
  }
}
