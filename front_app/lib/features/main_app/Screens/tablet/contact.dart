import 'package:barassage_app/features/main_app/widgets/day_night_switch.dart';
import 'package:barassage_app/features/main_app/widgets/menu_buttons.dart';
import 'package:barassage_app/core/classes/classes.dart';
import 'package:flutter/material.dart';

class Contact extends StatefulWidget {
  final String? title;
  const Contact({super.key, this.title});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
        actions: const [DayNightSwitch(), MenuButtons()],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This is the Contact page'),
            ElevatedButton(
              onPressed: () {
                Nav.to(context, '/');
              },
              child: const Text('Goto Home Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Nav.to(context, '/about');
              },
              child: const Text('Goto About Page'),
            ),
          ],
        ),
      ),
    );
  }
}
