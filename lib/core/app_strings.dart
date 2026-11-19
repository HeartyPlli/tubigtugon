import 'package:flutter/material.dart';

import '../models/app_models.dart';

class AppStrings {
  const AppStrings(this.language);

  final AppLanguage language;

  static const Map<String, Map<AppLanguage, String>> _values = {
    'home': {
      AppLanguage.bisaya: 'Balay',
      AppLanguage.english: 'Home',
      AppLanguage.filipino: 'Home',
    },
    'report': {
      AppLanguage.bisaya: 'Pag-report',
      AppLanguage.english: 'Report',
      AppLanguage.filipino: 'Mag-report',
    },
    'language': {
      AppLanguage.bisaya: 'Pinulongan',
      AppLanguage.english: 'Language',
      AppLanguage.filipino: 'Wika',
    },
    'waterSupply': {
      AppLanguage.bisaya: 'Suplay sa Tubig',
      AppLanguage.english: 'Water Supply',
      AppLanguage.filipino: 'Suplay ng Tubig',
    },
    'community': {
      AppLanguage.bisaya: 'Purok 1, Barangay Kauswagan',
      AppLanguage.english: 'Purok 1, Barangay Kauswagan',
      AppLanguage.filipino: 'Purok 1, Barangay Kauswagan',
    },
    'todaySchedule': {
      AppLanguage.bisaya: 'Oras sa tubig karon',
      AppLanguage.english: "Today's water schedule",
      AppLanguage.filipino: 'Oras ng tubig ngayon',
    },
    'scheduleHelp': {
      AppLanguage.bisaya: 'Andama ang inyong sudlanan sa dili pa magsugod.',
      AppLanguage.english:
          'Prepare your containers before the schedule starts.',
      AppLanguage.filipino: 'Ihanda ang mga lalagyan bago magsimula ang oras.',
    },
    'latestUpdate': {
      AppLanguage.bisaya: 'Pinakabag-ong pahibalo',
      AppLanguage.english: 'Latest update',
      AppLanguage.filipino: 'Pinakabagong abiso',
    },
    'defaultUpdateMessage': {
      AppLanguage.bisaya: 'Regular ang suplay sa tubig karong adlawa.',
      AppLanguage.english:
          'The water supply is running on the regular schedule today.',
      AppLanguage.filipino: 'Regular ang suplay ng tubig ngayong araw.',
    },
    'reportProblem': {
      AppLanguage.bisaya: 'I-report ang problema sa tubig',
      AppLanguage.english: 'Report a water problem',
      AppLanguage.filipino: 'I-report ang problema sa tubig',
    },
    'reportProblemHelp': {
      AppLanguage.bisaya: 'Sultihi ang barangay kung walay tubig, hinay ang agas, o adunay guba.',
      AppLanguage.english:
          'Tell the barangay about no water, weak flow, or a damaged pump.',
      AppLanguage.filipino: 'Sabihin sa barangay kung walang tubig, mahina ang daloy, o may sira.',
    },
    'startReport': {
      AppLanguage.bisaya: 'Sugdi ang report',
      AppLanguage.english: 'Start report',
      AppLanguage.filipino: 'Simulan ang report',
    },
    'offlineNotice': {
      AppLanguage.bisaya: 'Walay cellphone o internet?',
      AppLanguage.english: 'No phone or internet?',
      AppLanguage.filipino: 'Walang cellphone o internet?',
    },
    'offlineHelp': {
      AppLanguage.bisaya: 'Tan-awa ang printed nga pahibalo o pangutana sa inyong purok representative.',
      AppLanguage.english:
          'Check the printed notice or ask your purok representative.',
      AppLanguage.filipino: 'Tingnan ang naka-print na abiso o magtanong sa purok representative.',
    },
    'reportTitle': {
      AppLanguage.bisaya: 'I-report ang Problema',
      AppLanguage.english: 'Report a Problem',
      AppLanguage.filipino: 'Mag-report ng Problema',
    },
    'reportIntro': {
      AppLanguage.bisaya: 'Tubaga ang mubo nga porma. Ang ngalan ug detalye sa pagkontak dili kinahanglan.',
      AppLanguage.english: 'Complete this short form. Your name and contact details are optional.',
      AppLanguage.filipino: 'Sagutan ang maikling form. Opsyonal ang pangalan at contact details.',
    },
    'location': {
      AppLanguage.bisaya: 'Asa ang problema?',
      AppLanguage.english: 'Where is the problem?',
      AppLanguage.filipino: 'Saan ang problema?',
    },
    'problemType': {
      AppLanguage.bisaya: 'Unsa ang problema?',
      AppLanguage.english: 'What is the problem?',
      AppLanguage.filipino: 'Ano ang problema?',
    },
    'detailsOptional': {
      AppLanguage.bisaya: 'Dugang detalye (kung gusto)',
      AppLanguage.english: 'More details (optional)',
      AppLanguage.filipino: 'Dagdag na detalye (opsyonal)',
    },
    'detailsHint': {
      AppLanguage.bisaya: 'Pananglitan: Wala mi tubig sukad gahapon sa buntag.',
      AppLanguage.english:
          'Example: We have had no water since yesterday morning.',
      AppLanguage.filipino:
          'Halimbawa: Wala kaming tubig mula kahapon ng umaga.',
    },
    'contactOptional': {
      AppLanguage.bisaya: 'Unsaon ka namo pagkontak? (kung gusto)',
      AppLanguage.english: 'How may we contact you? (optional)',
      AppLanguage.filipino: 'Paano ka namin makokontak? (opsyonal)',
    },
    'nameOptional': {
      AppLanguage.bisaya: 'Imong ngalan (kung gusto)',
      AppLanguage.english: 'Your name (optional)',
      AppLanguage.filipino: 'Pangalan mo (opsyonal)',
    },
    'nameHint': {
      AppLanguage.bisaya: 'Pwede nimong biyaan nga blangko.',
      AppLanguage.english: 'You may leave this blank.',
      AppLanguage.filipino: 'Maaari itong iwanang blangko.',
    },
    'submitReport': {
      AppLanguage.bisaya: 'Ipadala ang report',
      AppLanguage.english: 'Submit report',
      AppLanguage.filipino: 'Ipadala ang report',
    },
    'requiredField': {
      AppLanguage.bisaya: 'Palihog pagpili og tubag.',
      AppLanguage.english: 'Please choose an answer.',
      AppLanguage.filipino: 'Pumili ng sagot.',
    },
    'reportSent': {
      AppLanguage.bisaya: 'Nadawat na ang imong report',
      AppLanguage.english: 'Your report was received',
      AppLanguage.filipino: 'Natanggap na ang iyong report',
    },
    'reportSentHelp': {
      AppLanguage.bisaya: 'Salamat. Tan-awon kini sa barangay representative.',
      AppLanguage.english:
          'Thank you. The barangay representative will review it.',
      AppLanguage.filipino: 'Salamat. Susuriin ito ng barangay representative.',
    },
    'done': {
      AppLanguage.bisaya: 'Human',
      AppLanguage.english: 'Done',
      AppLanguage.filipino: 'Tapos',
    },
    'select': {
      AppLanguage.bisaya: 'Pagpili',
      AppLanguage.english: 'Choose',
      AppLanguage.filipino: 'Pumili',
    },
    'locNearTank': {
      AppLanguage.bisaya: 'Duol sa tangke (pasong)',
      AppLanguage.english: 'Near the water tank',
      AppLanguage.filipino: 'Malapit sa tangke',
    },
    'locMainRoad': {
      AppLanguage.bisaya: 'Dapit sa main road',
      AppLanguage.english: 'Along the main road',
      AppLanguage.filipino: 'Sa may main road',
    },
    'locInside': {
      AppLanguage.bisaya: 'Sulod sa Purok 1',
      AppLanguage.english: 'Inside Purok 1',
      AppLanguage.filipino: 'Sa loob ng Purok 1',
    },
    'locOther': {
      AppLanguage.bisaya: 'Uban nga dapit',
      AppLanguage.english: 'Another location',
      AppLanguage.filipino: 'Ibang lugar',
    },
    'problemNoWater': {
      AppLanguage.bisaya: 'Walay tubig',
      AppLanguage.english: 'No water',
      AppLanguage.filipino: 'Walang tubig',
    },
    'problemWeak': {
      AppLanguage.bisaya: 'Hinay ang agas',
      AppLanguage.english: 'Weak water flow',
      AppLanguage.filipino: 'Mahina ang daloy',
    },
    'problemPump': {
      AppLanguage.bisaya: 'Problema sa pump',
      AppLanguage.english: 'Pump problem',
      AppLanguage.filipino: 'Problema sa pump',
    },
    'problemLeak': {
      AppLanguage.bisaya: 'Adunay tagas',
      AppLanguage.english: 'Water leak',
      AppLanguage.filipino: 'May tagas',
    },
    'problemOther': {
      AppLanguage.bisaya: 'Uban nga problema',
      AppLanguage.english: 'Another problem',
      AppLanguage.filipino: 'Ibang problema',
    },
    'contactNone': {
      AppLanguage.bisaya: 'Dili kinahanglan kontakon',
      AppLanguage.english: 'No contact needed',
      AppLanguage.filipino: 'Hindi kailangang kontakin',
    },
    'contactText': {
      AppLanguage.bisaya: 'Text message',
      AppLanguage.english: 'Text message',
      AppLanguage.filipino: 'Text message',
    },
    'contactCall': {
      AppLanguage.bisaya: 'Tawag',
      AppLanguage.english: 'Phone call',
      AppLanguage.filipino: 'Tawag',
    },
    'adminAccess': {
      AppLanguage.bisaya: 'Staff Login',
      AppLanguage.english: 'Staff Login',
      AppLanguage.filipino: 'Staff Login',
    },
    'adminLoginHelp': {
      AppLanguage.bisaya: 'Para lamang sa barangay representative.',
      AppLanguage.english: 'For the barangay representative only.',
      AppLanguage.filipino: 'Para lamang sa barangay representative.',
    },
    'username': {
      AppLanguage.bisaya: 'Username',
      AppLanguage.english: 'Username',
      AppLanguage.filipino: 'Username',
    },
    'password': {
      AppLanguage.bisaya: 'Password',
      AppLanguage.english: 'Password',
      AppLanguage.filipino: 'Password',
    },
    'login': {
      AppLanguage.bisaya: 'Sulod',
      AppLanguage.english: 'Log in',
      AppLanguage.filipino: 'Mag-log in',
    },
    'invalidLogin': {
      AppLanguage.bisaya: 'Sayop ang username o password.',
      AppLanguage.english: 'Incorrect username or password.',
      AppLanguage.filipino: 'Mali ang username o password.',
    },
    'fieldRequired': {
      AppLanguage.bisaya: 'Kinahanglan kini.',
      AppLanguage.english: 'This field is required.',
      AppLanguage.filipino: 'Kailangan ito.',
    },
    'adminPanel': {
      AppLanguage.bisaya: 'Barangay Staff',
      AppLanguage.english: 'Barangay Staff',
      AppLanguage.filipino: 'Barangay Staff',
    },
    'updates': {
      AppLanguage.bisaya: 'Mga pahibalo',
      AppLanguage.english: 'Updates',
      AppLanguage.filipino: 'Mga abiso',
    },
    'reports': {
      AppLanguage.bisaya: 'Mga report',
      AppLanguage.english: 'Reports',
      AppLanguage.filipino: 'Mga report',
    },
    'schedule': {
      AppLanguage.bisaya: 'Oras',
      AppLanguage.english: 'Schedule',
      AppLanguage.filipino: 'Oras',
    },
    'logout': {
      AppLanguage.bisaya: 'Gawas',
      AppLanguage.english: 'Log out',
      AppLanguage.filipino: 'Mag-log out',
    },
    'logoutQuestion': {
      AppLanguage.bisaya: 'Mogawas sa staff area?',
      AppLanguage.english: 'Log out of the staff area?',
      AppLanguage.filipino: 'Mag-log out sa staff area?',
    },
    'cancel': {
      AppLanguage.bisaya: 'Kanselahon',
      AppLanguage.english: 'Cancel',
      AppLanguage.filipino: 'Kanselahin',
    },
    'createUpdate': {
      AppLanguage.bisaya: 'Paghimo og pahibalo',
      AppLanguage.english: 'Create an update',
      AppLanguage.filipino: 'Gumawa ng abiso',
    },
    'waterSituation': {
      AppLanguage.bisaya: 'Unsa ang kahimtang?',
      AppLanguage.english: 'What is the water status?',
      AppLanguage.filipino: 'Ano ang kalagayan ng tubig?',
    },
    'messageResidents': {
      AppLanguage.bisaya: 'Mensahe para sa mga residente',
      AppLanguage.english: 'Message for residents',
      AppLanguage.filipino: 'Mensahe para sa mga residente',
    },
    'messageHint': {
      AppLanguage.bisaya: 'Gamita ang mubo ug sayon nga mga pulong.',
      AppLanguage.english: 'Use short and easy-to-understand words.',
      AppLanguage.filipino: 'Gumamit ng maikli at madaling unawain na salita.',
    },
    'confirmedReturn': {
      AppLanguage.bisaya: 'Kumpirmado ang oras sa pagbalik',
      AppLanguage.english: 'The return time is confirmed',
      AppLanguage.filipino: 'Kumpirmado ang oras ng pagbabalik',
    },
    'confirmedReturnHelp': {
      AppLanguage.bisaya: 'Ipakita lamang kung sigurado na ang oras.',
      AppLanguage.english: 'Only show a return time when it is certain.',
      AppLanguage.filipino: 'Ipakita lamang kung tiyak na ang oras.',
    },
    'chooseTime': {
      AppLanguage.bisaya: 'Pilia ang oras',
      AppLanguage.english: 'Choose time',
      AppLanguage.filipino: 'Pumili ng oras',
    },
    'publish': {
      AppLanguage.bisaya: 'I-post ang pahibalo',
      AppLanguage.english: 'Publish update',
      AppLanguage.filipino: 'I-post ang abiso',
    },
    'published': {
      AppLanguage.bisaya: 'Na-post na ang pahibalo.',
      AppLanguage.english: 'The update is now published.',
      AppLanguage.filipino: 'Na-post na ang abiso.',
    },
    'yourPosts': {
      AppLanguage.bisaya: 'Mga pahibalo nga na-post',
      AppLanguage.english: 'Published updates',
      AppLanguage.filipino: 'Mga naka-post na abiso',
    },
    'waterAdvisory': {
      AppLanguage.bisaya: 'Pahibalo sa Suplay sa Tubig',
      AppLanguage.english: 'Water Supply Advisory',
      AppLanguage.filipino: 'Abiso sa Suplay ng Tubig',
    },
    'pdfAdvisoryHelp': {
      AppLanguage.bisaya:
          'I-print o i-save ang kasamtangang oras ug tanang pahibalo isip PDF.',
      AppLanguage.english: 'Print or save the current schedule and all published notices as a PDF.',
      AppLanguage.filipino: 'I-print o i-save bilang PDF ang kasalukuyang oras at lahat ng abiso.',
    },
    'printAdvisory': {
      AppLanguage.bisaya: 'I-print ang pahibalo',
      AppLanguage.english: 'Print advisory',
      AppLanguage.filipino: 'I-print ang abiso',
    },
    'savePdf': {
      AppLanguage.bisaya: 'I-save ang PDF',
      AppLanguage.english: 'Save PDF',
      AppLanguage.filipino: 'I-save ang PDF',
    },
    'publishedNotices': {
      AppLanguage.bisaya: 'Mga pahibalo nga na-post',
      AppLanguage.english: 'Published notices',
      AppLanguage.filipino: 'Mga naka-post na abiso',
    },
    'generatedOn': {
      AppLanguage.bisaya: 'Gihimo niadtong',
      AppLanguage.english: 'Generated on',
      AppLanguage.filipino: 'Ginawa noong',
    },
    'pdfError': {
      AppLanguage.bisaya: 'Dili mahimo ang PDF. Sulayi pag-usab.',
      AppLanguage.english: 'The PDF could not be created. Please try again.',
      AppLanguage.filipino: 'Hindi nagawa ang PDF. Subukan muli.',
    },
    'delete': {
      AppLanguage.bisaya: 'Papason',
      AppLanguage.english: 'Delete',
      AppLanguage.filipino: 'Burahin',
    },
    'deleteQuestion': {
      AppLanguage.bisaya: 'Papason kini nga pahibalo?',
      AppLanguage.english: 'Delete this update?',
      AppLanguage.filipino: 'Burahin ang abisong ito?',
    },
    'residentReports': {
      AppLanguage.bisaya: 'Mga report gikan sa residente',
      AppLanguage.english: 'Reports from residents',
      AppLanguage.filipino: 'Mga report mula sa residente',
    },
    'noReports': {
      AppLanguage.bisaya: 'Wala pay report.',
      AppLanguage.english: 'There are no reports yet.',
      AppLanguage.filipino: 'Wala pang report.',
    },
    'anonymous': {
      AppLanguage.bisaya: 'Walay ngalan',
      AppLanguage.english: 'No name provided',
      AppLanguage.filipino: 'Walang pangalan',
    },
    'contact': {
      AppLanguage.bisaya: 'Pagkontak',
      AppLanguage.english: 'Contact',
      AppLanguage.filipino: 'Contact',
    },
    'status': {
      AppLanguage.bisaya: 'Kahimtang sa report',
      AppLanguage.english: 'Report status',
      AppLanguage.filipino: 'Kalagayan ng report',
    },
    'reportNew': {
      AppLanguage.bisaya: 'Bag-o',
      AppLanguage.english: 'New',
      AppLanguage.filipino: 'Bago',
    },
    'reportProgress': {
      AppLanguage.bisaya: 'Gitan-aw na',
      AppLanguage.english: 'In progress',
      AppLanguage.filipino: 'Inaayos',
    },
    'reportResolved': {
      AppLanguage.bisaya: 'Nasulbad na',
      AppLanguage.english: 'Resolved',
      AppLanguage.filipino: 'Nalutas na',
    },
    'waterSchedule': {
      AppLanguage.bisaya: 'Oras sa suplay sa tubig',
      AppLanguage.english: 'Water supply schedule',
      AppLanguage.filipino: 'Oras ng suplay ng tubig',
    },
    'scheduleIntro': {
      AppLanguage.bisaya:
          'Kini nga oras makita dayon sa home screen sa mga residente.',
      AppLanguage.english:
          'Residents will immediately see this time on the home screen.',
      AppLanguage.filipino:
          'Makikita agad ito ng mga residente sa home screen.',
    },
    'starts': {
      AppLanguage.bisaya: 'Magsugod',
      AppLanguage.english: 'Starts',
      AppLanguage.filipino: 'Magsisimula',
    },
    'ends': {
      AppLanguage.bisaya: 'Matapos',
      AppLanguage.english: 'Ends',
      AppLanguage.filipino: 'Matatapos',
    },
    'saveSchedule': {
      AppLanguage.bisaya: 'I-save ang oras',
      AppLanguage.english: 'Save schedule',
      AppLanguage.filipino: 'I-save ang oras',
    },
    'scheduleSaved': {
      AppLanguage.bisaya: 'Na-update na ang oras sa tubig.',
      AppLanguage.english: 'The water schedule was updated.',
      AppLanguage.filipino: 'Na-update na ang oras ng tubig.',
    },
    'invalidSchedule': {
      AppLanguage.bisaya:
          'Ang oras sa pagtapos kinahanglan mas ulahi sa pagsugod.',
      AppLanguage.english: 'The end time must be later than the start time.',
      AppLanguage.filipino: 'Dapat mas huli ang oras ng pagtatapos.',
    },
    'normal': {
      AppLanguage.bisaya: 'Normal ang tubig',
      AppLanguage.english: 'Normal water supply',
      AppLanguage.filipino: 'Normal ang suplay',
    },
    'interrupted': {
      AppLanguage.bisaya: 'Naputol ang tubig',
      AppLanguage.english: 'Water interrupted',
      AppLanguage.filipino: 'Naputol ang tubig',
    },
    'pumpProblemStatus': {
      AppLanguage.bisaya: 'Problema sa pump',
      AppLanguage.english: 'Pump problem',
      AppLanguage.filipino: 'Problema sa pump',
    },
    'restored': {
      AppLanguage.bisaya: 'Nibalik ang tubig',
      AppLanguage.english: 'Water restored',
      AppLanguage.filipino: 'Bumalik ang tubig',
    },
    'expectedReturn': {
      AppLanguage.bisaya: 'Gilaumang pagbalik',
      AppLanguage.english: 'Expected return',
      AppLanguage.filipino: 'Inaasahang pagbabalik',
    },
    'justNow': {
      AppLanguage.bisaya: 'Bag-o lang',
      AppLanguage.english: 'Just now',
      AppLanguage.filipino: 'Ngayon lang',
    },
  };

  String t(String key) => _values[key]?[language] ?? key;

  String valueOrKey(String value) =>
      _values.containsKey(value) ? t(value) : value;

  String languageName(AppLanguage value) {
    return switch (value) {
      AppLanguage.bisaya => 'Bisaya',
      AppLanguage.english => 'English',
      AppLanguage.filipino => 'Filipino',
    };
  }

  String waterStatus(WaterStatus status) {
    return t(switch (status) {
      WaterStatus.normal => 'normal',
      WaterStatus.interrupted => 'interrupted',
      WaterStatus.pumpProblem => 'pumpProblemStatus',
      WaterStatus.restored => 'restored',
    });
  }

  String reportStatus(ReportStatus status) {
    return t(switch (status) {
      ReportStatus.newReport => 'reportNew',
      ReportStatus.inProgress => 'reportProgress',
      ReportStatus.resolved => 'reportResolved',
    });
  }

  String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute ${time.period == DayPeriod.am ? 'AM' : 'PM'}';
  }

  String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    if (difference.inMinutes < 1) return t('justNow');
    final month = const [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ][dateTime.month - 1];
    final time = formatTime(TimeOfDay.fromDateTime(dateTime));
    return '$month ${dateTime.day}, $time';
  }
}

extension AppStringsContext on BuildContext {
  AppStrings get strings => AppStrings(_controllerLanguage(this));
}

AppLanguage _controllerLanguage(BuildContext context) {
  final marker = context.dependOnInheritedWidgetOfExactType<_LanguageMarker>();
  if (marker == null) throw StateError('LanguageMarker is missing.');
  return marker.language;
}

class LanguageMarker extends StatelessWidget {
  const LanguageMarker({
    super.key,
    required this.language,
    required this.child,
  });

  final AppLanguage language;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _LanguageMarker(language: language, child: child);
  }
}

class _LanguageMarker extends InheritedWidget {
  const _LanguageMarker({required this.language, required super.child});

  final AppLanguage language;

  @override
  bool updateShouldNotify(_LanguageMarker oldWidget) =>
      oldWidget.language != language;
}
