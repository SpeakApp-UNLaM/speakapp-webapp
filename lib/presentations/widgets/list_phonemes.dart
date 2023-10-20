import 'package:flutter/material.dart';
import 'package:speak_app_web/config/api.dart';
import 'package:speak_app_web/config/param.dart';
import 'package:speak_app_web/presentations/widgets/button_phoneme.dart';

class BlockPhoneme extends StatefulWidget {
  final int idPatient;
  const BlockPhoneme({
    Key? key,
    required this.idPatient,
  }) : super(key: key);

  @override
  BlockPhonemeState createState() => BlockPhonemeState();
}

class BlockPhonemeState extends State<BlockPhoneme>
    with TickerProviderStateMixin {
  final List<ButtonPhoneme> _buttonList = [];

  Future? _fetchData;

  Future fetchData() async {
    final response = await Api.get(Param.getPhonemes);

    for (var element in response.data) {
      _buttonList.add(ButtonPhoneme(
        idPatient: widget.idPatient,
        idPhoneme: element["idPhoneme"],
        namePhoneme: element["namePhoneme"],
      ));
    }

    return response;
  }

  void initState() {
    super.initState();
    _fetchData = fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = 120.0; // Ancho de un elemento
    final spacing = 20.0; // Espacio entre elementos

    // Calcula la cantidad de elementos por fila basándose en el ancho de la pantalla
    final itemsPerRow = (screenWidth / (itemWidth + spacing)).floor();
    final horizontalSpacing =
        (screenWidth - (itemsPerRow * itemWidth)) / (itemsPerRow - 1);

    return Expanded(
      child: SingleChildScrollView(
        child: FutureBuilder(
          future: _fetchData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Wrap(
                alignment: WrapAlignment.start,
                direction: Axis.horizontal,
                spacing: horizontalSpacing,
                runSpacing: spacing,
                children: _buttonList,
              );
            }
          },
        ),
      ),
    );
  }
}
