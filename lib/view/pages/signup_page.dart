import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:connectly/auto_routes/app_routes.gr.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:toast/toast.dart';

import '../../auto_routes/auth_provider.dart';
import '../../view_model/login_page_view_model.dart';
import '../widgets/custom_toast.dart';


@RoutePage()
class MySignupPage extends StatefulWidget {
  const MySignupPage({super.key});

  @override
  State<MySignupPage> createState() => _MySignupPageState();
}

class _MySignupPageState extends State<MySignupPage> {
  final LoginPageViewModel viewModel = Get.find<LoginPageViewModel>();
  final _key = GlobalKey<FormState>();
  final AuthProvider authProvider = Get.find<AuthProvider>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFcdb4db),
        body: Center(
          child: Card(
            elevation: 200.0,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              width: ResponsiveBreakpoints.of(context).isDesktop
                  ? ResponsiveBreakpoints.of(context).screenWidth * 0.4
                  : ResponsiveBreakpoints.of(context).isTablet
                  ? ResponsiveBreakpoints.of(context).screenWidth * 0.6
                  : ResponsiveBreakpoints.of(context).screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Connectly - A new trend', style: TextStyle(
                        color: Colors.blue,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                      ),),
                      const SizedBox(height: 15.0,),
                      const Text('Signup to create your Daily Feeds....', style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),),
                      const SizedBox(height: 10.0,),
                      viewModel.buildSignupForm(),
                      const SizedBox(height: 10.0,),
                      SizedBox(
                        width: 150.0,
                        child: MaterialButton(
                          onPressed: ()async{
                            ToastContext().init(context);
                            if(_key.currentState!.validate()){
                              if(viewModel.signupPsw.text == viewModel.signupCpsw.text){
                                bool canUserSignup = await viewModel.userSignUp();
                                if(canUserSignup){
                                    authProvider.login();
                                  viewModel.userSignUp();
                                  CustomToast.showToast(context: context, message: 'Signed up successfully.', backgroundColor: Colors.green);
                                  context.router.push(MainRoute());
                                  viewModel.clearSignupFields();
                                }
                                else{
                                  CustomToast.showToast(context: context, message: 'User id already exists, please try with another id', backgroundColor: Colors.red);
                                }
                              }
                              else{
                                CustomToast.showToast(context: context, message: 'Password and confirm password are not same', backgroundColor: Colors.red);
                              }
                            }
                            else{
                              CustomToast.showToast(context: context, message: 'Blank Fields could not be saved as user credentials', backgroundColor: Colors.red);
                            }
                          },
                          color: Colors.green,
                          child: const Text('Signup',style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),),
                        ),
                      ),
                      const SizedBox(height: 15.0,),
                      TextButton(
                        onPressed: (){
                          context.router.push(const MyLoginRoute());
                        },
                        child: const Text('Existing User ? Back to Log In',style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                        ),),
                      ),
                      const SizedBox(height: 10.0,),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }
}




