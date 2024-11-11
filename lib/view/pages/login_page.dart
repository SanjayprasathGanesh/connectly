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
class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final LoginPageViewModel viewModel = Get.find<LoginPageViewModel>();
  final _key = GlobalKey<FormState>();
  final AuthProvider authProvider = Get.find<AuthProvider>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      viewModel.setUserCredentials();
    });
  }

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
                    children: [
                      const Text('Connectly - A new Trend', style: TextStyle(
                        color: Colors.blue,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                      ),),
                      const SizedBox(height: 15.0,),
                      const Text('Login to see the real world...', style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),),
                      const SizedBox(height: 10.0,),
                      viewModel.buildLoginForm(),
                      const SizedBox(height: 10.0,),
                      SizedBox(
                        width: 150.0,
                        child: MaterialButton(
                            onPressed: () async{
                              ToastContext().init(context);
                              if(_key.currentState!.validate()){
                                bool canUserLogin = await viewModel.userLogin();
                                if(!canUserLogin){
                                  CustomToast.showToast(context: context, message: 'Invalid user id or password.', backgroundColor: Colors.red);
                                }
                                else{
                                  setState(() {
                                    authProvider.login();
                                  });
                                  viewModel.userLogin();
                                  CustomToast.showToast(context: context, message: 'Logged in successfully', backgroundColor: Colors.green);
                                  context.router.push(const MainRoute());
                                }
                              }
                              else{
                                CustomToast.showToast(context: context, message: 'Invalid User id or password', backgroundColor: Colors.red);
                              }
                            },
                            color: Colors.green,
                            child: const Text('Login',style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans',
                            ),),
                        ),
                      ),
                      const SizedBox(height: 15.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Text("New user, please sign in to view daily feeds..",style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'OpenSans',
                            ),)
                          ),
                          const SizedBox(height: 10.0,),
                          TextButton(
                            onPressed: (){
                              context.router.push(const MySignupRoute());
                            },
                            child: const Text('Sign up',style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans',
                            ),),
                          ),
                        ],
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




