import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/controllers/auth_controller.dart';
import 'package:tiktok_clone/controllers/profile_controller.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileController = Get.put(ProfileController());
  final _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _profileController.updateUserUid(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (_)=>_profileController.loading
      ? const Center(
        child: CircularProgressIndicator(color: Colors.red,),
      ) : Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: const Icon(Icons.person_add_alt_1_outlined),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.more_horiz),
              )
            ],
            title: Text(
              _profileController.user["name"],
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: _profileController.user["profilePic"],
                              fit: BoxFit.cover,
                              height: 100,
                              width: 100,
                              placeholder: (_, __) => const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                ),
                              ),
                              errorWidget: (_, __, ___) =>
                                  const Icon(Icons.error_outline),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                _profileController.user["followings"],
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Followings",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.white70),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            children: [
                              Text(
                                _profileController.user["followers"],
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Followers",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.white70),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            children: [
                              Text(
                                _profileController.user["likes"],
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Likes",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.white70),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          if(firebaseAuth.currentUser!.uid == _profileController.user["uid"]){
                            _authController.singOut();
                          }
                          else{
                            _profileController.followUser();
                          }
                        },
                        child: Container(
                          width: 140,
                          height: 47,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12)),
                          child: _profileController.loadingFollow
                          ? const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.red,
                              ),
                            )
                          ) : Center(
                            child: Text(
                              firebaseAuth.currentUser!.uid == _profileController.user["uid"]
                                  ? "Sign out" : _profileController.user["isFollowing"] ? "unfollow" : "follow",
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),),
                          ),
                        ),
                      ),
                      GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1,
                                crossAxisSpacing: 5
                            ),
                            itemCount: _profileController.user["thumbnails"].length,
                            itemBuilder: (_,index){
                              return CachedNetworkImage(
                                  imageUrl: _profileController.user["thumbnails"][index],
                                fit: BoxFit.cover,
                              );
                            }
                        ),
                      
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
