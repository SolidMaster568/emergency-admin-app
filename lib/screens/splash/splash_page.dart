import 'dart:async';

import 'package:emg/models/admin_model.dart';
import 'package:emg/screens/auth/login/login_page.dart';
import 'package:emg/screens/dashboard/main_page.dart';
import 'package:emg/utils/globals.dart';
import 'package:emg/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SpalshPage extends StatefulWidget {
  const SpalshPage({super.key});

  @override
  State<SpalshPage> createState() => _SpalshPageState();
}

class _SpalshPageState extends State<SpalshPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      autoLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/videocall.png"),
      ),
    );
  }

  Future<void> autoLogin() async {
    if (FirebaseAuth.instance.currentUser == null) {
      Timer.periodic(const Duration(seconds: 3), (timer) {
        timer.cancel();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      });
    } else {
      User user = FirebaseAuth.instance.currentUser!;
      try {
        AdminModel? adminModel = await Util.getEmrByFirebase(user.uid);

        if (adminModel != null) {
          Globals.currentAdmin = adminModel;
          Util.updateDeviceToken();

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (builder) => const MainPage(),
            ),
          );
        } else {
          await FirebaseAuth.instance.signOut();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        }
      } catch (e) {
        print(e);

        await FirebaseAuth.instance.signOut();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    }
  }
}
