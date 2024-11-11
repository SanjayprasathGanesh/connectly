import 'package:connectly/model/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:form_validator/form_validator.dart';
import 'package:logger/logger.dart';
import '../../view/widgets/text_field.dart';
import '../controller/local_login_storage.dart';
import '../database/database_connection.dart';

class LoginPageViewModel extends GetxController{
  TextEditingController userId = TextEditingController();
  TextEditingController psw = TextEditingController();

  TextEditingController signupUserId = TextEditingController();
  TextEditingController signupPsw = TextEditingController();
  TextEditingController signupCpsw = TextEditingController();

  LocalLoginStorage credentials = LocalLoginStorage();
  DatabaseConnection databaseConnection = DatabaseConnection();

  Widget buildLoginForm(){
    return Column(
      children: [
        MyTextField(
          controller: userId,
          title: 'Enter your UserId',
          showIcon: false,
          showPsw: false,
          textInputType: TextInputType.text,
          readOnly: false,
          validator: ValidationBuilder(requiredMessage: 'UserId field should not be blank.')
              .minLength(6)
              .maxLength(15)
              .build(),
          maxLines: 1,
          showLoginIcon: true,
          loginIcon: const Icon(Icons.person_outline),
        ),
        const SizedBox(height: 10.0,),
        MyTextField(
          controller: psw,
          title: 'Enter your Password',
          showIcon: true,
          showPsw: true,
          textInputType: TextInputType.visiblePassword,
          validator: ValidationBuilder(requiredMessage: 'Password Field should not be blank.')
              .minLength(5)
              .maxLength(16)
              .build(),
          maxLines: 1,
          showLoginIcon: true,
          loginIcon: const Icon(Icons.password),
          readOnly: false,
        ),
      ]
    );
  }

  Widget buildSignupForm(){
    return Column(
        children: [
          MyTextField(
            controller: signupUserId,
            title: 'Enter your UserId',
            showIcon: false,
            showPsw: false,
            textInputType: TextInputType.text,
            readOnly: false,
            validator: ValidationBuilder(requiredMessage: 'UserId field should not be blank.')
                .minLength(6)
                .maxLength(15)
                .build(),
            maxLines: 1,
            showLoginIcon: true,
            loginIcon: const Icon(Icons.person_outline),
          ),
          const SizedBox(height: 10.0,),
          MyTextField(
            controller: signupPsw,
            title: 'Enter your Password',
            showIcon: true,
            showPsw: true,
            textInputType: TextInputType.visiblePassword,
            validator: ValidationBuilder(requiredMessage: 'Password Field should not be blank.')
                .minLength(5)
                .maxLength(16)
                .build(),
            maxLines: 1,
            showLoginIcon: true,
            loginIcon: const Icon(Icons.password),
            readOnly: false,
          ),
          const SizedBox(height: 10.0,),
          MyTextField(
            controller: signupCpsw,
            title: 'Confirm your Password',
            showIcon: true,
            showPsw: true,
            textInputType: TextInputType.visiblePassword,
            validator: ValidationBuilder(requiredMessage: 'Confirm Password Field should not be blank.')
                .minLength(5)
                .maxLength(16)
                .build(),
            maxLines: 1,
            showLoginIcon: true,
            loginIcon: const Icon(Icons.password_sharp),
            readOnly: false,
          ),
        ]
    );
  }

  setUserCredentials() async {
    Map<String, String?> json = await credentials.getLoginCredentials();
    userId.text = json['username'] ?? '';
    psw.text = json['password'] ?? '';
    print('User credentials set in login page.');
  }

  userLogin() async{
    bool canUserLogin = await databaseConnection.validateUserLogin(userId.text, psw.text);
    print("Is User Exist : $canUserLogin");
    if(canUserLogin){
      await credentials.saveLoginCredentials(userId.text, psw.text);
      return true;
    }
    return false;
  }

  userSignUp() async{
    bool doUserExist = await databaseConnection.checkUserExist(signupUserId.text);
    if(!doUserExist){
      await credentials.saveLoginCredentials(signupUserId.text, signupPsw.text);
      User user = User(userId: signupUserId.text, userPsw: signupPsw.text);
      await databaseConnection.addNewUser(user);
      return true;
    }
    return false;
  }

  clearSignupFields(){
    signupUserId.clear();
    signupPsw.clear();
    signupCpsw.clear();
  }
}