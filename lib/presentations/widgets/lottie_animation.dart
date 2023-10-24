import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class AnimationL extends StatefulWidget {
  final String animationPath;
  final double? size;
  final String? text;

  const AnimationL(
      {super.key,
      required this.animationPath,
      this.size = 50.0,
      this.text = ""});

  @override
  State<AnimationL> createState() => _AnimationLState();
}

class _AnimationLState extends State<AnimationL> with TickerProviderStateMixin {
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
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Wrap(
        children: [
          Text('${widget.text}'),
          Lottie.asset(
            widget.animationPath,
            controller: _controller,
            onLoaded: (composition) {
              _controller
                ..duration = composition.duration
                ..repeat();
            },
          ),
        ],
      ),
    );
  }
}
