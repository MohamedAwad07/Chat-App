import 'package:chat_app/features/Auth/data/model/user_model.dart';

abstract class AuthStates {}

class AuthInitial extends AuthStates {}

class AuthLoading extends AuthStates {}

class Authenticated extends AuthStates {
  final CurrentUserInfo user;
  Authenticated({required this.user});
}

class Unauthenticated extends AuthStates {
  final String errorMessage;
  Unauthenticated({required this.errorMessage});
}

class LoginLoading extends AuthStates {}

class LoginWithEmailAndPasswordSuccess extends AuthStates {
  final CurrentUserInfo userInfo;
  LoginWithEmailAndPasswordSuccess({required this.userInfo});
}

class LoginWithEmailAndPasswordError extends AuthStates {
  final String errorMessage;
  LoginWithEmailAndPasswordError({required this.errorMessage});
}

class LoginWithGoogleSuccess extends AuthStates {
  final CurrentUserInfo userInfo;
  LoginWithGoogleSuccess({required this.userInfo});
}

class LoginWithGoogleError extends AuthStates {
  final String errorMessage;
  LoginWithGoogleError({required this.errorMessage});
}

class RegisterNewUserLoading extends AuthStates {}

class RegisterNewUserSuccess extends AuthStates {
  final CurrentUserInfo userInfo;
  RegisterNewUserSuccess({required this.userInfo});
}

class RegisterNewUserError extends AuthStates {
  final String errorMessage;
  RegisterNewUserError({required this.errorMessage});
}

class ResetPasswordLoading extends AuthStates {}

class ResetPasswordSuccess extends AuthStates {}

class ResetPasswordError extends AuthStates {}

class TogglePasswordVisibility extends AuthStates {}

class ToggleCheckBoxState extends AuthStates {}
