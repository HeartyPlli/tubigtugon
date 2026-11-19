import 'package:flutter/material.dart';

import '../models/app_models.dart';

class AppController extends ChangeNotifier {
  AppController()
    : _posts = [
        WaterPost(
          id: 'welcome',
          status: WaterStatus.normal,
          message: 'defaultUpdateMessage',
          createdAt: DateTime.now().subtract(const Duration(minutes: 24)),
        ),
      ],
      _reports = [
        ResidentReport(
          id: 'sample-report',
          location: 'locInside',
          problem: 'problemWeak',
          details: 'Hinay kaayo ang tubig sukad alas siyete sa buntag.',
          contactMethod: 'contactText',
          name: 'Resident sample',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          status: ReportStatus.newReport,
        ),
      ];

  AppLanguage _language = AppLanguage.bisaya;
  WaterSchedule _schedule = const WaterSchedule(
    start: TimeOfDay(hour: 7, minute: 0),
    end: TimeOfDay(hour: 8, minute: 30),
  );
  final List<WaterPost> _posts;
  final List<ResidentReport> _reports;
  bool _isAdminLoggedIn = false;

  AppLanguage get language => _language;
  WaterSchedule get schedule => _schedule;
  List<WaterPost> get posts => List.unmodifiable(_posts);
  List<ResidentReport> get reports => List.unmodifiable(_reports);
  bool get isAdminLoggedIn => _isAdminLoggedIn;
  WaterPost get latestPost => _posts.first;

  void setLanguage(AppLanguage language) {
    if (_language == language) return;
    _language = language;
    notifyListeners();
  }

  bool login(String username, String password) {
    final isValid = username.trim() == 'admin' && password == 'admin123';
    if (isValid) {
      _isAdminLoggedIn = true;
      notifyListeners();
    }
    return isValid;
  }

  void logout() {
    _isAdminLoggedIn = false;
    notifyListeners();
  }

  void updateSchedule(TimeOfDay start, TimeOfDay end) {
    _schedule = WaterSchedule(start: start, end: end);
    notifyListeners();
  }

  void addPost({
    required WaterStatus status,
    required String message,
    TimeOfDay? returnTime,
  }) {
    _posts.insert(
      0,
      WaterPost(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        status: status,
        message: message.trim(),
        createdAt: DateTime.now(),
        returnTime: returnTime,
      ),
    );
    notifyListeners();
  }

  void deletePost(String id) {
    if (_posts.length == 1) return;
    _posts.removeWhere((post) => post.id == id);
    notifyListeners();
  }

  void addReport({
    required String location,
    required String problem,
    required String details,
    required String contactMethod,
    required String name,
  }) {
    _reports.insert(
      0,
      ResidentReport(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        location: location,
        problem: problem,
        details: details.trim(),
        contactMethod: contactMethod,
        name: name.trim(),
        createdAt: DateTime.now(),
        status: ReportStatus.newReport,
      ),
    );
    notifyListeners();
  }

  void updateReportStatus(String id, ReportStatus status) {
    final index = _reports.indexWhere((report) => report.id == id);
    if (index == -1) return;
    _reports[index] = _reports[index].copyWith(status: status);
    notifyListeners();
  }
}

class AppScope extends InheritedNotifier<AppController> {
  const AppScope({super.key, required super.notifier, required super.child});

  static AppController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'No AppScope found in context.');
    return scope!.notifier!;
  }
}
