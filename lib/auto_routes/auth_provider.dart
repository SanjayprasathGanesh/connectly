import 'package:get/get.dart';

class AuthProvider extends GetxController{
  RxBool isLoggedIn = false.obs;

  bool get getIsLoggedIn => isLoggedIn.value;

  void login(){
    isLoggedIn.value = true;
  }

  void logout(){
    isLoggedIn.value = false;
  }
}