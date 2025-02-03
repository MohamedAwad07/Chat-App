import 'package:chat_app/core/utils/app_colors.dart';
import 'package:chat_app/features/Auth/presentation/views/Widgets/custom_action_button.dart';
import 'package:chat_app/features/Auth/presentation/views/Widgets/custom_login_options_button.dart';
import 'package:chat_app/features/Auth/presentation/views/Widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
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
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 16,
        children: [
          // Email Input Field
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
                onPressed: () {},
                child: Text(
                  "Forgot Password?",
                  style: GoogleFonts.inter(
                    color: AppColors.blue,
                  ),
                ),
              ),
            ],
          ),

          // Login Button
          CustomActionButton(
            text: "Log In",
            onPressed: onPressed,
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
