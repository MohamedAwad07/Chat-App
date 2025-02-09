import 'package:chat_app/bloc_observer.dart';
import 'package:chat_app/core/service%20locator/service_locator.dart';
import 'package:chat_app/features/splash/presentation/views/app_loader.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  ServiceLocator.init();
 Bloc.observer = Observe();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
    overlays: [],
  );

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(
      DevicePreview(
        builder: (context) => const MyApp(),
        enabled: true,
      ),
    );
  });
}

void updateUserStatus(String userId, bool isOnline) {
  FirebaseFirestore.instance.collection('users').doc(userId).update({
    'status': isOnline ? 'online' : 'offline',
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setUpUserStatusListener();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      if (state == AppLifecycleState.hidden) {
        updateUserStatus(user.uid, false);
      } else if (state == AppLifecycleState.resumed) {
        updateUserStatus(user.uid, true);
      }
    }
  }

  void setUpUserStatusListener() {
    final auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((user) {
      if (user != null) {
        updateUserStatus(user.uid, true);
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: const AppLoader(),
    );
  }
}
