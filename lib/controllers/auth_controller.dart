import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/user.dart' as model;
import 'package:tiktok_clone/views/screens/auth/login_screen.dart';
import 'package:tiktok_clone/views/screens/home_screen.dart';
import 'package:tiktok_clone/views/screens/profile_screen.dart';

class AuthController extends GetxController{
  late Rx<File?> _pickImage;
  File? get getProfilePic  => _pickImage.value;
  late Rx<User?> _user;
  User? get user => _user.value;

  @override
  void onReady() {
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, setInitialScreen);
    super.onReady();
  }

  void setInitialScreen(User? user){
    if(user == null){
      Get.offAll(()=>LoginScreen());
    }
    else{
      Get.offAll(()=>const HomeScreen());
    }
  }

  void pickImage()async{
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    _pickImage = Rx<File?>(File(pickedImage!.path));
  }

  Future<void> registerUser(String userName, String email, String password, File? image)async{
    try{
      if(userName.isNotEmpty && userName.isNotEmpty && password.isNotEmpty && image != null){
        UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password
        );
        String downloadUrl = await _uploadToStorage(image);

        model.User user = model.User(
            name: userName,
            email: email,
            profilePic: downloadUrl,
            uid: userCredential.user!.uid
        );
        await fireStore.collection("users").doc(user.uid).set(user.toJson());
        pages[4] = ProfileScreen(uid: firebaseAuth.currentUser!.uid);
      }
      else{
        Get.snackbar("An error occurred", "Please fill all the fields");
      }
    }
    catch(e){
      Get.snackbar("An error occurred", e.toString());
    }
  }

  void loginUser(String email, String password)async{
    try{
      if(email.isNotEmpty && password.isNotEmpty){
        await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
        //_user.value = firebaseAuth.currentUser;
        //Get.offAll(()=>const HomeScreen());
        pages[4] = ProfileScreen(uid: firebaseAuth.currentUser!.uid);
      }
      else{
        Get.snackbar("An error occurred", "Please fill all the fields");
      }
    }
    catch(e){
      Get.snackbar("An error occurred", e.toString());
    }
  }

  Future<String> _uploadToStorage(File image)async{
    Reference reference = firebaseStorage.ref().child("profilePics").child(firebaseAuth.currentUser!.uid);
    TaskSnapshot taskSnapshot = await reference.putFile(image);
    return await taskSnapshot.ref.getDownloadURL();
  }

  void singOut()async{
    await firebaseAuth.signOut();
  }
}
