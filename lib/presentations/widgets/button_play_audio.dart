import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speak_app_web/config/helpers/play_audio_manager.dart';
import 'package:speak_app_web/providers/play_audio_provider.dart';
import '../../common/common.dart';

class ButtonPlayAudio extends StatefulWidget {
  final String base64;
  const ButtonPlayAudio({super.key, required this.base64});

  @override
  ButtonPlayAudioState createState() => ButtonPlayAudioState();
}

class ButtonPlayAudioState extends State<ButtonPlayAudio>
    with WidgetsBindingObserver {
  PlayAudioManager _manager = PlayAudioManager();

  void initState() {
    _manager.setAudioSource(widget.base64);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(64)),
          border: Border.all(
            color: Theme.of(context).primaryColorDark,
            width: 2.0,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              icon: Icon(
                _manager.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Theme.of(context).primaryColorDark,
                size: 24,
              ),
              onPressed: () {
                if (_manager.isPlaying) {
                  _manager.pauseAudio();
                } else {
                  _manager.playAudioBase64(widget.base64);
                }
              }),
          StreamBuilder<PositionData>(
            stream: _manager.getStreamAudioPlayer(),
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return SeekBar(
                duration: positionData?.duration ?? Duration.zero,
                position: positionData?.position ?? Duration.zero,
                bufferedPosition:
                    positionData?.bufferedPosition ?? Duration.zero,
                disable: true,
              );
            },
          ),
        ],
      ),
    );
  }
}
