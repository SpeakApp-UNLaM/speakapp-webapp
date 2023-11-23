import 'package:flutter/material.dart';
import 'package:speak_app_web/config/helpers/play_audio_manager.dart';
import '../common/common.dart';

class PlayAudioProvider extends ChangeNotifier {
  bool _playing = false;
  PlayAudioManager playManagerAudio = PlayAudioManager();

  bool get playing => _playing;

/*
  Future<void> playAudio(String base64) async {
    _playing = true;
    notifyListeners();
    await playManagerAudio.playAudioBase64();
    _playing = false;
    notifyListeners();
  }*/

  Future<void> pauseAudio() async {
    await playManagerAudio.pauseAudio();
    _playing = false;
    notifyListeners();
  }

  Stream<PositionData> getStreamAudioPlayer() =>
      playManagerAudio.getStreamAudioPlayer();


}
