import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:speak_app_web/config/theme/app_theme.dart';
import 'package:speak_app_web/providers/login_provider.dart';

import '../widgets/text_primary.dart';

enum SampleItem { config, logOut }

class HomeScreen extends StatelessWidget {
  final Widget child;
  const HomeScreen({super.key, required this.child});

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
            child: const CircleAvatar(
              backgroundImage: NetworkImage(
                "https://hips.hearstapps.com/hmg-prod/images/portrait-of-a-happy-young-doctor-in-his-clinic-royalty-free-image-1661432441.jpg?crop=0.66698xw:1xh;center,top&resize=1200:*",
              ),
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
              onPressed: () => context.go('/patients'),
              icon:
                  const Icon(Icons.supervised_user_circle, color: Colors.white),
              label: const TextPrimary(text: 'Pacientes', color: Colors.white),
            ),
            const SizedBox(width: 30),
            TextButton.icon(
              onPressed: () => context.go('/message_view'),
              icon: const Icon(Icons.message, color: Colors.white),
              label: const TextPrimary(text: 'Mensajes', color: Colors.white),
            ),
            const Spacer()
          ],
        ),
      ),
      body: child,
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
