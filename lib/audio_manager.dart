import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioManager with WidgetsBindingObserver {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _clickSoundPlayer = AudioPlayer();

  Future<void> startBackgroundMusic() async {
    await _audioPlayer.setVolume(0.12);
 //   await _audioPlayer.setLoopMode(LoopMode.one);
    await _audioPlayer.play(UrlSource('sounds/background_before_login.mp3'));
  }

  Future<void> stopBackgroundMusic() async {
    await _audioPlayer.stop();
  }

  Future<void> playClickSound() async {
    await _audioPlayer.setVolume(0.005);
    await _clickSoundPlayer.play(UrlSource('sounds/click_sound.mp3'));
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
    _clickSoundPlayer.dispose();
  }
}
