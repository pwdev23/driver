class OsrmRoute {
  List<Legs>? legs;
  String? weightName;
  num? weight;
  num? duration;
  double? distance;

  OsrmRoute({
    this.legs,
    this.weightName,
    this.weight,
    this.duration,
    this.distance,
  });

  OsrmRoute.fromJson(Map<String, dynamic> json) {
    if (json['legs'] != null) {
      legs = <Legs>[];
      json['legs'].forEach((v) {
        legs!.add(Legs.fromJson(v));
      });
    }
    weightName = json['weight_name'];
    weight = json['weight'];
    duration = json['duration'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (legs != null) {
      data['legs'] = legs!.map((v) => v.toJson()).toList();
    }
    data['weight_name'] = weightName;
    data['weight'] = weight;
    data['duration'] = duration;
    data['distance'] = distance;
    return data;
  }
}

class Legs {
  List<Steps>? steps;
  String? summary;
  num? weight;
  num? duration;
  num? distance;

  Legs({this.steps, this.summary, this.weight, this.duration, this.distance});

  Legs.fromJson(Map<String, dynamic> json) {
    if (json['steps'] != null) {
      steps = <Steps>[];
      json['steps'].forEach((v) {
        steps!.add(Steps.fromJson(v));
      });
    }
    summary = json['summary'];
    weight = json['weight'];
    duration = json['duration'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (steps != null) {
      data['steps'] = steps!.map((v) => v.toJson()).toList();
    }
    data['summary'] = summary;
    data['weight'] = weight;
    data['duration'] = duration;
    data['distance'] = distance;
    return data;
  }
}

class Steps {
  String? geometry;
  Maneuver? maneuver;
  String? mode;
  String? drivingSide;
  String? name;
  num? weight;
  num? duration;
  num? distance;

  Steps({
    this.geometry,
    this.maneuver,
    this.mode,
    this.drivingSide,
    this.name,
    this.weight,
    this.duration,
    this.distance,
  });

  Steps.fromJson(Map<String, dynamic> json) {
    geometry = json['geometry'];
    maneuver =
        json['maneuver'] != null ? Maneuver.fromJson(json['maneuver']) : null;
    mode = json['mode'];
    drivingSide = json['driving_side'];
    name = json['name'];
    weight = json['weight'];
    duration = json['duration'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['geometry'] = geometry;
    if (maneuver != null) {
      data['maneuver'] = maneuver!.toJson();
    }
    data['mode'] = mode;
    data['driving_side'] = drivingSide;
    data['name'] = name;
    data['weight'] = weight;
    data['duration'] = duration;
    data['distance'] = distance;
    return data;
  }
}

class Maneuver {
  num? bearingAfter;
  num? bearingBefore;
  List<double>? location;
  String? modifier;
  String? type;

  Maneuver({
    this.bearingAfter,
    this.bearingBefore,
    this.location,
    this.modifier,
    this.type,
  });

  Maneuver.fromJson(Map<String, dynamic> json) {
    bearingAfter = json['bearing_after'];
    bearingBefore = json['bearing_before'];
    location = json['location'].cast<double>();
    modifier = json['modifier'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bearing_after'] = bearingAfter;
    data['bearing_before'] = bearingBefore;
    data['location'] = location;
    data['modifier'] = modifier;
    data['type'] = type;
    return data;
  }
}
