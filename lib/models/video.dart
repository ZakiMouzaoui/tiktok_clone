import 'package:cloud_firestore/cloud_firestore.dart';

class Video{
  String userName;
  String uid;
  String id;
  List likes;
  int commentCount;
  int shareCount;
  String songName;
  String caption;
  String videoUrl;
  String thumbnail;
  String profilePic;

  Video({
    required this.userName,
    required this.uid,
    required this.id,
    required this.likes,
    required this.commentCount,
    required this.shareCount,
    required this.songName,
    required this.caption,
    required this.thumbnail,
    required this.profilePic,
    required this.videoUrl
  });

  Map<String, dynamic> toJson(){
    return{
      "userName": userName,
      "uid": uid,
      "id": id,
      "likes": likes,
      'commentCount': commentCount,
      "shareCount": shareCount,
      "songName": songName,
      "caption": caption,
      "thumbnail": thumbnail,
      "profilePic": profilePic,
      "videoUrl": videoUrl
    };
  }

  static Video fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot){
    final data = snapshot.data() as Map<String, dynamic>;
    return Video(
        thumbnail: data["thumbnail"],
        uid: data["uid"],
        profilePic: data["profilePic"],
        likes: data["likes"],
        userName: data["userName"],
        id: data["id"],
        caption: data["caption"],
        shareCount: data["shareCount"],
        commentCount: data["commentCount"],
        videoUrl: data["videoUrl"],
        songName: data["songName"]
    );
  }
}