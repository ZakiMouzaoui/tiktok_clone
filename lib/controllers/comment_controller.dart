import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/comment.dart';

class CommentController extends GetxController{
  final Rx<List<Comment>> _commentList = Rx<List<Comment>>([]);

  List<Comment> get comments => _commentList.value;

  String _postId = "";
  updatePostId(postId){
    _postId = postId;
    getComments();
  }

  Future getComments()async{
    await Future.delayed(const Duration(milliseconds: 10));
    _commentList.bindStream(fireStore.collection("videos").doc(_postId).collection("comments").orderBy("datePublished", descending: true).snapshots().map((query){
      List<Comment> retValue = [];
      for(var element in query.docs){
        retValue.add(Comment.fromSnapshot(element));
      }
      return retValue;
    }));
  }

  void postComment(String postComment)async{
    try{
      if(postComment.isNotEmpty){
        DocumentSnapshot userDoc = await fireStore.collection("users").doc(firebaseAuth.currentUser!.uid).get();
        var allDocs = await fireStore.collection("videos").doc(_postId).collection("comments").get();
        final len = allDocs.docs.length;

        Comment comment = Comment(
            userName: userDoc.get("name"),
            comment: postComment,
            datePublished: DateTime.now(),
            likes: [],
            profilePic: userDoc.get("profilePic"),
            uid: userDoc.get("uid"),
            id: "Comment $len"
        );
        final doc = fireStore.collection("videos").doc(_postId);
        await doc.collection("comments").doc("Comment $len").set(comment.toJson());

        final snapshot = await doc.get();
        await doc.update({
          "commentCount": snapshot.get("commentCount")+1
        });
      }
    }
    catch(e){
      Get.snackbar("An error occurred", e.toString());
    }
  }

  void likeComment(String videoId, String commentId)async{
    DocumentSnapshot doc = await fireStore.collection("videos").doc(videoId).collection("comments").doc(commentId).get();
    final uid  = firebaseAuth.currentUser!.uid;
    if((doc.data() as Map<String, dynamic>)["likes"].contains(uid)){
      await fireStore.collection("videos").doc(videoId).collection("comments").doc(commentId).update({
        "likes": FieldValue.arrayRemove([uid])
      });
    }
    else{
      await fireStore.collection("videos").doc(videoId).collection("comments").doc(commentId).update({
        "likes": FieldValue.arrayUnion([uid])
      });
    }
  }
}
