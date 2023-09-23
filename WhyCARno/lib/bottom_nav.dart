import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  MyBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // 그림자 색상 및 투명도
            blurRadius: 5, // 그림자의 흐림 정도
            spreadRadius: 2, // 그림자의 확장 정도
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0), // 왼쪽 위 모서리 라운드 처리
          topRight: Radius.circular(15.0), // 오른쪽 위 모서리 라운드 처리
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0), // 왼쪽 위 모서리 라운드 처리
          topRight: Radius.circular(15.0), // 오른쪽 위 모서리 라운드 처리
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          selectedItemColor: Color.fromRGBO(1, 45, 107, 1), // 선택된 항목의 아이콘 및 텍스트 색상
          unselectedItemColor: Colors.grey, // 선택되지 않은 항목의 아이콘 및 텍스트 색상
          backgroundColor: Colors.white, // 배경색상
          type: BottomNavigationBarType.fixed, // 모든 항목에 레이블을 표시하도록 설정
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "홈",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: "녹화영상",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active),
              label: "알림",
            ),
          ],
        ),
      ),
    );
  }
}
