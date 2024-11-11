import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List<IconData> iconList = [
  Icons.home,
  Icons.chat_bubble_outline,
  Icons.favorite_outlined,
  Icons.person,
];

String convertStringToObsecureString(String value){
  return "*" * value.length;
}

getTodaysDate(){
  return DateTime.now().toString().split(" ")[0];
}

List<String> convertStringToList(String value){
  List<String> resultList = [];
  resultList.add(value);
  return resultList;
}

List<String> getStringList(List<dynamic> listValues){
  List<String> filesList = [];
  listValues.forEach((value){
    filesList.add(value);
  });
  return filesList;
}

Future<String> convertImageToBaseUrl(String imageUrl) async{
  File imageFile = File(imageUrl);
  Uint8List bytes = await imageFile.readAsBytes();
  return base64.encode(bytes);
}

Future<List<String>> convertImageListToBaseUrlList(List imageUrlList) async{
  List<String> resultImgList = [];
  imageUrlList.forEach((imageUrl) async {
    File imageFile = File(imageUrl);
    Uint8List bytes = await imageFile.readAsBytes();
    resultImgList.add(base64.encode(bytes));
  });
  return resultImgList;
}