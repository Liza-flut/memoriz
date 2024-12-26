import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../ui/bottom_navigation_icons.dart';
import '../ui/app_colors.dart';

class RankingScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> _getRanking({required String orderBy}) {
    return _firestore
        .collection('account')
        .orderBy(orderBy)
        .limit(10)
        .snapshots()
        .map((querySnapshot) {
      List<Map<String, dynamic>> ranking = [];
      for (var doc in querySnapshot.docs) {
        ranking.add({
          'email': doc['email'],
          'avatar': doc['avatar'],
          'minTurns': doc['minTurns'],
          'minTime': doc['minTime'],
        });
      }
      return ranking;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text(
            'Рейтинг',
            style: TextStyle(color: AppColors.textOnPrimary),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Мин. ходы',
                icon: Icon(Icons.pets, color: AppColors.textOnPrimary),
              ),
              Tab(
                text: 'Мин. время',
                icon: Icon(Icons.timer, color: AppColors.textOnPrimary),
              ),
            ],
          ),
        ),
        body: Container(
          color: Colors.black,
          child: TabBarView(
            children: [
              _buildRankingList(orderBy: 'minTurns', title: 'Мин. ходы'),
              _buildRankingList(orderBy: 'minTime', title: 'Мин. время'),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavigationIcons(currentIndex: 2),
      ),
    );
  }

  Widget _buildRankingList({required String orderBy, required String title}) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _getRanking(orderBy: orderBy),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text('Нет данных для $title',
                  style: TextStyle(color: AppColors.textOnPrimary)));
        }

        List<Map<String, dynamic>> ranking = snapshot.data!;

        return ListView.builder(
          itemCount: ranking.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(ranking[index]['avatar'] ?? ''),
              ),
              title: Text(
                ranking[index]['email'],
                style: TextStyle(color: AppColors.textOnPrimary),
              ),
              subtitle: Text(
                orderBy == 'minTurns'
                    ? 'Мин. ходы: ${ranking[index]['minTurns']}'
                    : 'Мин. время: ${ranking[index]['minTime']}',
                style: TextStyle(color: AppColors.textOnPrimary),
              ),
              trailing: Text(
                '#${index + 1}',
                style: const TextStyle(
                    fontSize: 18, color: AppColors.textOnPrimary),
              ),
            );
          },
        );
      },
    );
  }
}
