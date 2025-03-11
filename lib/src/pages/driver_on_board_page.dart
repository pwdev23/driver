import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../environments.dart';

class DriverOnBoardPage extends StatefulWidget {
  static const routeName = '/driver-on-board';

  const DriverOnBoardPage({super.key});

  @override
  State<DriverOnBoardPage> createState() => _DriverOnBoardPageState();
}

class _DriverOnBoardPageState extends State<DriverOnBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('On board')),
      body: FlutterMap(
        options: MapOptions(
          initialZoom: 9.2,
          maxZoom: 18,
          initialCenter: LatLng(-6.902269129532637, 107.61872325767236),
        ),
        children: [
          TileLayer(
            urlTemplate: kUrlTemplate,
            userAgentPackageName: kUserAgentPackageName,
            retinaMode: true,
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                kAttribution,
                onTap: () => _launchUrl(kkAttributionUrl),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Failed to launch $url');
    }
  }
}
