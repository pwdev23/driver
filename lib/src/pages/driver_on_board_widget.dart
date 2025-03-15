import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum MarkerType { you, hitchhike }

class MapMarker extends StatelessWidget {
  const MapMarker({super.key, this.markerType = MarkerType.you});

  final MarkerType markerType;

  @override
  Widget build(BuildContext context) {
    final asset = 'svg/marker_${markerType.name}.svg';

    return SvgPicture.asset(asset);
  }
}
