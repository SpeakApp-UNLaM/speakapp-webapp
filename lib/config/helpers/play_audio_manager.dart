import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../../../common/common.dart';

class PlayAudioManager {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;

  PlayAudioManager() {
    _audioPlayer = AudioPlayer();
  }

  Future<void> playAudio(String pathAudio) async {
    isPlaying = true;
    _audioPlayer.setFilePath(pathAudio);
    await _audioPlayer.play();
    await _audioPlayer.seek(Duration.zero);
    isPlaying = false;
  }

  Future<void> playAudioBase64(String base64) async {
    isPlaying = true;
    BufferAudioSource _buffer = BufferAudioSource.fromBase64(base64);

    await _audioPlayer.setAudioSource(_buffer);
    //_audioPlayer.setFilePath(pathAudio);
    await _audioPlayer.play();
    await _audioPlayer.seek(Duration.zero);
    isPlaying = false;
  }

  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
    isPlaying = false;
  }

  void disposeRecorder() {
    _audioPlayer.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  Stream<PositionData> getStreamAudioPlayer() => _positionDataStream;

  void reset() {
    _audioPlayer.dispose();
  }
}

class BufferAudioSource extends StreamAudioSource {
  Uint8List? _buffer;

  BufferAudioSource.fromBase64(String base64String) : super() {
    _buffer = base64.decode(base64String);
  }

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) {
    start = start ?? 0;
    end = end ?? _buffer?.length;

    return Future.value(
      StreamAudioResponse(
        sourceLength: _buffer?.length,
        contentLength: end! - start,
        offset: start,
        contentType: 'audio/mpeg',
        stream:
            Stream.value(List<int>.from(_buffer!.skip(start).take(end - start))),
      ),
    );
  }
}
