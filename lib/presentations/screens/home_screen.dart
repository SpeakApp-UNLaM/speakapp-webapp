import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:speak_app_web/config/theme/app_theme.dart';
import 'package:speak_app_web/providers/auth_provider.dart';
import 'package:speak_app_web/providers/login_provider.dart';

import '../widgets/text_primary.dart';

enum SampleItem { config, logOut }

class HomeScreen extends StatefulWidget {
  final Widget child;
  const HomeScreen({Key? key, required this.child}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isPatientsSelected = true; // Variable para controlar la selección

  @override
  Widget build(BuildContext context) {
    void _openDialogShowProfessionalCode() async {
      final result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ShowCodeDialog(); // Replace MyDialogWidget with your custom dialog content
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          ElevatedButton(
            onPressed: () => _openDialogShowProfessionalCode(),
            child: TextPrimary(
              text: 'Mostrar codigo',
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 30),
          PopupMenuButton(
            tooltip: "Abrir menú",
            onSelected: (SampleItem item) {
              switch (item) {
                case SampleItem.logOut:
                  context.read<LoginProvider>().onLogOut(context);
                case SampleItem.config:
                  context.go('/user_settings');
                default:
                  return;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
              const PopupMenuItem<SampleItem>(
                value: SampleItem.config,
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    const SizedBox(width: 8),
                    Text('Configuración'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<SampleItem>(
                value: SampleItem.logOut,
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    const SizedBox(width: 8),
                    Text('Salir'),
                  ],
                ),
              ),
            ],
            child: context.read<AuthProvider>().loggedUser.imageData == null
                                      ? PhysicalModel(
                                          color: Theme.of(context).primaryColor,
                                          shadowColor: Theme.of(context).primaryColor,
                                          elevation: 12,
                                          shape: BoxShape.circle,
                                          child: CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            foregroundColor:
                                                Theme.of(context).primaryColor,
                                            child: const ClipOval(
                                              child:
                                                  Icon(Icons.person, size: 30),
                                            ),
                                          ),
                                        )
                                      : PhysicalModel(
                                          color: Theme.of(context).primaryColor,
                                          shape: BoxShape.circle,
                                          shadowColor: Theme.of(context).primaryColor,
                                          elevation: 12,
                                          child: CircleAvatar(
                                              radius: 20,
                                              //TODO GET IMAGE FROM USER
                                              backgroundImage:
                                                  (context.read<AuthProvider>().loggedUser.imageData as Image)
                                                      .image),
                                        ),
          ),
          SizedBox(width: 30)
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              width: 170,
              height: 50,
              fit: BoxFit.cover,
              image: AssetImage('assets/branding/Logo_SpeakApp.png'),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _isPatientsSelected = true; // Actualiza la selección
                });
                context.go('/patients');
              },
              icon: Icon(Icons.supervised_user_circle),
              label: Text(
                'Pacientes',
                style: TextStyle(
                  fontFamily: 'IkkaRounded',
                  fontSize: 20,
                  color: Colors.white,
                  shadows: _isPatientsSelected
                      ? [
                          Shadow(
                            offset: Offset(0, 0),
                            blurRadius: 10,
                            color: Colors.white.withOpacity(
                                0.8), // Color y opacidad de la sombra
                          ),
                        ]
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 30),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _isPatientsSelected = false; // Actualiza la selección
                });
                context.go('/message_view');
              },
              icon: Icon(Icons.message),
              label: Text(
                'Mensajes',
                style: TextStyle(
                  fontFamily: 'IkkaRounded',
                  fontSize: 20,
                  color: Colors.white,
                  shadows: !_isPatientsSelected
                      ? [
                          Shadow(
                            offset: Offset(0, 0),
                            blurRadius: 8,
                            color: Colors.white.withOpacity(
                                0.8), // Color y opacidad de la sombra
                          ),
                        ]
                      : null,
                ),
              ),
            ),
            const Spacer()
          ],
        ),
      ),
      body: widget.child,
    );
  }
}

class ShowCodeDialog extends StatelessWidget {
  ShowCodeDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.symmetric(vertical: 20),
      content: Builder(builder: (context) {
        var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;

        return Container(
          height: height * 0.2,
          width: width * 0.2,
          child: Center(
            child: SelectableText(
              'A2BBH2991ASKKK',
              style: TextStyle(
                  fontFamily: 'IkkaRounded',
                  fontSize: 24,
                  color: Theme.of(context).primaryColor),
            ),
          ),
        );
      }),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cerrar'),
        ),
      ],
    );
  }
}
