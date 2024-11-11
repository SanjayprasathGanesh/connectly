import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectly/controller/image_controller.dart';
import 'package:connectly/database/database_connection.dart';
import 'package:connectly/view_model/posts/share_posts_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:toast/toast.dart';

import '../../controller/local_login_storage.dart';
import '../../model/posts/posts_model.dart';
import '../../services/common_methods.dart';
import '../../view/widgets/custom_toast.dart';
import '../../view/widgets/text_field.dart';

class PostViewModel extends GetxController{
  DatabaseConnection databaseConnection = DatabaseConnection();
  final ImageController imageController = Get.find<ImageController>();
  final SharePostsViewModel sharePostsViewModel = Get.find<SharePostsViewModel>();
  final LocalLoginStorage credentials = Get.find<LocalLoginStorage>();

  Rx<TextEditingController> comments = Rx<TextEditingController>(TextEditingController());
  RxList selectedImgList = [].obs;

  RxList allPostsList = [].obs;
  RxList allPostIdsList = [].obs;
  RxBool isAllPostLoaded = false.obs;

  RxList selectedUsersList = [].obs;

  selectImageToPost() async{
    await imageController.pickImagesToPost();
    selectedImgList.value = imageController.selectedImagesList.value;
    Logger().i("after selecting from gal : ${selectedImgList.value}");
  }

  Widget displaySelectedImages(BuildContext context){
    imageController.selectedImagesList.value = selectedImgList.value;
    Logger().i("Display image : ${selectedImgList.value} - ${imageController.selectedImagesList.value}");
    if(imageController.selectedImagesList.value.isNotEmpty) {
      return imageController.showSelectedImageVideo(context);
    }
    else{
      return const Center(child: Text("No images selected"),);
    }
  }

  Widget displayPostImages(BuildContext context, List<String> imagesList) {
    return Container(
      height: 300,
      child: imagesList.isEmpty
          ? const Center(
            child: Text("Sorry no images to load.",style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              color: Colors.purpleAccent,
              fontFamily: 'OpenSans',
            ),))
          : imagesList.length == 1
          ? Card(
              child: kIsWeb
                  ? Image.network(
                imagesList[0],
                fit: BoxFit.contain,
              ) : Image.file(
                File(imagesList[0]),
                fit: BoxFit.contain,
              ),
      )
          : CarouselSlider(
              items: imagesList.map((imagePath) {
                return Container(
                  margin: const EdgeInsets.all(5.0),
                  child: kIsWeb
                      ? Image.network(imagePath, fit: BoxFit.contain)
                      : Image.file(File(imagePath), fit: BoxFit.contain),
                );
              }).toList(),
              options: CarouselOptions(
                height: 400.0,
                enlargeCenterPage: true,
                autoPlay: false,
                aspectRatio: 16 / 9,
                enableInfiniteScroll: false,
                viewportFraction: 0.8,
              ),
            ),
    );
  }

  Future showComments(BuildContext context, Posts post) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        bool isNoCmts = post.commentsList.isEmpty;
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,),
          child: Container(
            margin: const EdgeInsets.all(20.0),
            width: ResponsiveBreakpoints.of(context).isDesktop
                ? ResponsiveBreakpoints.of(context).screenWidth * 0.6
                : ResponsiveBreakpoints.of(context).isTablet
                ? ResponsiveBreakpoints.of(context).screenWidth * 0.9
                : ResponsiveBreakpoints.of(context).screenWidth,
            height: isNoCmts
                ? ResponsiveBreakpoints.of(context).screenHeight * 0.2
                : ResponsiveBreakpoints.of(context).screenHeight * 0.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SingleChildScrollView(
                  child: isNoCmts
                      ? const Center(
                          child: Text(
                            "Be the first to post a comment for this post",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                  )
                      : showCommentsList(post),
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyTextField(
                        controller: comments.value,
                        title: "Share your comment",
                        showIcon: false,
                        showPsw: false,
                        textInputType: TextInputType.text,
                        readOnly: false,
                        showLoginIcon: false,
                        validator: ValidationBuilder(
                            requiredMessage: "Type some comments to post")
                            .minLength(1)
                            .maxLength(50)
                            .build(),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    IconButton(
                      color: const Color(0xFFfb6f92),
                      onPressed: () {
                        ToastContext().init(context);
                        if(comments.value.text.isNotEmpty) {
                          addNewComment(post);
                          CustomToast.showToast(
                            context: context,
                            message: "Comment added to the post successfully",
                            backgroundColor: Colors.green,
                          );
                          Navigator.pop(context);
                        } else{
                          CustomToast.showToast(
                            context: context,
                            message: "Blank comments can't be commented.",
                            backgroundColor: Colors.red,
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.comment_bank_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget showCommentsList(Posts post) {
    final comments = post.commentsList;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("User comments", style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
          fontFamily: 'OpenSans',
        ),),
        const Divider(height: 2.0,),
        SizedBox(
          height: 260,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final commentMap = comments[index];
              final username = commentMap?.keys.first;
              final comment = commentMap?.values.first;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(username!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(comment!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> addNewPost(String description, String location) async{
    String userId = await credentials.getUserName() ?? '';
    Posts posts = Posts(
          userId: userId, postedDate: getTodaysDate(), postType: "Image",
          description: description, imageUrl:  getStringList(selectedImgList.value),
          location: location, isLiked: false,
          likedByList: [], commentsList: []);
    allPostsList.value.add(posts);
    databaseConnection.addNewPost(posts);
    await getAllPosts();
    Logger().i("New post Added Successfully.");
  }


  Future<void> getAllPosts() async{
    QuerySnapshot querySnapshot = await databaseConnection.getAllPosts();
    List<Posts> postsList = [];
    List<String> idsList = [];
    Posts posts;
    Map<String, dynamic> json = {};
    for(int i = 0; i < querySnapshot.size;i++){
      json = querySnapshot.docs[i].data() as Map<String, dynamic>;
      posts = Posts.fromJson(json);
      postsList.add(posts);
      idsList.add(querySnapshot.docs[i].id);
    }
    allPostsList.value = postsList;
    allPostIdsList.value = idsList;
    isAllPostLoaded.value = true;
  }

  likeUnLikePost(Posts post) async{
    int index = allPostsList.value.indexOf(post);
    String docId = allPostIdsList.value[index];
    if(docId != "") {
      await databaseConnection.updatePost(docId, post);
      Logger().i("Liked for docId : $docId");
    } else{
      Logger().i("Doc is returned as empty.");
    }
  }

  addNewComment(Posts post) async{
    int index = allPostsList.value.indexOf(post);
    String docId = allPostIdsList.value[index];
    String userId = await credentials.getUserName() ?? '';
    if(docId != "") {
      post.commentsList.add({
        userId: comments.value.text,
      });
      await databaseConnection.updatePost(docId, post);
      await getAllPosts();
      comments.value.clear();
      Logger().i("Commented for docId : $docId");
    } else{
      Logger().i("Doc is returned as empty.");
    }
  }

  //this code is supposed be used to handle the selection of video from gallery and play it
  //not used this because of firebase storage paid plan.
// Future<void> pickVideosToPost() async {
//   postType.value = "Video";
//   final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
//   if (video != null) {
//     if (kIsWeb) {
//       Logger().i("${video.path} yet");
//       videoPlayerController = VideoPlayerController.network(video.path!)
//         ..initialize().then((_) {
//           isVideoInitialized.value = true; // Mark video as initialized
//           videoPlayerController!.play();
//           selectedVideo.value = video.path;
//           update(); // Update UI after playing
//         }).catchError((error) {
//           Logger().e("Error initializing video: $error");
//         });
//     } else {
//       _video = File(video.path);
//       videoPlayerController = VideoPlayerController.file(_video!)
//         ..initialize().then((_) {
//           Logger().i("$video initialized");
//           selectedVideo.value = video.path;
//           isVideoInitialized.value = true;
//           videoPlayerController!.play();
//         });
//     }
//   }
// }

// Future<void> pickVideosToPost() async {
//   postType.value = "Video";
//   Logger().t("selected");
//   final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
//   if (video != null) {
//     Logger().t("if");
//     if (videoPlayerController != null) {
//       Logger().t("2 if");
//       await videoPlayerController!.dispose();
//       videoPlayerController = null;
//       isVideoInitialized.value = false;
//       isVideoPlaying.value = false;
//     }
//
//     _video = File(video.path);
//     Logger().t("Video : ${_video}");
//     videoPlayerController = kIsWeb
//         ? VideoPlayerController.network(video.path)
//         : VideoPlayerController.file(_video!);
//
//     try {
//       Logger().t("try");
//       await videoPlayerController!.initialize();
//       selectedVideo.value = video.path;
//       Logger().t("selectedVideo $selectedVideo");
//       isVideoInitialized.value = true;
//       videoPlayerController!.pause();
//       isVideoPlaying.value = false;
//     } catch (error) {
//       Logger().e("Error initializing video: $error");
//     }
//   } else {
//     Logger().w("No video selected.");
//   }
// }

// Widget showSelectedImageVideo(BuildContext context){
//   return postType.value == 'Image' ? Container(
//     height: 300,
//     child: Obx(() {
//       var imagesList = selectedImagesList;
//       if (imagesList.isEmpty) {
//         return const Center(child: Text("Please select images to post."));
//       }
//       else if(imagesList.length == 1){
//         return Card(
//           child: kIsWeb
//               ? Image.network(imagesList[0], fit: BoxFit.contain, )
//               : Image.file(File(imagesList[0]), fit: BoxFit.contain,),
//         );
//       } else {
//         return CarouselSlider(
//           items: imagesList.map((imagePath) {
//             return Container(
//               margin: const EdgeInsets.all(5.0),
//               child: kIsWeb
//                   ? Image.network(imagePath, fit: BoxFit.contain)
//                   : Image.file(File(imagePath), fit: BoxFit.contain),
//             );
//           }).toList(),
//           options: CarouselOptions(
//             height: 400.0,
//             enlargeCenterPage: true,
//             autoPlay: false,
//             aspectRatio: 16 / 9,
//             enableInfiniteScroll: false,
//             viewportFraction: 0.8,
//           ),
//         );
//       }
//     }),
//   ) : Container(
//     height: 400,
//     child: Obx(() {
//       var videoString = selectedVideo.value;
//       Logger().i("VIDEO STRING : $videoString");
//       Logger().i("INI : ${isVideoInitialized}");
//       if(videoString.isNotEmpty && videoPlayerController!.value.isInitialized){
//         return Stack(
//           children: [
//             Center(
//               child: Container(
//                 width: double.infinity, // Make the video container fit the width
//                 height: double.infinity, // Make the video container fit the height
//                 child: VideoPlayer(videoPlayerController!),
//               ),
//             ),
//             Positioned(
//               top: 200,
//               left: MediaQuery.of(context).size.width / 2 - 50,
//               child: IconButton(
//                 icon: Icon(isVideoPlaying.isTrue
//                     ? Icons.pause
//                     : Icons.play_arrow,
//                   size: 30.0,
//                 ),
//                 onPressed: () {
//                   if (isVideoPlaying.value) {
//                     isVideoPlaying.value = false;
//                     videoPlayerController!.pause();
//                   } else {
//                     isVideoPlaying.value = true;
//                     videoPlayerController!.play();
//                   }
//                   update();
//                 },
//               ),
//             ),
//           ],
//         );
//       } else if(videoString.isEmpty && isVideoInitialized.isTrue){
//         return const Center(child: Text("Please select any video or audio to post."));
//       }
//       return const Center(child: CircularProgressIndicator());
//     }),
//   );
// }
}