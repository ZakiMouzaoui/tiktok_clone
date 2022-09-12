import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  String name;
  String profilePic;
  String email;
  String uid;

  User({
    required this.name,
    required this.profilePic,
    required this.email,
    required this.uid
  });

  Map<String, dynamic> toJson(){
    return {
      "name": name,
      "profilePic": profilePic,
      "email": email,
      "uid": uid
    };
  }

  static User fromSnapshot(DocumentSnapshot snapshot){
    var data = snapshot.data() as Map<String, dynamic>;
    return User(
        name: data["name"],
        profilePic:data["profilePic"],
        email: data["email"],
        uid: data["uid"]
    );
  }
}
