import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/upload_video_controller.dart';
import 'package:tiktok_clone/views/widgets/text_input_field.dart';
import 'package:video_player/video_player.dart';

class ConfirmScreen extends StatefulWidget {
  const ConfirmScreen(
      {Key? key, required this.videoFile, required this.videoPath})
      : super(key: key);

  final File videoFile;
  final String videoPath;

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late VideoPlayerController _controller;
  final TextEditingController _songController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();

  final _videoUploadController = Get.put(UploadVideoController());
  bool loading = false;

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  void initPlayer() async {
    _controller = VideoPlayerController.file(widget.videoFile);
    await _controller.initialize().then((value) {
      _controller.play();
      _controller.setVolume(1);
      _controller.setLooping(true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _songController.dispose();
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //const SizedBox(height: 30,),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.5,
              child: VideoPlayer(_controller),
            ),
            const SizedBox(
              height: 30,
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width - 20,
              child: TextInputField(
                controller: _songController,
                label: "Song Name",
                icon: Icons.music_note,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width - 20,
              child: TextInputField(
                controller: _captionController,
                label: "Caption",
                icon: Icons.closed_caption,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            loading ? const CircularProgressIndicator(
              color: Colors.red,
            )
                : ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)
                ),
                onPressed: () {
                  setState(() {
                    loading = true;
                  });

                  _videoUploadController.uploadVideo(
                      _songController.text.trim(),
                      _captionController.text.trim(),
                      widget.videoPath
                  );
                  // setState(() {
                  //   loading = false;
                  // });
                },
                child: const Text(
                  "Share",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
