import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../environments.dart';
import '../models/osrm_route.dart';

Future<OsrmRoute> getOsrmRoute({
  String service = 'route',
  String version = 'v1',
  String profile = 'bike',
  required LatLng start,
  required LatLng end,
}) async {
  final coordinates =
      '${start.longitude},${start.latitude};${end.longitude},${end.latitude}';
  final url = '$kOrsmBaseUrl/$service/$version/$profile/$coordinates';

  try {
    final res = await http.get(Uri.parse('$url?steps=true'));

    if (res.statusCode != 200) throw Exception('Failed to load');

    final data = json.decode(res.body);

    return OsrmRoute.fromJson(data['routes'][0]);
  } catch (e) {
    throw Exception(e);
  }
}
