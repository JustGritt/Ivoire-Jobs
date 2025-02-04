import 'package:barassage_app/core/widgets/day_night_switch.dart';
import 'package:barassage_app/features/auth_mod/auth_mod.dart';
import 'package:barassage_app/core/classes/route_manager.dart';
import 'package:flutter/material.dart';

class ForgetMobileScreen extends StatelessWidget {
  const ForgetMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forget Screen'),
        leading: IconButton(
          onPressed: () {
            Nav.to(context, AuthApp.login);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: const [DayNightSwitch()],
      ),
      body: Form(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => {Navigator.of(context).pushNamed('/forget')},
              child: const Text(
                'Forget Password?',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextInputField(
              labelTextStr: 'Input Your Register Email Address',
              prefixIcon: Icons.email_outlined,
            ),
            AuthButton(
              label: 'Send Recovery Email',
              onPressed: () {},
              paddingValue: 10,
            ),
            const Divider(
              thickness: 2,
            ),
            const SizedBox(
              height: 45,
            ),
            const Text(
              'If you are not getting email. Then Press',
              // style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 5,
            ),
            AuthButton(label: 'Resend Email', onPressed: () {}),
          ],
        ),
      )),
    );
  }
}
