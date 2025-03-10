import 'package:final_exam_1/view/cartpage.dart';
import 'package:final_exam_1/view/homepage.dart';
import 'package:final_exam_1/view/splashpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/', page: () => SplashPage(),),
        GetPage(name: '/cart', page: () => CartPage(),),
        GetPage(name: '/home', page: () => HomePage(),)
      ],
    );
  }
}
