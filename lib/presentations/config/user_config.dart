import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/theme/app_theme.dart';
import '../../../../shared/custom_filled_button.dart';
import '../../../../shared/custom_text_form_field.dart';
import '../../../../shared/geometrical_background.dart';

class UserConfigScreen extends StatefulWidget {
  const UserConfigScreen({Key? key}) : super(key: key);

  @override
  _UserConfigScreenState createState() => _UserConfigScreenState();
}

class _UserConfigScreenState extends State<UserConfigScreen> {
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textStyles = Theme.of(context).textTheme;

    return Scaffold(
      body: GeometricalBackground(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              // Icon Banner
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      context.go('/patients');
                    },
                    icon: const Icon(Icons.arrow_back_rounded,
                        size: 40, color: Colors.white),
                  ),
                  Text('Configuración del Usuario',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                          textStyle: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w800))),
                  const Spacer(flex: 2),
                ],
              ),

              const SizedBox(height: 50),

              Container(
                height: size.height - 260,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: scaffoldBackgroundColor,
                  borderRadius:
                      const BorderRadius.only(topLeft: Radius.circular(100)),
                ),
                child: FutureBuilder<void>(
                  future: _loadUserPreferences(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      return _UserConfigForm(
                        name: prefs.getString('firstName') ?? '',
                        lastName: prefs.getString('lastName') ?? '',
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserConfigForm extends StatelessWidget {
  final String name;
  final String lastName;

  const _UserConfigForm({required this.name, required this.lastName});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 500),
      child: Column(
        children: [
          const SizedBox(height: 50),
          CustomTextFormField(
            label: 'Nombre',
            keyboardType: TextInputType.emailAddress,
            initialValue: name,
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            label: 'Apellido',
            keyboardType: TextInputType.emailAddress,
            initialValue: lastName,
          ),
          const SizedBox(height: 20),
          const CustomTextFormField(
            label: 'Correo',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 40),
          FractionallySizedBox(
            widthFactor: 0.7, // Establece el factor de ancho al 70%
            heightFactor: null, // Mantén la altura automática (40 en este caso)
            child: SizedBox(
              height: 50,
              child: CustomFilledButton(
                text: 'Guardar',
                buttonColor: colorList[0],
                onPressed: () {},
              ),
            ),
          ),
          const Spacer(flex: 2),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
