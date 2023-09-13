import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          Text(
              "Seleccione un fonema para habilitar o\ndeshabilitar los ejercicios", style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600),),
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
