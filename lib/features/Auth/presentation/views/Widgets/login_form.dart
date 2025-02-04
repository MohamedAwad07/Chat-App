import 'package:chat_app/core/service%20locator/service_locator.dart';
import 'package:chat_app/core/utils/app_colors.dart';
import 'package:chat_app/features/Auth/data/repos/repos.dart';
import 'package:chat_app/features/Auth/presentation/views/Widgets/custom_action_button.dart';
import 'package:chat_app/features/Auth/presentation/views/Widgets/custom_login_options_button.dart';
import 'package:chat_app/features/Auth/presentation/views/Widgets/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginForm extends StatelessWidget {
  LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.onPressed,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final void Function() onPressed;
  final authService = AuthServiceImpl(auth: sl.get<FirebaseAuth>(), firestore: sl.get<FirebaseFirestore>());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 16,
        children: [
          // Email Input Field with Validation
          CustomTextFormField(
            labelText: 'Email',
            hintText: 'example@gmail.com',
            controller: emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email cannot be empty';
              }
              final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
              if (!emailRegex.hasMatch(value)) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          // Password Input Field with Validation
          CustomTextFormField(
            labelText: 'Password',
            hintText: 'Enter your password',
            obscureText: true,
            controller: passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password cannot be empty';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
          ),
          Row(
            children: [
              Checkbox(
                value: true,
                onChanged: (value) {},
              ),
              Text(
                "Remember me",
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () async {
                  {
                    if (emailController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please enter your email"),
                        ),
                      );
                      return;
                    }
                    await authService.resetPassword(email: emailController.text.trim());
                  }
                },
                child: Text(
                  "Forgot Password?",
                  style: GoogleFonts.inter(
                    color: AppColors.blue,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          // Login Button with Validation Check
          CustomActionButton(
            text: "Log In",
            onPressed: () {
              if (formKey.currentState!.validate()) {
                onPressed();
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Divider(
                  color: Colors.grey[400],
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: Text(
                  'Or',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: Colors.grey[400],
                  thickness: 1,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomLoginOptions(
                text: 'Continue with Google',
                imagePath: 'assets/images/Google.svg',
                onPressed: () async {
                  {
                    await authService.loginWithGoogle();
                  }
                },
              ),
              const SizedBox(height: 8),
              CustomLoginOptions(
                text: 'Continue with Facebook',
                imagePath: 'assets/images/Facebook.svg',
                onPressed: () async {
                  {
                    await authService.loginWithFacebook();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
