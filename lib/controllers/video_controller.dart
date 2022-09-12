import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/video.dart';

class VideoController extends GetxController{
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList.value;

  @override
  void onInit() {
    _videoList.bindStream(fireStore.collection("videos").snapshots().map((query){
      List<Video> retValue = [];
      for(var element in query.docs){
        retValue.add(Video.fromSnapshot(element));
      }
      return retValue;
    }));

    super.onInit();
  }

  void likeVideo(String videoId)async{
    DocumentSnapshot doc = await fireStore.collection("videos").doc(videoId).get();
    final uid  = firebaseAuth.currentUser!.uid;
    if((doc.data() as Map<String, dynamic>)["likes"].contains(uid)){
      await fireStore.collection("videos").doc(videoId).update({
        "likes": FieldValue.arrayRemove([uid])
      });
    }
    else{
      await fireStore.collection("videos").doc(videoId).update({
        "likes": FieldValue.arrayUnion([uid])
      });
    }
  }
}