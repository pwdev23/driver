import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../environments.dart';
import '../utils/geolocator.dart';
import '../utils/url_launcher.dart';
import 'driver_on_board_widget.dart';

// Marker simulation
const kMarkers = [LatLng(-6.9312534897645, 107.68609161809115)];

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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final urlTemplate = isDark ? kUrlTemplateDark : kUrlTemplate;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: TextButton.icon(
          onPressed: () {},
          label: Text(
            '00.00',
            style: textTheme.titleMedium!.copyWith(color: colors.onSurface),
          ),
          style: TextButton.styleFrom(
            backgroundColor: colors.surface,
            foregroundColor: colors.onSurface,
          ),
          icon: Icon(Icons.electric_bolt, color: colors.surfaceTint),
        ),
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
                  ...kMarkers.map(
                    (e) => Marker(
                      point: e,
                      rotate: true,
                      child: MapMarker(markerType: MarkerType.hitchhike),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        color: colors.surface,
        alignment: Alignment.center,
        height: kToolbarHeight,
        child: Text(
          'You\'re offline',
          textAlign: TextAlign.center,
          style: textTheme.titleLarge!.copyWith(color: colors.onSurface),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _onMyLocation(),
        label: Visibility(
          visible: !_positionLoading,
          replacement: _TinyCircularProgressIndicator(),
          child: Icon(Icons.my_location),
        ),
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
