import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

Future<void> openUrl(String url) async {
  Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> showMyDialog(
  BuildContext context, {
  required String title,
  required String content,
}) async {
  ThemeData theme = Theme.of(context);
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title,
            style: theme.textTheme.displayMedium?.copyWith(
              color: theme.primaryColorDark,
              fontWeight: FontWeight.w700,
              fontSize: 20.0,
            )),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(content),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'OK',
              style: theme.textTheme.displayMedium?.copyWith(
                color: theme.primaryColor,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
