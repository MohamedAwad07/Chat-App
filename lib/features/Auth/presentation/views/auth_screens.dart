import 'package:chat_app/core/service%20locator/service_locator.dart';
import 'package:chat_app/features/Auth/data/repos/repos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/features/Auth/presentation/views/Widgets/custom_text_button.dart';
import 'package:chat_app/features/Auth/presentation/views/Widgets/fixed_header.dart';
import 'package:chat_app/features/Auth/presentation/views/Widgets/login_form.dart'; // Assuming this is the login form widget
import 'package:chat_app/features/Auth/presentation/views/Widgets/register_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _loginFormKey = GlobalKey<FormState>(); // Separate key for login
  final _registerFormKey = GlobalKey<FormState>(); // Separate key for registration
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final authService = AuthServiceImpl(auth: sl.get<FirebaseAuth>(), firestore: sl.get<FirebaseFirestore>());

  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF03242d),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login-background.jpeg'),
            alignment: Alignment.topCenter,
          ),
        ),
        child: Column(
          children: [
            FixedHeader(),
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xfff5f6f9),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
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
                          SizedBox(width: 10),
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
                            onPressed: () async {
                              if (_loginFormKey.currentState!.validate()) {
                                try {
                                  await authService.loginWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                } catch (e) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(e.toString()),
                                    ),
                                  );
                                }
                              }
                            },
                            formKey: _loginFormKey,
                            emailController: emailController,
                            passwordController: passwordController,
                          )
                        : RegisterForm(
                            onPressed: () async {
                              if (_registerFormKey.currentState!.validate()) {
                                if (passwordController.text != confirmPasswordController.text) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Passwords do not match'),
                                    ),
                                  );
                                  return;
                                }
                                try {
                                  await authService.registerWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    username: usernameController.text,
                                  );
                                } catch (e) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(e.toString()),
                                    ),
                                  );
                                }
                              }
                            },
                            formKey: _registerFormKey,
                            usernameController: usernameController,
                            emailController: emailController,
                            passwordController: passwordController,
                            confirmPasswordController: confirmPasswordController,
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
