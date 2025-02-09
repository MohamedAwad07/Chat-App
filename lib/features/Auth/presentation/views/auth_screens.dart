import 'package:chat_app/core/utils/app_assets.dart';
import 'package:chat_app/features/Auth/presentation/views/Widgets/custom_text_button.dart';
import 'package:chat_app/features/Auth/presentation/views/Widgets/fixed_header.dart';
import 'package:chat_app/features/Auth/presentation/views/Widgets/login_form.dart';
import 'package:chat_app/features/Auth/presentation/views/Widgets/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/core/service%20locator/service_locator.dart';
import 'package:chat_app/features/Auth/presentation/controller/auth_cubit.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      // Use the instance from the service locator
      value: sl<AuthCubit>(),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                Assets.assetsImagesLoginBackground,
              ),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                FixedHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xfff5f6f9),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              spacing: 10,
                              children: [
                                CustomTextButton(
                                  isWhite: isLogin,
                                  text: "Log In",
                                  onPressed: () {
                                    setState(() {
                                      isLogin = true;
                                    });
                                  },
                                ),
                                CustomTextButton(
                                  isWhite: !isLogin,
                                  text: "Sign Up",
                                  onPressed: () {
                                    setState(() {
                                      isLogin = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),
                          isLogin
                              ? LoginForm(
                                  emailController: emailController,
                                  passwordController: passwordController,
                                  formKey: loginFormKey,
                                )
                              : RegisterForm(
                                  usernameController: usernameController,
                                  emailController: emailController,
                                  passwordController: passwordController,
                                  confirmPasswordController: confirmPasswordController,
                                  formKey: registerFormKey,
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
