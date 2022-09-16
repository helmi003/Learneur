import 'package:flutter/material.dart';

BottomNavigationBar bottombar(BuildContext context,int index,String ch) {
  return BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: '$ch course',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_add),
            label: '$ch files',
          ),
        ],
        currentIndex: index,
        selectedItemColor: Colors.amber[800],
      );
}