import 'package:flutter/material.dart';
import 'package:money_management/screens/home/screen_home.dart';

class MoneyManagerBottomNavigatorBar extends StatelessWidget {
  const MoneyManagerBottomNavigatorBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ScreenHome.selectedIndexNotifier,
      builder: (BuildContext ctx, int updatedIndex, Widget? child) {
        return BottomNavigationBar(
          currentIndex: updatedIndex,
          onTap: (int index) {
            ScreenHome.selectedIndexNotifier.value = index;
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Transaction',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Category',
            )
          ],
        );
      },
    );
  }
}
