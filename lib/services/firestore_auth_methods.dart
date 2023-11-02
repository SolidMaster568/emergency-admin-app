import 'package:emg/models/admin_model.dart';
import 'package:emg/utils/globals.dart';
import 'package:emg/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_exceptions.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> loginAdmin({
    required String email,
    required String pass,
  }) async {
    String res = 'Some error occured';
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: pass);

      User user = FirebaseAuth.instance.currentUser!;
      AdminModel? adminModel = await Util.getEmrByFirebase(user.uid);

      if (adminModel != null) {
        Globals.currentAdmin = adminModel;
        Util.updateDeviceToken();
        res = 'success';
      } else {
        await _auth.signOut();
        res = "Invalid admin account";
      }
    } on FirebaseException catch (e) {
      if (e.message == 'WrongEmail') {
        debugPrint(e.message ?? "");
      }
      if (e.message == 'WrongPassword') {
        debugPrint(e.message ?? "");
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  /// Forgot Password
  Future<AuthStatus> resetPassword({required String email}) async {
    AuthStatus status = AuthStatus.invalidEmail;
    await _auth
        .sendPasswordResetEmail(email: email)
        .then((value) => status = AuthStatus.successful)
        .catchError(
            (e) => status = AuthExceptionHandler.handleAuthException(e));

    return status;
  }
}
