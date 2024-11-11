import 'package:auto_route/annotations.dart';
import 'package:connectly/view_model/posts/likes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../view_model/posts/post_view_model.dart';

@RoutePage()
class MyLikes extends StatefulWidget {
  const MyLikes({super.key});

  @override
  State<MyLikes> createState() => _MyLikesState();
}

class _MyLikesState extends State<MyLikes> {

  final LikesViewModel likesViewModel = Get.find<LikesViewModel>();
  final PostViewModel postViewModel = Get.find<PostViewModel>();

  Future<void> _refreshPosts() async {
    await likesViewModel.getMyLikedPostsAlone();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshPosts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _refreshPosts();
    });
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
          child: Obx(() =>
            likesViewModel.isAllPostsLoaded.isFalse ?
              const Center(child: CircularProgressIndicator(color: Colors.red,),)
              : likesViewModel.likedPostsLists.isNotEmpty
                ? ListView.builder(
                    itemCount: likesViewModel.likedPostsLists.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var allPosts = likesViewModel.likedPostsLists;
                      if (allPosts.isNotEmpty) {
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
                                const Icon(Icons.favorite,color: Colors.red,),
                                const SizedBox(height: 5.0,),
                                Text("${allPosts[index]!.likedByList.length} likes", style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans',
                                ),),
                                const SizedBox(height: 10.0,),
                                Text(allPosts[index].description!,
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
                      else {
                        return const Center(
                          child: Text("Looks like you haven't liked any posts yet!", style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                            fontFamily: 'OpenSans',
                          )),
                        );
                      }
                    },
                  ) : const Center(
                    child: Text("Looks like you haven't liked any posts yet!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                          fontFamily: 'OpenSans',
                        )
                    ),
                  ),
          ),
        )
    );
  }
}
