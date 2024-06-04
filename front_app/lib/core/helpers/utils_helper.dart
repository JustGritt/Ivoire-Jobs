import 'package:url_launcher/url_launcher.dart';

Future<void> openUrl(String url) async {
  Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await canLaunchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}
