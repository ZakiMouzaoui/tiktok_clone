import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/controllers/video_controller.dart';
import 'package:tiktok_clone/views/screens/comment_screen.dart';
import 'package:tiktok_clone/views/widgets/circle_animation.dart';
import 'package:tiktok_clone/views/widgets/video_player_item.dart';
import 'package:get/get.dart';

class VideoScreen extends StatelessWidget {
  VideoScreen({Key? key}) : super(key: key);

  final _videoController = Get.put(VideoController());

  _profilePicture(String profilePic){
    return SizedBox(
      height: 60, width: 60,
      child: Stack(
        children: [
          Positioned(
              left: 5,
              child: Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25)
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image(
                    image: NetworkImage(profilePic),
                    fit: BoxFit.cover,
                  ),
                ),
              )
          )
        ],
      ),
    );
  }

  _buildMusicAlbum(String profilePic){
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.grey,
                  Colors.white
                ]
              ),
              borderRadius: BorderRadius.circular(25)
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(
                  profilePic,
                ),
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
          return PageView.builder(
            controller: PageController(initialPage: 0),
            scrollDirection: Axis.vertical,
            itemCount: _videoController.videoList.length,
              itemBuilder: (_, index){
              final data = _videoController.videoList[index];
                return Stack(
                  children: [
                    VideoPlayerItem(videoUrl: data.videoUrl),
                    Column(
                      children: [
                        const SizedBox(height: 100,),
                        Expanded(child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(child: Container(
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(data.userName, style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                  ),),
                                  Text(data.caption, style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,

                                  ),),
                                  Row(
                                    children: [
                                      const Icon(Icons.music_note, color: Colors.white, size: 15,),
                                      Text(data.songName, style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15
                                      ),)
                                    ],
                                  )
                                ],
                              ),
                            )),
                            Container(
                              width: 100,
                              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _profilePicture(data.profilePic),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          _videoController.likeVideo(data.id);
                                        },
                                        child: Icon(Icons.favorite,
                                        size: 40,
                                        color: data.likes.contains(firebaseAuth.currentUser!.uid)
                                          ? Colors.red : Colors.white,),
                                      ),
                                      const SizedBox(height: 7,),
                                      Text(
                                        data.likes.length.toString()
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CommentScreen(videoId: data.id,)));
                                        },
                                        child: const Icon(Icons.message,
                                          size: 40,
                                          color: Colors.white,),
                                      ),
                                      const SizedBox(height: 7,),
                                      Text(
                                          data.commentCount.toString()
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: (){

                                        },
                                        child: const Icon(Icons.reply,
                                          size: 40,
                                          color: Colors.white,),
                                      ),
                                      const SizedBox(height: 7,),
                                      Text(
                                          data.shareCount.toString()
                                      )
                                    ],
                                  ),
                                  CircleAnimation(
                                    child: _buildMusicAlbum(data.profilePic)
                                  )
                                ],
                              ),
                            )
                          ],
                        ))
                      ],
                    )
                  ],
                );
              }
          );
        }
      ),
    );
  }
}
