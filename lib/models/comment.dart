import 'package:cloud_firestore/cloud_firestore.dart';

class Comment{
  String userName;
  String comment;
  final DateTime datePublished;
  List likes;
  String profilePic;
  String uid;
  String id;

  Comment({
    required this.userName,
    required this.comment,
    required this.datePublished,
    required this.likes,
    required this.profilePic,
    required this.uid,
    required this.id
  });

  Map<String, dynamic> toJson(){
    return {
      "id": id,
      "uid": uid,
      "userName": userName,
      "comment": comment,
      "datePublished": datePublished,
      "likes": likes,
      "profilePic": profilePic,
    };
  }

  static Comment fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot){
    return Comment(
        userName: snapshot["userName"],
        comment: snapshot["comment"],
        datePublished: DateTime.fromMicrosecondsSinceEpoch(snapshot["datePublished"].microsecondsSinceEpoch),
        likes: snapshot["likes"],
        profilePic: snapshot["profilePic"],
        uid: snapshot["uid"],
        id: snapshot["id"]
    );
  }
}
