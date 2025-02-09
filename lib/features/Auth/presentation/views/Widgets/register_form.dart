import 'package:chat_app/features/Auth/presentation/controller/auth_cubit.dart';
import 'package:chat_app/features/Auth/presentation/controller/auth_states.dart';
import 'package:chat_app/features/Auth/presentation/views/Widgets/custom_action_button.dart';
import 'package:chat_app/features/Auth/presentation/views/Widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    super.key,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.formKey,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                state.errorMessage,
              ),
            ),
          );
        } else if (state is RegisterNewUserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                state.errorMessage,
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
                keyboardType: TextInputType.name,
                labelText: 'Username',
                hintText: 'Enter your username',
                controller: usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username cannot be empty';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                keyboardType: TextInputType.emailAddress,
                labelText: 'Email',
                hintText: 'example@gmail.com',
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email cannot be empty';
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
              CustomTextFormField(
                keyboardType: TextInputType.visiblePassword,
                labelText: 'Confirm Password',
                hintText: 'Re-enter your password',
                suffixIcon: AuthCubit.get(context).suffix,
                obscureText: AuthCubit.get(context).isPassword,
                controller: confirmPasswordController,
                validator: (value) {
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              state is RegisterNewUserLoading
                  ? Center(child: CircularProgressIndicator())
                  : CustomActionButton(
                      text: "Register",
                      onPressed: state is RegisterNewUserLoading
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                AuthCubit.get(context).register(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  username: usernameController.text,
                                );
                              }
                            },
                    ),
              SizedBox(height: 1),
            ],
          ),
        );
      },
    );
  }
}
