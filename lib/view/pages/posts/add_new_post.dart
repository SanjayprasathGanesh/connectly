import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:connectly/auto_routes/app_routes.gr.dart';
import 'package:connectly/database/database_connection.dart';
import 'package:connectly/view/widgets/custom_toast.dart';
import 'package:connectly/view_model/posts/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:toast/toast.dart';

import '../../../view_model/posts/user_profile_view_model.dart';
import '../../widgets/text_field.dart';

@RoutePage()
class AddNewPost extends StatefulWidget {
  const AddNewPost({super.key});

  @override
  State<AddNewPost> createState() => _AddNewPostState();
}

class _AddNewPostState extends State<AddNewPost> {
  final _key = GlobalKey<FormState>();
  PostViewModel postViewModel = Get.find<PostViewModel>();
  final UserProfileViewModel userProfileViewModel = Get.find<UserProfileViewModel>();
  TextEditingController description = TextEditingController();
  TextEditingController location = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool value){
          description.clear();
          location.clear();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add New Post", style: TextStyle(
            color: Colors.black,
            fontFamily: "OpenSans",
            fontWeight: FontWeight.bold,
          ),),
          backgroundColor: const Color(0xFFfb6f92),
        ),
        body: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
          ),
          width: ResponsiveBreakpoints.of(context).isDesktop ?
                    ResponsiveBreakpoints.of(context).screenWidth * 0.7 :
                    ResponsiveBreakpoints.of(context).isTablet ?
                    ResponsiveBreakpoints.of(context).screenWidth * 0.8 : ResponsiveBreakpoints.of(context).screenWidth,
          height: ResponsiveBreakpoints.of(context).isDesktop ?
                    ResponsiveBreakpoints.of(context).screenHeight * 0.7 :
                    ResponsiveBreakpoints.of(context).isTablet ?
                    ResponsiveBreakpoints.of(context).screenHeight * 0.8 : ResponsiveBreakpoints.of(context).screenHeight,
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
                children: [
                  Container(
                    height: 300,
                    child: Obx(() => postViewModel.selectedImgList.isEmpty
                        ? GestureDetector(
                            onTap: () {
                              postViewModel.selectImageToPost();
                            },
                            child: const Center(
                                child: Text("Tap here to select an Image to Post",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'OpenSans',
                                    fontSize: 17.0,
                                  ),
                                )
                            ),
                          )
                        : postViewModel.displaySelectedImages(context)),
                  ),
                  MaterialButton(
                      color: const Color(0xFFfb6f92),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      onPressed: (){
                        postViewModel.selectImageToPost();
                      },
                      child: const Text("Select Images",style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),),
                  ),
                  const SizedBox(height: 10.0,),
                  MyTextField(
                    controller: location, title: "Enter the location * ",
                    showIcon: false, showPsw: false,
                    textInputType: TextInputType.text, readOnly: false,
                    showLoginIcon: false, maxLines: 1,
                    validator: ValidationBuilder(
                        requiredMessage: "Location should be provided for new post."
                    ).minLength(5).maxLength(30).build(),
                  ),
                  const SizedBox(height: 10.0,),
                  MyTextField(
                    controller: description, title: "Enter your Post description * ",
                    showIcon: false, showPsw: false,
                    textInputType: TextInputType.text, readOnly: false,
                    showLoginIcon: false, maxLines: 3,
                    validator: ValidationBuilder(
                        requiredMessage: "Description should be provided for new post."
                    ).minLength(5).maxLength(200).build(),
                  ),
                  const SizedBox(height: 10.0,),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        color: Colors.green,
                        onPressed: (){
                          if(_key.currentState!.validate() && postViewModel.selectedImgList.value.isNotEmpty){
                            postViewModel.addNewPost(description.text, location.text);
                            description.clear();
                            location.clear();

                            ToastContext().init(context);
                            CustomToast.showToast(context: context, message: "New Post Added successfully.", backgroundColor: Colors.green);

                            context.router.popUntilRouteWithName(MainRoute.name);
                            userProfileViewModel.loadPostsForUser();
                          } else if(postViewModel.selectedImgList.value.isEmpty){
                             ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please select any image to post a new feed.",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text("Post", style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontFamily: "OpenSans",
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
