import 'package:url_launcher/url_launcher.dart';

Future<void> onLaunchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Failed to launch $url');
  }
}
