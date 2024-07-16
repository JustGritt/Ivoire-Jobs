import 'package:barassage_app/features/main_app/widgets/day_night_switch.dart';
import 'package:barassage_app/features/main_app/widgets/menu_buttons.dart';
import 'package:barassage_app/core/classes/classes.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String? title;
  const Home({super.key, this.title});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool dayAndNight = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tablet: ${widget.title!}"),
        actions: const [DayNightSwitch(), MenuButtons()],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This is the first page'),
            ElevatedButton(
              onPressed: () {
                Nav.to(context, '/about');
              },
              child: const Text('Goto About Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Nav.to(context, '/contact');
              },
              child: const Text('Goto Contact Page'),
            ),
          ],
        ),
      ),
    );
  }
}
