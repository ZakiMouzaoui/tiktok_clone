import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/user.dart';

class SearchController extends GetxController{
  final Rx<List<User>> _searchedUsers = Rx([]);

  List<User> get searchedUsers => _searchedUsers.value;

  searchUser(String typedUser)async{
    _searchedUsers.bindStream(fireStore.collection("users")
        .where("name", isGreaterThanOrEqualTo: typedUser.toUpperCase())
        .where('name', isLessThan: typedUser +'z').snapshots()
    .map((query){
      List<User> returnVal = [];
      for(var snapshot in query.docs){
        returnVal.add(User.fromSnapshot(snapshot));
      }
      return returnVal;
    }));
  }
}