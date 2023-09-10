import 'package:flutter/material.dart';

class ManageExerciseView extends StatelessWidget {
  const ManageExerciseView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(-1.00, -1.00),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Align(
                    alignment: AlignmentDirectional(-1.00, 0.00),
                    child: Text(
                      'Seleccione un fonema para habilitar o \ndeshabilitar los ejercicios del paciente',
                    )),
                Align(
                  alignment: const AlignmentDirectional(0.00, 0.00),
                  child: FloatingActionButton(
                    onPressed: () {},
                    child: const Text('Articulemas'),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0.00, 0.00),
                  child: FloatingActionButton(
                    onPressed: () {},
                    child: const Text('Silabas'),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0.00, 0.00),
                  child: FloatingActionButton(
                    onPressed: () {},
                    child: const Text('Palabras'),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0.00, 0.00),
                  child: FloatingActionButton(
                    onPressed: () {},
                    child: const Text('Frases'),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: const AlignmentDirectional(-1.00, -1.00),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                child: Wrap(
                  spacing: 50,
                  runSpacing: 50,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  direction: Axis.horizontal,
                  runAlignment: WrapAlignment.start,
                  verticalDirection: VerticalDirection.down,
                  clipBehavior: Clip.none,
                  children: [
                    FloatingActionButton(
                        onPressed: () => {}, child: const Text("buton")),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
