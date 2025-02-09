import 'package:chat_app/features/Auth/presentation/controller/auth_cubit.dart';
import 'package:chat_app/features/Auth/presentation/controller/auth_states.dart';
import 'package:chat_app/features/Auth/presentation/views/auth_screens.dart';
import 'package:chat_app/features/home/presentation/views/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/core/service%20locator/service_locator.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<AuthCubit>()..checkAuthState(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<AuthCubit, AuthStates>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is Authenticated) {
              return const CustomDrawer();
            } else {
              return const AuthScreen();
            }
          },
        ),
      ),
    );
  }
}
