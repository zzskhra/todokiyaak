import 'package:firebase_auth/firebase_auth.dart';
import 'package:todolist/data/firestor.dart';

abstract class AuthenticationDatasource {
  Future<bool> register(String email, String password, String PasswordConfirm);
  Future<bool> login(String email, String password);
}

class AuthenticationRemote extends AuthenticationDatasource {
  @override
  Future<bool> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  @override
  Future<bool> register(
    String email,
    String password,
    String PasswordConfirm,
  ) async {
    if (PasswordConfirm != password) return false;

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          )
          .then((value) {
            Firestore_Datasource().CreateUser(email);
          });
      return true;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }
}
