import 'package:flutter/material.dart';

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
