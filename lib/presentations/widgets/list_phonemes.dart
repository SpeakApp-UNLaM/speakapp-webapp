import 'package:flutter/material.dart';

import 'button_phoneme.dart';

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
          ],
        ),
      ),
    );
  }
}
