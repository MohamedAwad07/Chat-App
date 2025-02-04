import 'package:chat_app/features/Auth/data/repos/repos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

class ServiceLocator {
  static void init() {
    // Register Singleton Instances
    _registerSingletons();

    // Register Cubits
    _registerCubits();

    // Register Core Dependencies
    _registerCore();
  }

  static void _registerSingletons() {
    sl.registerLazySingleton<AuthService>(() => AuthServiceImpl(
          auth: sl<FirebaseAuth>(),
          firestore: sl<FirebaseFirestore>(),
        ));
  }

  static void _registerCubits() {}

  static void _registerCore() {
    sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  }
}
