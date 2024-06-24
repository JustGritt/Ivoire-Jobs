// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class Service extends StatefulWidget {
  final String? title;
  const Service({super.key, this.title});

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  late TextEditingController _name;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: 'Guest');
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
        actions: actionsMenu(context),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
