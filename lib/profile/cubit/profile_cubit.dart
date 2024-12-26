import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ProfileCubit() : super(ProfileState.initial());

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true));
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot snapshot =
            await _firestore.collection('account').doc(user.uid).get();

        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;

          print(
              'Profile data loaded: ${data['email']}, ${data['avatar']}, ${data['minTurns']}, ${data['minTime']}');

          emit(state.copyWith(
            email: data['email'] ?? user.email,
            avatar: data['avatar'] ??
                'https://avatars.mds.yandex.net/i?id=67ab9b97693119cff7dbf5fc7648ed2a_l-12799296-images-thumbs&n=13', // Устанавливаем начальный URL
            minTurns: (data['minTurns'] is num ? data['minTurns'] : 1000),
            minTime: (data['minTime'] is num ? data['minTime'] : 1000),
            isLoading: false,
          ));
        } else {
          await _firestore.collection('account').doc(user.uid).set({
            'email': user.email,
            'avatar': '',
            'minTurns': double.infinity,
            'minTime': double.infinity,
          });
          emit(state.copyWith(
            email: user.email,
            avatar:
                'https://avatars.mds.yandex.net/i?id=67ab9b97693119cff7dbf5fc7648ed2a_l-12799296-images-thumbs&n=13', // Начальное изображение
            minTurns: double.infinity,
            minTime: double.infinity,
            isLoading: false,
          ));
        }
      } else {
        emit(state.copyWith(isLoading: false));
        print('No user is logged in');
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      print('Error loading profile: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> updateProfile({int? minTurns, double? minTime}) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('account').doc(user.uid).update({
        if (minTurns != null) 'minTurns': minTurns,
        if (minTime != null) 'minTime': minTime,
      });
    }
  }
}
