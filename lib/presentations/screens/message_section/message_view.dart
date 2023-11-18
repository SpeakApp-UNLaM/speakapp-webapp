import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:speak_app_web/config/api.dart';
import 'package:speak_app_web/config/param.dart';
import 'package:speak_app_web/config/theme/app_theme.dart';
import 'package:speak_app_web/models/contact_model.dart';
import 'package:speak_app_web/models/patient_model.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:speak_app_web/presentations/screens/message_section/message_provider.dart';
import 'package:speak_app_web/presentations/screens/message_section/messages_screen.dart';
import 'package:speak_app_web/providers/auth_provider.dart';

class MessageView extends StatefulWidget {
  static const String name = 'messages';
  const MessageView({super.key});

  @override
  State<MessageView> createState() => _MessageView();
}

class _MessageView extends State<MessageView> with TickerProviderStateMixin {
  late AuthProvider authProvider;
  late MessageProvider messageProvider;

  Future? _fetchData;
  late final AnimationController _controller;
  List<ContactModel> _patients = [];
  List<Image?> _patientsImages = [];

  late Timer _timer;

  Future fetchData() async {
    _patients = [];
    final response = await Api.get(Param.getContacts);

    for (var element in response.data) {
      _patients.add(ContactModel.fromJson(element));
    }

    _patients.sort((a, b) => (b.lastDateMessage ?? DateTime(0))
        .compareTo(a.lastDateMessage ?? DateTime(0)));

    for (var element in _patients) {
      _patientsImages.add(element.author.imageData == null
          ? null
          : Image.memory(base64.decode(element.author.imageData as String),
              fit: BoxFit.cover));
    }

    return response;
  }

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    messageProvider = Provider.of<MessageProvider>(context, listen: false);
    messageProvider.updateContacts();

    _controller = AnimationController(vsync: this);

    _fetchData = fetchData();

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      setState(() {
        messageProvider.updateMessages();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: /*const ChatPage(),*/
            Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
          horizontal: 100, vertical: 20), // Ocupa todo el ancho de la pantalla
      margin: const EdgeInsets.all(30.0),
      child: Card(
        color: Theme.of(context).cardColor,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: FutureBuilder(
            future: _fetchData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Container(
                    key: Key('no-results'),
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/animations/NoResults.json',
                          controller: _controller,
                          onLoaded: (composition) {
                            _controller
                              ..duration = composition.duration
                              ..repeat();
                          },
                          width:
                              200, // Ajusta el ancho de la animación según tus necesidades
                          height:
                              200, // Ajusta el alto de la animación según tus necesidades
                        ),
                        const SizedBox(
                            height:
                                50), // Espacio entre la animación y el texto
                        Text(
                          "Ha ocurrido un error inesperado: ${snapshot.error}",
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.data != null &&
                  (snapshot.data.data).length == 0) {
                return Center(
                  child: Container(
                    key: Key('box'),
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/animations/NoResultsBox.json',
                          controller: _controller,
                          onLoaded: (composition) {
                            _controller
                              ..duration = composition.duration
                              ..repeat();
                          },
                          width:
                              250, // Ajusta el ancho de la animación según tus necesidades
                          height:
                              250, // Ajusta el alto de la animación según tus necesidades
                        ),
                        const SizedBox(
                            height:
                                50), // Espacio entre la animación y el texto
                        Text(
                          "No se encontraron pacientes",
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Row(
                  children: [
                    Column(children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.zero,
                          width: 350.0,
                          child: ListView.builder(
                            itemCount: messageProvider.contacts.length,
                            itemBuilder: (context, index) {
                              return Card(
                                clipBehavior: Clip.antiAlias,
                                elevation: 5,
                                surfaceTintColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 10),
                                  tileColor:
                                      index != messageProvider.userToSelected
                                          ? Colors.transparent
                                          : Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.2),
                                  onTap: () {
                                    setState(() {
                                      messageProvider.updateUserTo(
                                          messageProvider
                                              .contacts[index].author.id,
                                          index,
                                          messageProvider
                                              .contacts[index].author.firstName,
                                          messageProvider
                                              .contacts[index].author.lastName,
                                          messageProvider.contacts[index].author
                                              .imageData);
                                      messageProvider.updateMessages();
                                    });
                                  },
                                  title: messageProvider
                                              .contacts[index].lastMessage !=
                                          null
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              "${messageProvider.contacts[index].author.firstName} ${messageProvider.contacts[index].author.lastName}",
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.nunito(
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              "${messageProvider.contacts[index].lastMessage}",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.nunito(
                                                color: Colors.grey.shade500,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          "${messageProvider.contacts[index].author.firstName} ${messageProvider.contacts[index].author.lastName}",
                                          style: GoogleFonts.nunito(
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                  leading: messageProvider.contacts[index]
                                              .author.imageData ==
                                          null
                                      ? CircleAvatar(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          foregroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          child: ClipOval(
                                            child: Icon(Icons.person),
                                          ),
                                        )
                                      : CircleAvatar(
                                          //TODO GET IMAGE FROM USER
                                          backgroundImage: (messageProvider
                                                      .contactsImages[index]
                                                  as Image)
                                              .image),
                                  trailing: messageProvider.contacts[index]
                                              .lastDateMessage !=
                                          null
                                      ? Text(
                                          DateFormat('dd/MM/yyyy HH:mm').format(
                                              (messageProvider.contacts[index]
                                                          .lastDateMessage
                                                      as DateTime)
                                                  .subtract(
                                                      const Duration(hours: 3))),
                                          style: GoogleFonts.nunito(
                                              color: Colors.grey.shade500,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600),
                                        )
                                      : const Text(""),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ]),
                    Expanded(
                      child: MessagesScreen(),
                    )
                  ],
                );
              }
            }),
      ),
    ));
  }
}
