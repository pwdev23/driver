import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../environments.dart';
import '../models/osrm_route.dart';
import '../utils/geolocator.dart';
import '../utils/open_source_routing_machine.dart';
import '../utils/url_launcher.dart';
import 'driver_on_board_widget.dart';

class DriverOnBoardPage extends StatefulWidget {
  static const routeName = '/driver-on-board';

  const DriverOnBoardPage({super.key, required this.position});

  final Position position;

  @override
  State<DriverOnBoardPage> createState() => _DriverOnBoardPageState();
}

class _DriverOnBoardPageState extends State<DriverOnBoardPage> {
  final MapController _controller = MapController();
  bool _positionLoading = false;
  List<LatLng> _points = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final urlTemplate =
        isDark ? '$kUrlTemplateDark?api_key=$kStadiaMapsApiKey' : kUrlTemplate;
    final overlayStyle =
        Platform.isIOS
            ? null
            : const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    final iconButtonStyle = IconButton.styleFrom(
      backgroundColor: colors.surface,
      foregroundColor: colors.onSurface,
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: overlayStyle,
        centerTitle: false,
        title: _IslandButton(),
        leading: IconButton(
          style: iconButtonStyle,
          onPressed: () {},
          icon: Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            style: iconButtonStyle,
            onPressed: () => _onMyLocation(),
            icon: Visibility(
              visible: !_positionLoading,
              replacement: _TinyCircularProgressIndicator(),
              child: Icon(Icons.my_location),
            ),
          ),
          IconButton(
            style: iconButtonStyle,
            onPressed: () => _onGetRoute(),
            icon: Icon(Icons.navigation),
          ),
          SizedBox(width: 4.0),
        ],
      ),
      body: StreamBuilder<Position>(
        initialData: widget.position,
        stream: streamPosition(),
        builder: (context, snapshot) {
          final latLng = LatLng(
            snapshot.data!.latitude,
            snapshot.data!.longitude,
          );

          return FlutterMap(
            mapController: _controller,
            options: MapOptions(
              initialZoom: 13,
              maxZoom: 18,
              initialCenter: LatLng(
                widget.position.latitude,
                widget.position.longitude,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: urlTemplate,
                userAgentPackageName: kUserAgentPackageName,
                retinaMode: true,
              ),
              if (!isDark)
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      kAttribution,
                      onTap: () => onLaunchUrl(kAttributionUrl),
                    ),
                  ],
                ),
              MarkerLayer(
                markers: <Marker>[
                  Marker(
                    point: latLng,
                    rotate: true,
                    width: 24.0,
                    height: 24.0,
                    child: MapMarker(markerType: MarkerType.you),
                  ),
                ],
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _points.isEmpty ? [latLng] : _points,
                    color: colors.primary.withAlpha(100),
                    borderStrokeWidth: 4.0,
                    borderColor: colors.primary.withAlpha(200),
                    strokeWidth: 6.0,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _onMyLocation() async {
    setState(() => _positionLoading = true);
    await determinePosition().then((p) {
      final latLng = LatLng(p.latitude, p.longitude);
      _controller.moveAndRotate(latLng, 13, 0.0);
      setState(() => _positionLoading = false);
    });
  }

  Future<void> _onGetRoute() async {
    // Mock coordinates
    final start = LatLng(-6.940583170466513, 107.68141384551566);
    final end = LatLng(-6.955544741198372, 107.69851171743613);

    await getOsrmRoute(start: start, end: end).then((v) {
      _points = _getPoints(v);
    });

    setState(() {});
  }

  List<LatLng> _getPoints(OsrmRoute route) {
    List<LatLng> points = [];

    for (var e in route.legs![0].steps!) {
      final lat = e.maneuver!.location![1];
      final lng = e.maneuver!.location![0];
      final latLng = LatLng(lat, lng);
      points.add(latLng);
    }

    return points;
  }
}

class DriverOnBoardArgs {
  const DriverOnBoardArgs(this.position);

  final Position position;
}

class _TinyCircularProgressIndicator extends StatelessWidget {
  const _TinyCircularProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      strokeWidth: 2.5,
      constraints: BoxConstraints(minWidth: 24, minHeight: 24),
    );
  }
}

class _IslandButton extends StatelessWidget {
  const _IslandButton();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return RawMaterialButton(
      onPressed: () {},
      padding: const EdgeInsets.fromLTRB(6.0, 4.0, 12.0, 4.0),
      fillColor: colors.inverseSurface,
      textStyle: TextStyle(color: colors.onInverseSurface),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24.0)),
      ),
      constraints: const BoxConstraints(
        minWidth: 0.0,
        minHeight: 0.0,
        maxHeight: double.infinity,
        maxWidth: double.infinity,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bolt),
          Text('00.00', style: textTheme.titleMedium),
        ],
      ),
    );
  }
}
