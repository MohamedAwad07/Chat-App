import 'package:chat_app/core/utils/app_assets.dart';
import 'package:chat_app/core/utils/app_colors.dart';
import 'package:chat_app/features/Auth/presentation/controller/auth_cubit.dart';
import 'package:chat_app/features/Auth/presentation/controller/auth_states.dart';
import 'package:chat_app/features/Auth/presentation/views/Widgets/custom_action_button.dart';
import 'package:chat_app/features/Auth/presentation/views/Widgets/custom_login_options_button.dart';
import 'package:chat_app/features/Auth/presentation/views/Widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is LoginWithEmailAndPasswordError || state is LoginWithGoogleError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                (state as dynamic).errorMessage,
              ),
            ),
          );
        }else if (state is ResetPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                "Password reset email sent successfully",
              ),
            ),
          );
        } else if (state is ResetPasswordError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                "Failed to send password reset email",
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return Form(
            key: formKey,
            child: Column(
              spacing: 16,
              children: [
                CustomTextFormField(
                  autoFocus: true,
                  keyboardType: TextInputType.emailAddress,
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
                CustomTextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  suffixIcon: AuthCubit.get(context).suffix,
                  obscureText: AuthCubit.get(context).isPassword,
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
                      value: AuthCubit.get(context).isChecked,
                      onChanged: (value) {
                        AuthCubit.get(context).changeCheckBox();
                      },
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
                                backgroundColor: Colors.red,
                                content: Text("Please enter your email"),
                              ),
                            );
                            return;
                          }
                          context.read<AuthCubit>().resetPassword(email: emailController.text.trim());
                        }
                      },
                      child: state is ResetPasswordLoading
                          ? Center(child: CircularProgressIndicator())
                          : Text(
                              "Forgot Password?",
                              style: GoogleFonts.inter(
                                color: AppColors.blue,
                              ),
                            ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                state is LoginLoading
                    ? Center(child: CircularProgressIndicator())
                    : CustomActionButton(
                        text: "Log In",
                        onPressed: state is LoginLoading
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  AuthCubit.get(context).loginWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
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
                        'or continue with',
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
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
                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomLoginOptions(
                        text: 'Continue with Google',
                        imagePath: Assets.assetsImagesGoogle,
                        onPressed: () async {
                          {
                            AuthCubit.get(context).loginWithGoogle();
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 24,
                      child: VerticalDivider(
                        color: Colors.black,
                        thickness: 2,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: CustomLoginOptions(
                        text: 'Continue with Facebook',
                        imagePath: Assets.assetsImagesFacebook,
                        onPressed: () {
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Coming Soon"),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ));
      },
    );
  }
}
