import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_cubit_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.initial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signIn(String email, String password) async {
    try {
      emit(state.copyWith(isLoading: true));
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      final userDoc = await _firestore
          .collection('account')
          .doc(userCredential.user?.uid)
          .get();
      if (userDoc.exists) {
        emit(state.copyWith(user: userDoc.data()?['email'], isLoading: false));
      } else {
        emit(
            state.copyWith(error: 'User profile not found.', isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      emit(state.copyWith(isLoading: true));
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      emit(state.copyWith(user: email, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}
