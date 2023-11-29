/* import 'package:flutter/material.dart';

class TutorialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutorial Page'),
      ),
      body: const Center(
        child: Text('Welcome to the Tutorial!'),
      ),
    );
  }
} */

//Mathilde G /Massiray T-K

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VideoAndTutorialPage(),
    );
  }
}

class VideoAndTutorialPage extends StatefulWidget {
  @override
  _VideoAndTutorialPageState createState() => _VideoAndTutorialPageState();
}

class _VideoAndTutorialPageState extends State<VideoAndTutorialPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(
      File(
        "C:\Users\tmass\Downloads\untitled.webm",
      ),
    )..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video and Tutorial Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Video Player
          _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
          SizedBox(height: 20), // Adjust spacing as needed

          // Tutorial Page
          TutorialPage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class TutorialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Welcome to the Tutorial!'),
    );
  }
}
