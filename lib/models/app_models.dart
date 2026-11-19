import 'package:flutter/material.dart';

enum AppLanguage { bisaya, english, filipino }

enum WaterStatus { normal, interrupted, pumpProblem, restored }

enum ReportStatus { newReport, inProgress, resolved }

class WaterSchedule {
  const WaterSchedule({required this.start, required this.end});

  final TimeOfDay start;
  final TimeOfDay end;
}

class WaterPost {
  const WaterPost({
    required this.id,
    required this.status,
    required this.message,
    required this.createdAt,
    this.returnTime,
  });

  final String id;
  final WaterStatus status;
  final String message;
  final DateTime createdAt;
  final TimeOfDay? returnTime;
}

class ResidentReport {
  const ResidentReport({
    required this.id,
    required this.location,
    required this.problem,
    required this.details,
    required this.contactMethod,
    required this.name,
    required this.createdAt,
    required this.status,
  });

  final String id;
  final String location;
  final String problem;
  final String details;
  final String contactMethod;
  final String name;
  final DateTime createdAt;
  final ReportStatus status;

  ResidentReport copyWith({ReportStatus? status}) {
    return ResidentReport(
      id: id,
      location: location,
      problem: problem,
      details: details,
      contactMethod: contactMethod,
      name: name,
      createdAt: createdAt,
      status: status ?? this.status,
    );
  }
}
