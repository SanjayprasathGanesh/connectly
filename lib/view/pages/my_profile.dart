import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:connectly/view_model/posts/user_profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';

import '../../controller/local_login_storage.dart';
import '../../services/common_methods.dart';

@RoutePage()
class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  final UserProfileViewModel userProfileViewModel = Get.find<UserProfileViewModel>();
  final LocalLoginStorage credentials = Get.find<LocalLoginStorage>();
  String userId = "";
  String psw = "";

  getUserId() async {
    userId = (await credentials.getUserName())!;
    psw = (await credentials.getUserPsw())!;
    psw = convertStringToObsecureString(psw);
    setState(() {});
    userProfileViewModel.loadPostsForUser();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 50,
              ),
            ),
            title: Text(userId,style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'OpenSans',),),
            subtitle: Text(psw,style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'OpenSans',),),
            enabled: false,
          ),
          const SizedBox(height: 10),
          const Divider(thickness: 2.0,color: Colors.black,),
          const Text("My Posts", style: TextStyle(
            color: Colors.black,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              // Check if posts are empty
              if (userProfileViewModel.posts.value.isEmpty) {
                return const Center(
                  child: Text(
                    'No posts available yet. Start sharing your moments!',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans'
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                // If posts are not empty, show the grid view
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: userProfileViewModel.posts.value.length,
                  itemBuilder: (context, index) {
                    final post = userProfileViewModel.posts[index];
                    return Card(
                      color: Colors.purple[100],
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.file(
                              File(post.imageUrl![0]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
