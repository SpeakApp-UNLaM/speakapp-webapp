import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class MessageView extends StatefulWidget {
  static const String name = 'messages';
  const MessageView({super.key});

  @override
  State<MessageView> createState() => _MessageView();
}

class _MessageView extends State<MessageView> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: /*const ChatPage(),*/
       Container(
        child: Center(
          child: Column(
            children: [
              Text("COMING SOON - NOVIEMBRE 2023",
                  style: GoogleFonts.nunito(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColorDark
                  )),
              Lottie.asset(
                'assets/animations/congrats.json',
                width: MediaQuery.of(context).size.width * 0.2,
                height:  MediaQuery.of(context).size.width * 0.2,
                controller: _controller,
                onLoaded: (composition) {
                  // Configure the AnimationController with the duration of the
                  // Lottie file and start the animation.
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


