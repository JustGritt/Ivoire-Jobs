import 'package:barassage_app/features/main_app/widgets/widget.dart';
import 'package:barassage_app/core/classes/route_manager.dart';
import 'package:flutter/material.dart';

class About extends StatefulWidget {
  final String? title;
  const About({super.key, this.title});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
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
            const Text('This is the first page'),
            ElevatedButton(
              onPressed: () {
                Nav.to(context, '/');
              },
              child: const Text('Goto Home Page'),
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
