import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:seymour_app/Common/Models/coordinate.dart';

/*

The following code was first created by ChatGPT after being given this prompt, which includes a response from Azure describing a route based on start and end coordinates:


Create Dart Objects that get data from the following json:
{JSON response from Azure}

*/

class Route {
  final Summary summary;
  final List<Leg> legs;
  final List<Section> sections;
  final Guidance guidance;

  Route(
      {required this.summary,
      required this.legs,
      required this.sections,
      required this.guidance});

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      summary: Summary.fromJson(json['summary']),
      legs: (json['legs'] as List).map((i) => Leg.fromJson(i)).toList(),
      sections:
          (json['sections'] as List).map((i) => Section.fromJson(i)).toList(),
      guidance: Guidance.fromJson(json['guidance']),
    );
  }

  List<Polyline<Object>> drawRoute() {
    List<Polyline<Object>> drawnRoads = [];
    for (Leg leg in legs) {
      drawnRoads.add(Polyline(
          // useStrokeWidthInMeter: true,
          strokeWidth: 8,
          points: leg.points.map((coord) => coord.toLatLng()).toList(),
          color: const Color.fromARGB(98, 0, 0, 0)));
    }

    return drawnRoads;
  }
}

class Summary {
  final int lengthInMeters;
  final int travelTimeInSeconds;
  final int trafficDelayInSeconds;
  final int trafficLengthInMeters;
  final DateTime departureTime;
  final DateTime arrivalTime;

  Summary(
      {required this.lengthInMeters,
      required this.travelTimeInSeconds,
      required this.trafficDelayInSeconds,
      required this.trafficLengthInMeters,
      required this.departureTime,
      required this.arrivalTime});

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      lengthInMeters: json['lengthInMeters'],
      travelTimeInSeconds: json['travelTimeInSeconds'],
      trafficDelayInSeconds: json['trafficDelayInSeconds'],
      trafficLengthInMeters: json['trafficLengthInMeters'],
      departureTime: DateTime.parse(json['departureTime']),
      arrivalTime: DateTime.parse(json['arrivalTime']),
    );
  }
}

class Leg {
  final Summary summary;
  final List<Coordinate> points;

  Leg({required this.summary, required this.points});

  factory Leg.fromJson(Map<String, dynamic> json) {
    return Leg(
      summary: Summary.fromJson(json['summary']),
      points: (json['points'] as List)
          .map((i) => Coordinate.fromJsonAzure(i))
          .toList(),
    );
  }
}

class Section {
  final int startPointIndex;
  final int endPointIndex;
  final String sectionType;
  final String travelMode;

  Section(
      {required this.startPointIndex,
      required this.endPointIndex,
      required this.sectionType,
      required this.travelMode});

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      startPointIndex: json['startPointIndex'],
      endPointIndex: json['endPointIndex'],
      sectionType: json['sectionType'],
      travelMode: json['travelMode'],
    );
  }
}

class Guidance {
  final List<Instruction> instructions;
  final List<InstructionGroup> instructionGroups;

  Guidance({required this.instructions, required this.instructionGroups});

  factory Guidance.fromJson(Map<String, dynamic> json) {
    return Guidance(
      instructions: (json['instructions'] as List)
          .map((i) => Instruction.fromJson(i))
          .toList(),
      instructionGroups: (json['instructionGroups'] as List)
          .map((i) => InstructionGroup.fromJson(i))
          .toList(),
    );
  }
}

class Instruction {
  final int routeOffsetInMeters;
  final int travelTimeInSeconds;
  final Coordinate point;
  final int pointIndex;
  final String instructionType;
  final String? street;
  final bool possibleCombineWithNext;
  final String drivingSide;
  final String maneuver;
  final String message;
  final int? turnAngleInDecimalDegrees;
  final String? junctionType;

  Instruction({
    required this.routeOffsetInMeters,
    required this.travelTimeInSeconds,
    required this.point,
    required this.pointIndex,
    required this.instructionType,
    required this.street,
    required this.possibleCombineWithNext,
    required this.drivingSide,
    required this.maneuver,
    required this.message,
    this.turnAngleInDecimalDegrees,
    this.junctionType,
  });

  factory Instruction.fromJson(Map<String, dynamic> json) {
    return Instruction(
      routeOffsetInMeters: json['routeOffsetInMeters'],
      travelTimeInSeconds: json['travelTimeInSeconds'],
      point: Coordinate.fromJsonAzure(json['point']),
      pointIndex: json['pointIndex'],
      instructionType: json['instructionType'],
      street: json['street'],
      possibleCombineWithNext: json['possibleCombineWithNext'],
      drivingSide: json['drivingSide'],
      maneuver: json['maneuver'],
      message: json['message'],
      turnAngleInDecimalDegrees: json['turnAngleInDecimalDegrees'],
      junctionType: json['junctionType'],
    );
  }
}

class InstructionGroup {
  final int firstInstructionIndex;
  final int lastInstructionIndex;
  final String groupMessage;
  final int groupLengthInMeters;

  InstructionGroup(
      {required this.firstInstructionIndex,
      required this.lastInstructionIndex,
      required this.groupMessage,
      required this.groupLengthInMeters});

  factory InstructionGroup.fromJson(Map<String, dynamic> json) {
    return InstructionGroup(
      firstInstructionIndex: json['firstInstructionIndex'],
      lastInstructionIndex: json['lastInstructionIndex'],
      groupMessage: json['groupMessage'],
      groupLengthInMeters: json['groupLengthInMeters'],
    );
  }
}
