import 'package:chat_app/features/Auth/data/repos/repos.dart';
import 'package:chat_app/features/Auth/presentation/controller/auth_cubit.dart';
import 'package:chat_app/features/home/data/repos/repos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

class ServiceLocator {
  static void init() {
    _registerSingletons();

    _registerCubits();

    _registerCore();
  }

  static void _registerSingletons() {
    sl.registerLazySingleton<AuthService>(() => AuthServiceImpl(
          auth: sl<FirebaseAuth>(),
          firestore: sl<FirebaseFirestore>(),
        ));
    sl.registerLazySingleton<ChatService>(() => ChatServiceImpl(
          auth: sl<FirebaseAuth>(),
          firestore: sl<FirebaseFirestore>(),
        ));
  }

  static void _registerCubits() {
    sl.registerFactory<AuthCubit>(() => AuthCubit(authService: sl<AuthService>()));
  }

  static void _registerCore() {
    sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  }
}
