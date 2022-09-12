import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/controllers/comment_controller.dart';
import 'package:timeago/timeago.dart' as time_ago;

class CommentScreen extends StatelessWidget {
  CommentScreen({Key? key, required this.videoId}) : super(key: key);

  final commentController = TextEditingController();
  final _commentController = Get.put(CommentController(), permanent: true);
  final String videoId;

  @override
  Widget build(BuildContext context) {
    _commentController.updatePostId(videoId);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Expanded(child: Obx(()=>_commentController.comments.isNotEmpty
      ? ListView.builder(
                  itemCount: _commentController.comments.length,
                  itemBuilder: (_, index)=>ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.black,
                      backgroundImage: NetworkImage(_commentController.comments[index].profilePic),
                    ),
                    title: Row(
                      children: [
                        Text(_commentController.comments[index].userName, style: const TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            fontWeight: FontWeight.w700
                        ),),
                        const SizedBox(width: 5,),
                        Expanded(
                          child: Text(
                            _commentController.comments[index].comment,style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500
                          ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Text(time_ago.format(_commentController.comments[index].datePublished), style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12
                        ),),
                        const SizedBox(width: 10,),
                        Text("${_commentController.comments[index].likes.length} likes", style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12
                        ),)
                      ],
                    ),
                    trailing: InkWell(
                        onTap: (){
                          _commentController.likeComment(videoId, _commentController.comments[index].id);
                        },child: Icon(
                      _commentController.comments[index].likes.contains(firebaseAuth.currentUser!.uid)
                      ? Icons.favorite : Icons.favorite_outline, size: 25, color: Colors.red,)),
                  )): const Center(
                child: Text("No comments found", style: TextStyle(
                  color: Colors.white
                ),),
              ))
              ),
              const Divider(),
              ListTile(
                title: TextFormField(
                  controller: commentController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16
                  ),
                  decoration: const InputDecoration(
                    labelText: "Comment",
                    labelStyle: TextStyle(color: Colors.white,
                    fontSize: 20, fontWeight: FontWeight.w700),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red
                      )
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red
                        )
                    )
                  ),
                ),
                trailing: TextButton(onPressed: () {
                  _commentController.postComment(commentController.text.trim());
                },
                  child: const Text("Send", style: TextStyle(
                    fontSize: 16,
                    color: Colors.white
                  ),)

                ),
              )
            ],
          ),
        ),
    );
  }
}
