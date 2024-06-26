import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/button_data.dart';
import 'package:provider/provider.dart';

import '../../config/app_theme.dart';
import '../utils/bottom_util.dart';

// ignore: must_be_immutable
class BottomBar extends StatelessWidget {
  int index = 0;
  int len = 0;

  List<ButtonData>? buttonDatas;
  BottomBar({super.key, this.buttonDatas}) {
    buttonDatas = buttonDatas ??
        [
          ButtonData(icon: Icons.home, label: 'Home', link: '/'),
          ButtonData(icon: Icons.ac_unit, label: 'Features', link: '/feature'),
        ];
  }

  List<ButtonData> get buttonData => buttonDatas!;

  @override
  Widget build(BuildContext context) {
    len = buttonDatas!.length;
    var tm = context.read<ThemeProvider>();
    ThemeData theme = Theme.of(context);
    index = tm.index;

    if (len > 1) {
      return BottomNavigationBar(
        backgroundColor: theme.primaryColorDark,
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (val) {
          tm.setNavIndex(val);
          index = val;
          // navigator(context);
        },
        items: buttonData
            .map(
              (e) => bottomNavigationBarItem(
                icon: Icon(e.icon),
                label: e.label,
              ),
            )
            .toList(),
      );
    } else {
      return Container();
    }
  }

  void navigator(BuildContext context) {
    if (buttonData[index].link != null) {
      context.pushNamed(buttonData[index].link!);
    }
  }
}
