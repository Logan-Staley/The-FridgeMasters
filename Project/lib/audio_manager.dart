import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioManager with WidgetsBindingObserver {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> startBackgroundMusic() async {
    await _audioPlayer.setVolume(0.2);
    await _audioPlayer.play(UrlSource('sounds/background_before_login.mp3'));
  }

  Future<void> stopBackgroundMusic() async {
    await _audioPlayer.stop();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      stopBackgroundMusic();
    } else if (state == AppLifecycleState.resumed) {
      startBackgroundMusic();
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer.dispose();
  }
}
