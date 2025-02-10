import 'package:chat_app/core/service%20locator/service_locator.dart';
import 'package:chat_app/features/Auth/data/model/user_model.dart';
import 'package:chat_app/features/Auth/data/repos/repos.dart';
import 'package:chat_app/features/Auth/presentation/controller/auth_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthStates> {
  final AuthService authService;
  AuthCubit({required this.authService}) : super(AuthInitial());

  CurrentUserInfo? currentUser;
  static AuthCubit get(context) => BlocProvider.of(context);
  
  void checkAuthState() {
    emit(AuthLoading());
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser != null) {
        var userDoc = await sl<FirebaseFirestore>().collection('users').doc(firebaseUser.uid).get();

        String username = userDoc['username'];

        currentUser = CurrentUserInfo.fromJson(firebaseUser, username: username);

        emit(Authenticated(user: currentUser!));
      } else {
        emit(Unauthenticated(errorMessage: 'User is not logged in'));
      }
    });
  }

  Future<void> loginWithGoogle() async {
    try {
      emit(LoginLoading());

      final response = await authService.loginWithGoogle();
      response.fold(
          (failure) => emit(
                LoginWithGoogleError(
                  errorMessage: failure.toString(),
                ),
              ), (user) {
        currentUser = user;
        // emit(
        //   Authenticated(user: user),
        // );
      });
    } catch (e) {
      emit(
        LoginWithGoogleError(
          errorMessage: 'An unexpected error occurred: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> loginWithEmailAndPassword({required String email, required String password}) async {
    try {
      emit(LoginLoading());
      final response = await authService.loginWithEmailAndPassword(email: email, password: password);
      response.fold(
          (failure) => emit(
                LoginWithEmailAndPasswordError(
                  errorMessage: failure.toString(),
                ),
              ), (user) {
        currentUser = user;
        // emit(
        //   Authenticated(user: user),
        // );
      });
    } catch (e) {
      emit(
        LoginWithGoogleError(
          errorMessage: 'An unexpected error occurred: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> register({required String email, required String password, required String username}) async {
    emit(RegisterNewUserLoading());
    final response = await authService.registerWithEmailAndPassword(email: email, password: password, username: username);
    response.fold(
        (failure) => emit(
              RegisterNewUserError(
                errorMessage: failure.toString(),
              ),
            ), (user) {
      currentUser = user;
      // emit(
      //   Authenticated(user: user),
      // );
    });
  }

  Future<void> resetPassword({required String email}) async {
    try {
      emit(ResetPasswordLoading());
      await authService.resetPassword(email: email);
      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(ResetPasswordError());
    }
  }

  IconData suffix = Icons.visibility_off;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_off : Icons.visibility;
    emit(TogglePasswordVisibility());
  }

  bool isChecked = false;

  void changeCheckBox() {
    isChecked = !isChecked;
    emit(ToggleCheckBoxState());
  }

  Future<void> logout() async {
    await authService.logout();
    emit(LogoutSuccess());
  }
}
