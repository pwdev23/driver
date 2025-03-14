import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum MarkerType { you, hitchhike }

class MapMarker extends StatelessWidget {
  const MapMarker({super.key, this.markerType = MarkerType.you});

  final MarkerType markerType;

  @override
  Widget build(BuildContext context) {
    final asset = 'svg/marker_${markerType.name}.svg';

    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            spreadRadius: 2,
            blurRadius: 6,
          ),
        ],
      ),
      child: SvgPicture.asset(asset),
    );
  }
}
