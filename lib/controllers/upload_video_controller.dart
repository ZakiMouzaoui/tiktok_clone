import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/video.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController{
  uploadVideo(String songName, String caption, String videoPath)async{
    try{
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> userDoc = await fireStore.collection("users").doc(uid).get();
      var allDocs = await fireStore.collection("videos").get();
      int len = allDocs.docs.length;
      String videoUrl = await _uploadVideoToStorage("Video$len", videoPath);
      String thumbnail = await _uploadImageToStorage("Video $len", videoPath);

      Video video = Video(
          userName: userDoc.data()!["name"],
          uid: uid,
          id: "Video $len",
          likes: [],
          commentCount: 0,
          shareCount: 0,
          songName: songName,
          caption: caption,
          thumbnail: thumbnail,
          profilePic: userDoc.data()!["profilePic"],
          videoUrl: videoUrl
      );
      await fireStore.collection("videos").doc(video.id).set(video.toJson());
      Get.back();
    }
    catch(e){
      print(e.toString());
      Get.snackbar("Error while uploading the video", e.toString());
    }
  }

  Future<String> _uploadVideoToStorage(id, videoPath)async{
    Reference ref = firebaseStorage.ref().child("videos").child(id);
    final file = await _compressVideo(videoPath);
    UploadTask uploadTask = ref.putFile(file!);
    TaskSnapshot taskSnapshot = await uploadTask;
    final downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> _uploadImageToStorage(id, videoPath) async{
    Reference ref = firebaseStorage.ref().child("thumbnails").child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot taskSnapshot = await uploadTask;
    final downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<File?> _compressVideo(videoPath)async{
    final compressedVideo = await VideoCompress.compressVideo(videoPath, quality: VideoQuality.MediumQuality);
    return compressedVideo?.file;
  }

  Future _getThumbnail(videoPath)async{
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }
}