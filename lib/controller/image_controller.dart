import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

import '../view/widgets/custom_dialog.dart';

class ImageController extends GetxController{
  RxList selectedImagesList = [].obs;

  Future<bool> requestPermission() async{
    if (kIsWeb) {
      return true;
    }else {
      var status = await Permission.storage.status;
      if (status.isProvisional || status.isDenied) {
        var result = await [Permission.storage].request();
        if (result[Permission.storage] == PermissionStatus.granted) {
          Logger().i("Permission granted to access local storage");
          return true;
        } else if (result[Permission.storage] == PermissionStatus.denied) {
          Logger().i("Permission denied to access local storage");
          return false;
        }
      } else if (status.isPermanentlyDenied) {
        Logger().i("Permission denied permanently to access local storage");
        return false;
      }
      return true;
    }
  }

  pickImagesToPost() async {
    selectedImagesList.clear();
    bool isGranted = await requestPermission();

    if (isGranted) {
      ImagePicker imagePicker = ImagePicker();
      final List<XFile> pickedFile = await imagePicker.pickMultiImage();

      if (pickedFile != null) {
        List<String> imagePaths = pickedFile.map((XFile image) => image.path).toList();
        selectedImagesList.addAll(imagePaths);
        Logger().i("Selected image paths: $selectedImagesList");
      } else {
        Logger().w("No images selected.");
      }
    } else {
      CustomDialog.showCustomDialog(title: "Permission not granted", subTitle: "Permission not granted to access gallery for image post.");
      Logger().w("Permission not granted to access gallery.");
    }
  }

  Widget showSelectedImageVideo(BuildContext context) {
    return Container(
      height: 300,
      child: Obx(() {
        var imagesList = selectedImagesList;
        if (imagesList.isEmpty) {
          return const Center(
              child: Text("Please select images to post.", style: TextStyle(
                color: Colors.pinkAccent,
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
                fontFamily: 'OpenSans',
              ),)
          );
        } else if (imagesList.length == 1) {
          return Card(
            child: kIsWeb
                ? Image.network(imagesList[0], fit: BoxFit.contain,)
                : Image.file(File(imagesList[0]), fit: BoxFit.contain,),
          );
        } else {
          return CarouselSlider(
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
          );
        }
      }),
    );
  }
}