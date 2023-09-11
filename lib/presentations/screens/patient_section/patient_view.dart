import 'package:flutter/material.dart';

import '../../widgets/card_users.dart';

class PatientView extends StatelessWidget {
  const PatientView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(50.0),
              child: CardUser(),
            )
          ],
        ),
      ),
    );
  }
}
