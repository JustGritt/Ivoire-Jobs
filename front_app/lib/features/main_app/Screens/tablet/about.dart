import 'package:barassage_app/features/main_app/widgets/day_night_switch.dart';
import 'package:barassage_app/features/main_app/widgets/menu_buttons.dart';
import 'package:barassage_app/core/classes/route_manager.dart';
import 'package:flutter/material.dart';
// ignore_for_file: deprecated_member_use

class About extends StatefulWidget {
  final String? title;
  const About({super.key, this.title});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  late TextEditingController _name;
  late String display;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: 'Guest');
    display = 'About Page';
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
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
            Text(display),
            Center(
              child: EditableText(
                textAlign: TextAlign.center,
                controller: _name,
                focusNode: FocusNode(),
                style: TextStyle(
                  color: theme.textTheme.displayMedium!.color,
                  fontSize: 20,
                ),
                cursorColor: theme.textTheme.displayMedium!.color!,
                backgroundCursorColor: Colors.yellowAccent,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  display = 'Welcome ${_name.text}';
                });
              },
              child: const Text('Welcome'),
            ),
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
