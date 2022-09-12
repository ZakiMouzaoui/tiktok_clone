import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  const VideoPlayerItem({Key? key, required this.videoUrl}) : super(key: key);

  final String videoUrl;

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;
  bool loading = true;

  @override
  void initState() {
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)..initialize()
    .then((value){
      videoPlayerController.play();
      videoPlayerController.setVolume(1);
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return loading ? const Center(
      child: CircularProgressIndicator(
        color: Colors.red,
      ),
    ) : GestureDetector(
      onTap: (){
        if(videoPlayerController.value.isPlaying){
          videoPlayerController.pause();
        }
        else{
          videoPlayerController.play();
        }
      },
      child: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          color: Colors.black
        ),
        child: VideoPlayer(
          videoPlayerController
        )
      ),
    );
  }
}
