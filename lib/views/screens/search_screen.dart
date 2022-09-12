import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/search_controller.dart';
import 'package:tiktok_clone/models/user.dart';
import 'package:tiktok_clone/views/screens/profile_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  final _searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: TextFormField(
            decoration: const InputDecoration(
              filled: false,
              hintText: "Search",
              hintStyle: TextStyle(
                fontSize: 18, color: Colors.white
              )
            ),
            onFieldSubmitted: (value)=>_searchController.searchUser(value),
            onChanged: (value)async{
              await Future.delayed(const Duration(milliseconds: 500));
              _searchController.searchUser(value);
            },
          ),
        ),
        body: _searchController.searchedUsers.isEmpty
        ? const Center(
          child: Text("Search for users", style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),),
        ) : ListView.builder(
          itemCount: _searchController.searchedUsers.length,
            itemBuilder: (_, index){
            User user = _searchController.searchedUsers[index];
          return ListTile(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=>ProfileScreen(
                  uid: user.uid,
                ))
              );
            },
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  user.profilePic
                ),
              ),
              title: Text(
                user.name,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white
                ),
              ),
            );

        })
      ),
    );
  }
}
