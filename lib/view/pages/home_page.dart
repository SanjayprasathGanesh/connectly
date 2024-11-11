import 'package:auto_route/auto_route.dart';
import 'package:connectly/controller/local_login_storage.dart';
import 'package:connectly/view/widgets/custom_toast.dart';
import 'package:connectly/view_model/posts/likes_view_model.dart';
import 'package:connectly/view_model/posts/post_view_model.dart';
import 'package:connectly/view_model/posts/share_posts_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:toast/toast.dart';

import '../../model/posts/posts_model.dart';

@RoutePage()
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PostViewModel postViewModel = Get.find<PostViewModel>();
  final LikesViewModel likesViewModel = Get.find<LikesViewModel>();
  final SharePostsViewModel sharePostsViewModel = Get.find<SharePostsViewModel>();
  final LocalLoginStorage credentials = Get.find<LocalLoginStorage>();
  String? userId = "";

  Future<void> _refreshPosts() async {
    userId = await credentials.getUserName();
    await postViewModel.getAllPosts();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshPosts();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _refreshPosts,
        child: Container(
          margin: const EdgeInsets.all(20.0),
          width: ResponsiveBreakpoints.of(context).isDesktop
              ? ResponsiveBreakpoints.of(context).screenWidth * 0.6
              : ResponsiveBreakpoints.of(context).isTablet
                  ? ResponsiveBreakpoints.of(context).screenWidth * 0.9
                  : ResponsiveBreakpoints.of(context).screenWidth,
          height: ResponsiveBreakpoints.of(context).screenHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
          ),
          child: Obx(() => postViewModel.allPostsList.isNotEmpty ? ListView.builder(
              itemCount: postViewModel.allPostsList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var allPosts = postViewModel.allPostsList;
                if (postViewModel.isAllPostLoaded.value && allPosts.isNotEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(allPosts[index].userId!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                          const SizedBox(height: 5.0,),
                          Text(allPosts[index].location!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic,
                              fontSize: 15.0,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Container(
                            height: 300,
                            child: Center(
                              child: postViewModel.displayPostImages(context, allPosts[index].imageUrl!),
                            ),
                          ) ,
                          const SizedBox(height: 5.0,),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (allPosts[index].isLiked!) {
                                      allPosts[index].isLiked = false;
                                      allPosts[index].likedByList!.remove(userId!);
                                    } else {
                                      allPosts[index].isLiked = true;
                                      allPosts[index].likedByList!.add(userId!);
                                    }
                                    postViewModel.likeUnLikePost(allPosts[index]);
                                    likesViewModel.getMyLikedPostsAlone();
                                  });
                                },
                                icon: allPosts[index].likedByList.contains(userId)
                                    ? const Icon(Icons.favorite,color: Colors.red,)
                                    : const Icon(Icons.favorite_outline_rounded),
                              ),
                              IconButton(
                                onPressed: () {
                                  postViewModel.showComments(context, allPosts[index]);
                                },
                                icon: const Icon(Icons.comment_bank_outlined),
                              ),
                              IconButton(
                                onPressed: () async{
                                  await sharePostsViewModel.loadAllAvailableUsers();
                                  showUserMessageSharing(context, allPosts[index]);
                                },
                                icon: const Icon(Icons.send_outlined),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5.0,),
                          Obx(() => Text("${allPosts[index]!.likedByList.length} likes", style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),)),
                          const SizedBox(height: 10.0,),
                          Text(
                            allPosts[index].description!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 15.0,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                          const SizedBox(height: 5.0),
                        ],
                      ),
                    ),
                  );
                }
                else if(postViewModel.isAllPostLoaded.isFalse){
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.red,),
                  );
                }
                else {
                  return const Center(
                    child: Text("No feed to load.", style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                      fontFamily: 'OpenSans',
                    )),
                  );
                }
              },
            ) : const Center(
                  child: Text("No feed to load, be first to add a new post into our application",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                        fontFamily: 'OpenSans',
                  )),
                ),
          ),
        )
    );
  }

  Future showUserMessageSharing(BuildContext context, Posts post){
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        bool doUserExist = sharePostsViewModel.availableUserList.value.isNotEmpty;
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,),
          child: Container(
            margin: const EdgeInsets.all(20.0),
            width: ResponsiveBreakpoints.of(context).isDesktop
                ? ResponsiveBreakpoints.of(context).screenWidth * 0.6
                : ResponsiveBreakpoints.of(context).isTablet
                ? ResponsiveBreakpoints.of(context).screenWidth * 0.9
                : ResponsiveBreakpoints.of(context).screenWidth,
            height: doUserExist
                ? ResponsiveBreakpoints.of(context).screenHeight * 0.5
                : ResponsiveBreakpoints.of(context).screenHeight * 0.2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SingleChildScrollView(
                    child: doUserExist ?
                    showUsersListForPostSharing(post) :
                    const Center(
                      child: Text(
                        "No one’s here to see your awesome post… yet!",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    )
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget showUsersListForPostSharing(Posts post) {
    RxList<bool> isSelectedList = List<bool>.filled(sharePostsViewModel.availableUserList.value.length, false).obs;

    return Container(
      height: ResponsiveBreakpoints.of(context).screenHeight / 2,
      width: ResponsiveBreakpoints.of(context).isMobile ?
              ResponsiveBreakpoints.of(context).screenWidth :
              ResponsiveBreakpoints.of(context).screenWidth / 3,
      child: Column(
        children: [
          const Text("Share your liked posts to loved ones",style: TextStyle(
            color: Colors.purple,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),),
          const Divider(thickness: 2.0,),
          Container(
            height: ResponsiveBreakpoints.of(context).screenHeight * 0.3,
            margin: const EdgeInsets.all(5.0),
            child: Obx(() => ListView.builder(
                itemCount: sharePostsViewModel.availableUserList.value.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          isSelectedList[index] = !isSelectedList[index];
                          if (isSelectedList[index]) {
                            sharePostsViewModel.selectedUsersList.value.add(sharePostsViewModel.availableUserList[index].userId);
                          } else {
                            sharePostsViewModel.selectedUsersList.value.remove(sharePostsViewModel.availableUserList[index].userId);
                          }
                        },
                        leading: const Icon(Icons.person,color: Colors.purpleAccent,),
                        title: Text(sharePostsViewModel.availableUserList[index].userId,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        trailing: Obx(() => Checkbox(
                          value: isSelectedList[index],
                          onChanged: (bool? value) {
                            isSelectedList[index] = value!;
                            if (value) {
                              sharePostsViewModel.selectedUsersList.value.add(sharePostsViewModel.availableUserList[index].userId);
                            } else {
                              sharePostsViewModel.selectedUsersList.value.remove(sharePostsViewModel.availableUserList[index].userId);
                            }
                          },
                          activeColor: Colors.black,
                          checkColor: const Color(0xFFfb6f92),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        )),
                      ),
                      const SizedBox(height: 5.0,),
                      const Divider(thickness: 2.0,),
                    ],
                  );
                }
                )
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(5.0),
            child: MaterialButton(
              color: const Color(0xFFfb6f92),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
              onPressed: () async{
                ToastContext().init(context);
                if(isSelectedList.value.isNotEmpty){
                    await sharePostsViewModel.sendPostMessage(userId!, sharePostsViewModel.selectedUsersList.value, post);
                    CustomToast.showToast(context: context,
                        message: "Post shared successfully",
                        backgroundColor: Colors.green);
                    Navigator.pop(context);
                }
                else{
                  CustomToast.showToast(context: context, message: "Please select anyone to share the post", backgroundColor: Colors.red);
                }
              },
              child: const Text("Share", style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontFamily: "OpenSans",
                fontWeight: FontWeight.bold,
              ),),
            ),
          )
        ],
      ),
    );
  }
}
