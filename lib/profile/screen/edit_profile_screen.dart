import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? selectedAvatar;
  final TextEditingController _urlController = TextEditingController();

  Future<void> _updateAvatar(String avatarUrl) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference userRef =
          _firestore.collection('account').doc(user.uid);
      await userRef.update({'avatar': avatarUrl});
      setState(() {
        selectedAvatar = avatarUrl;
      });
    }
  }

  Future<void> _loadUserAvatar() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
          await _firestore.collection('account').doc(user.uid).get();
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        setState(() {
          selectedAvatar = data?['avatar'] as String? ??
              'https://avatars.mds.yandex.net/i?id=67ab9b97693119cff7dbf5fc7648ed2a_l-12799296-images-thumbs&n=13'; // URL по умолчанию
        });
      } else {
        setState(() {
          selectedAvatar =
              'https://avatars.mds.yandex.net/i?id=67ab9b97693119cff7dbf5fc7648ed2a_l-12799296-images-thumbs&n=13'; // URL по умолчанию
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserAvatar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              context.go('/profile');
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: selectedAvatar != null
                          ? NetworkImage(selectedAvatar!)
                          : const NetworkImage(
                              'https://avatars.mds.yandex.net/i?id=67ab9b97693119cff7dbf5fc7648ed2a_l-12799296-images-thumbs&n=13'),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Выберите аватар',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    _buildAvatarOptions(),
                    const SizedBox(height: 20),
                    _buildUrlInputField(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitUrl,
                      child: const Text('Обновить аватар'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  context.go('/profile');
                },
                child: const Text('Закрыть'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarOptions() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAvatar(
                'https://avatars.mds.yandex.net/i?id=67ab9b97693119cff7dbf5fc7648ed2a_l-12799296-images-thumbs&n=13'),
            const SizedBox(width: 20),
            _buildAvatar(
                'https://avatars.mds.yandex.net/i?id=cce3c64c70be5796e7afe1569fc26ce7d9b418fc-12722487-images-thumbs&n=13'),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAvatar(
                'https://avatars.mds.yandex.net/i?id=a9a82cb4af5c2dea9fbb1ecf01370c8f_sr-5304992-images-thumbs&n=13'),
            const SizedBox(width: 20),
            _buildAvatar(
                'https://avatars.mds.yandex.net/i?id=7aa7720de17657ee8f4c8be24e6a5d48_l-4961046-images-thumbs&n=13'),
          ],
        ),
      ],
    );
  }

  Widget _buildAvatar(String avatarUrl) {
    bool isSelected = selectedAvatar == avatarUrl;

    return GestureDetector(
      onTap: () => _updateAvatar(avatarUrl),
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.transparent,
        child: ClipOval(
          child: Stack(
            children: [
              Image.network(
                avatarUrl,
                fit: BoxFit.cover,
                width: 60,
                height: 60,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  debugPrint("Ошибка загрузки изображения: $error");
                  return Image.network(
                      'https://avatars.mds.yandex.net/i?id=67ab9b97693119cff7dbf5fc7648ed2a_l-12799296-images-thumbs&n=13',
                      width: 60,
                      height: 60);
                },
              ),
              if (isSelected)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUrlInputField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: _urlController,
        decoration: InputDecoration(
          labelText: 'Введите URL изображения',
          labelStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  void _submitUrl() {
    final url = _urlController.text;
    if (url.isNotEmpty) {
      _updateAvatar(url);
    }
  }
}
