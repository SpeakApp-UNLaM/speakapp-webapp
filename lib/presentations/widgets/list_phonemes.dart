import 'package:flutter/material.dart';
import 'package:speak_app_web/config/api.dart';
import 'package:speak_app_web/config/param.dart';
import 'package:speak_app_web/presentations/widgets/button_phoneme.dart';

class BlockPhoneme extends StatefulWidget {
  final int idPatient;
  const BlockPhoneme({
    Key? key,
    required this.idPatient
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
    final itemsPerRow = 6;
    final spacing = (screenWidth - (itemsPerRow * 120)) /
        (itemsPerRow - 1);

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
                alignment: WrapAlignment.spaceEvenly,
                direction: Axis.horizontal,
                spacing: spacing,
                runSpacing: 20,
                children: [
                  for (var i = 0; i < _buttonList.length; i += itemsPerRow)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for (var j = i;
                                j < i + itemsPerRow && j < _buttonList.length;
                                j++)
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: spacing / itemsPerRow),
                                  child: _buttonList[j],
                                )
                              ,
                          ],
                        ),
                      ],
                    ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
