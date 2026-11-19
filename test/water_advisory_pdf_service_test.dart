import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tubigtugon/core/app_strings.dart';
import 'package:tubigtugon/models/app_models.dart';
import 'package:tubigtugon/services/water_advisory_pdf_service.dart';

void main() {
  test('builds a valid water advisory PDF', () async {
    final bytes = await WaterAdvisoryPdfService.build(
      strings: const AppStrings(AppLanguage.english),
      schedule: const WaterSchedule(
        start: TimeOfDay(hour: 7, minute: 0),
        end: TimeOfDay(hour: 8, minute: 30),
      ),
      notices: [
        WaterPost(
          id: 'test',
          status: WaterStatus.interrupted,
          message: 'Water service is temporarily interrupted while the pump is checked.',
          createdAt: DateTime(2026, 11, 12, 8, 15),
          returnTime: const TimeOfDay(hour: 10, minute: 0),
        ),
      ],
    );

    expect(bytes.length, greaterThan(1000));
    expect(latin1.decode(bytes.take(5).toList()), '%PDF-');

    final qaPath = Platform.environment['TUBIGTUGON_PDF_QA'];
    if (qaPath != null && qaPath.isNotEmpty) {
      final output = File(qaPath);
      await output.parent.create(recursive: true);
      await output.writeAsBytes(bytes);
    }
  });
}
