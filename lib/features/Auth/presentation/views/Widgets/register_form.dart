import 'package:chat_app/features/Auth/presentation/views/Widgets/custom_action_button.dart';
import 'package:chat_app/features/Auth/presentation/views/Widgets/custom_login_options_button.dart';
import 'package:chat_app/features/Auth/presentation/views/Widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.onPressed,
    required this.usernameController,
  });
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController usernameController;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 16,
        children: [
          CustomTextFormField(
            labelText: 'Username',
            hintText: 'Example123',
            controller: usernameController,
          ),
          CustomTextFormField(
            labelText: 'Email',
            hintText: 'example@gmail.com',
            controller: emailController,
          ),
          CustomTextFormField(
            labelText: 'Password',
            hintText: 'Enter your password',
            obscureText: true,
            controller: passwordController,
          ),
          SizedBox(
            height: 8,
          ),
          // Login Button
          CustomActionButton(
            text: "Register",
            onPressed: onPressed,
          ),
          SizedBox(
            height: 8,
          ),
          Column(
            spacing: 24,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomLoginOptions(
                text: 'Continue with Google',
                imagePath: 'assets/images/Google.svg',
                onPressed: () {},
              ),
              CustomLoginOptions(
                text: 'Continue with Facebook',
                imagePath: 'assets/images/Facebook.svg',
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
