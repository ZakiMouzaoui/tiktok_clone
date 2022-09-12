import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';

class ProfileController extends GetxController{
  final Rx<Map<String, dynamic>> _user = Rx({});
  Map<String, dynamic> get user => _user.value;

  final Rx<String> _uid = "".obs;

  bool isFollowing = false;
  bool loading = false;
  bool loadingFollow = false;

  updateUserUid(uid)async{
    _uid.value = uid;
    loading = true;
    update();
    await getUserData().then((value){
      loading = false;
      update();
    });
  }

  Future getUserData()async{
    List<String> thumbnails = [];
    QuerySnapshot querySnapshot = await fireStore
        .collection("videos")
        .where("uid", isEqualTo: _uid.value)
        .get();

    for(int i=0; i<querySnapshot.docs.length; i++){
      thumbnails.add(querySnapshot.docs[i].get("thumbnail"));
    }

    DocumentSnapshot userDoc = await fireStore.collection("users").doc(_uid.value).get();
    final data = userDoc.data()! as dynamic;
    String name = data["name"];
    String profilePic = data["profilePic"];
    int likes = 0;
    int followers = 0;
    int followings = 0;

    for(var item in querySnapshot.docs){
      likes += ((item.data() as Map<String, dynamic>)["likes"] as List).length;
    }

    final followerDoc = await fireStore.collection("users").doc(_uid.value).collection("followers").get();
    final followingDoc = await fireStore.collection("users").doc(_uid.value).collection("followings").get();

    followers = followerDoc.docs.length;
    followings = followingDoc.docs.length;
    
    fireStore.collection("users").doc(_uid.value).collection("followers").doc(firebaseAuth.currentUser!.uid).get().then((value){
      if(value.exists){
        isFollowing = true;
      }
    });

    _user.value = {
      "followers": followers.toString(),
      "followings": followings.toString(),
      "likes": likes.toString(),
      "isFollowing": isFollowing,
      "profilePic": profilePic,
      "name": name,
      "thumbnails": thumbnails,
      "uid": _uid.value
    };
    update();
  }

  void followUser()async{
    loadingFollow = true;
    update();
    final doc = await fireStore.collection("users").doc(_uid.value).collection("followers").doc(firebaseAuth.currentUser!.uid).get();
    if(!doc.exists){
      await fireStore.collection("users").doc(_uid.value).collection("followers").doc(firebaseAuth.currentUser!.uid).set({});
      await fireStore.collection("users").doc(firebaseAuth.currentUser!.uid).collection("followings").doc(_uid.value).set({});

      _user.value.update("followers", (value) => (int.parse(value)+1).toString());
    }
    else{
      await fireStore.collection("users").doc(_uid.value).collection("followers").doc(firebaseAuth.currentUser!.uid).delete();
      await fireStore.collection("users").doc(firebaseAuth.currentUser!.uid).collection("followings").doc(_uid.value).delete();
      isFollowing = false;

      _user.value.update("followers", (value)=> (int.parse(value)-1).toString());
    }
    _user.value.update('isFollowing', (value) => !value);
    loadingFollow = false;
    update();
  }
}
