import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../core/app_controller.dart';
import '../../core/app_strings.dart';
import '../../core/app_theme.dart';
import '../../models/app_models.dart';
import '../../services/water_advisory_pdf_service.dart';
import '../../widgets/common_widgets.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _selectedIndex = 0;

  Future<void> _logout() async {
    final strings = context.strings;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.t('logoutQuestion')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(strings.t('cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(strings.t('logout')),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    AppScope.of(context).logout();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 72,
        titleSpacing: 16,
        title: const AppHeaderTitle(admin: true),
        actions: [
          const Center(child: LanguageMenuButton()),
          const SizedBox(width: 2),
          IconButton(
            tooltip: strings.t('logout'),
            onPressed: _logout,
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          _AdminUpdatesScreen(),
          _AdminReportsScreen(),
          _AdminScheduleScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (value) =>
            setState(() => _selectedIndex = value),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.campaign_outlined),
            selectedIcon: const Icon(Icons.campaign_rounded),
            label: strings.t('updates'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.inbox_outlined),
            selectedIcon: const Icon(Icons.inbox_rounded),
            label: strings.t('reports'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.schedule_outlined),
            selectedIcon: const Icon(Icons.schedule_rounded),
            label: strings.t('schedule'),
          ),
        ],
      ),
    );
  }
}

class _AdminUpdatesScreen extends StatefulWidget {
  const _AdminUpdatesScreen();

  @override
  State<_AdminUpdatesScreen> createState() => _AdminUpdatesScreenState();
}

class _AdminUpdatesScreenState extends State<_AdminUpdatesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  WaterStatus _status = WaterStatus.normal;
  bool _hasConfirmedReturn = false;
  TimeOfDay _returnTime = const TimeOfDay(hour: 10, minute: 0);
  bool _isCreatingPdf = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _chooseReturnTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: _returnTime,
      helpText: context.strings.t('chooseTime'),
    );
    if (selected != null) setState(() => _returnTime = selected);
  }

  void _publish() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final strings = context.strings;
    AppScope.of(context).addPost(
      status: _status,
      message: _messageController.text,
      returnTime: _hasConfirmedReturn ? _returnTime : null,
    );
    _messageController.clear();
    setState(() {
      _status = WaterStatus.normal;
      _hasConfirmedReturn = false;
    });
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(strings.t('published'))));
  }

  Future<void> _printAdvisory() async {
    await _runPdfAction((controller, strings) async {
      await Printing.layoutPdf(
        name: 'TubigTugon_Water_Advisory',
        onLayout: (format) => WaterAdvisoryPdfService.build(
          strings: strings,
          schedule: controller.schedule,
          notices: controller.posts,
          pageFormat: format,
        ),
      );
    });
  }

  Future<void> _saveAdvisory() async {
    await _runPdfAction((controller, strings) async {
      final bytes = await WaterAdvisoryPdfService.build(
        strings: strings,
        schedule: controller.schedule,
        notices: controller.posts,
        pageFormat: PdfPageFormat.a4,
      );
      await Printing.sharePdf(
        bytes: bytes,
        filename: 'TubigTugon_Water_Advisory.pdf',
      );
    });
  }

  Future<void> _runPdfAction(
    Future<void> Function(AppController controller, AppStrings strings) action,
  ) async {
    if (_isCreatingPdf) return;
    setState(() => _isCreatingPdf = true);
    final controller = AppScope.of(context);
    final strings = context.strings;
    try {
      await action(controller, strings);
    } catch (_) {
      if (mounted) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.hideCurrentSnackBar();
        messenger.showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.danger,
            content: Text(strings.t('pdfError')),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCreatingPdf = false);
    }
  }

  Future<void> _deletePost(WaterPost post) async {
    final strings = context.strings;
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.t('deleteQuestion')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(strings.t('cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppTheme.danger),
            child: Text(strings.t('delete')),
          ),
        ],
      ),
    );
    if (shouldDelete == true && mounted) {
      AppScope.of(context).deletePost(post.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final strings = context.strings;
    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            strings.t('createUpdate'),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.picture_as_pdf_rounded,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        strings.t('waterAdvisory'),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  strings.t('pdfAdvisoryHelp'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    OutlinedButton.icon(
                      key: const Key('print-advisory-button'),
                      onPressed: _isCreatingPdf ? null : _printAdvisory,
                      icon: const Icon(Icons.print_rounded),
                      label: Text(strings.t('printAdvisory')),
                    ),
                    FilledButton.icon(
                      key: const Key('save-pdf-button'),
                      onPressed: _isCreatingPdf ? null : _saveAdvisory,
                      icon: const Icon(Icons.download_rounded),
                      label: Text(strings.t('savePdf')),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    strings.t('waterSituation'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: WaterStatus.values
                        .map(
                          (status) => ChoiceChip(
                            label: Text(strings.waterStatus(status)),
                            selected: _status == status,
                            onSelected: (_) => setState(() => _status = status),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    strings.t('messageResidents'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    strings.t('messageHint'),
                    style: const TextStyle(color: AppTheme.muted),
                  ),
                  const SizedBox(height: 9),
                  TextFormField(
                    key: const Key('admin-message-field'),
                    controller: _messageController,
                    minLines: 4,
                    maxLines: 7,
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? strings.t('fieldRequired')
                        : null,
                  ),
                  const SizedBox(height: 14),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _hasConfirmedReturn,
                    onChanged: (value) =>
                        setState(() => _hasConfirmedReturn = value),
                    title: Text(
                      strings.t('confirmedReturn'),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(strings.t('confirmedReturnHelp')),
                  ),
                  if (_hasConfirmedReturn) ...[
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _chooseReturnTime,
                      icon: const Icon(Icons.schedule_rounded),
                      label: Text(
                        '${strings.t('chooseTime')}: ${strings.formatTime(_returnTime)}',
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    key: const Key('publish-update-button'),
                    onPressed: _publish,
                    icon: const Icon(Icons.publish_rounded),
                    label: Text(strings.t('publish')),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            strings.t('yourPosts'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ...controller.posts.map(
            (post) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: WaterStatusBadge(status: post.status)),
                        IconButton(
                          tooltip: strings.t('delete'),
                          onPressed: controller.posts.length > 1
                              ? () => _deletePost(post)
                              : null,
                          icon: const Icon(Icons.delete_outline_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      strings.valueOrKey(post.message),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    if (post.returnTime != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        '${strings.t('expectedReturn')}: ${strings.formatTime(post.returnTime!)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      strings.formatDateTime(post.createdAt),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminReportsScreen extends StatelessWidget {
  const _AdminReportsScreen();

  Color _statusColor(ReportStatus status) {
    return switch (status) {
      ReportStatus.newReport => AppTheme.danger,
      ReportStatus.inProgress => AppTheme.warning,
      ReportStatus.resolved => AppTheme.success,
    };
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final strings = context.strings;
    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            strings.t('residentReports'),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 6),
          Text(
            '${controller.reports.where((report) => report.status == ReportStatus.newReport).length} ${strings.t('reportNew').toLowerCase()}',
            style: const TextStyle(fontSize: 17, color: AppTheme.muted),
          ),
          const SizedBox(height: 16),
          if (controller.reports.isEmpty)
            EmptyState(
              icon: Icons.inbox_outlined,
              message: strings.t('noReports'),
            )
          else
            ...controller.reports.map(
              (report) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 11,
                            height: 11,
                            decoration: BoxDecoration(
                              color: _statusColor(report.status),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Text(
                              strings.valueOrKey(report.problem),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Text(
                            strings.formatDateTime(report.createdAt),
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.muted,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 26),
                      _ReportDetail(
                        icon: Icons.location_on_outlined,
                        text: strings.valueOrKey(report.location),
                      ),
                      if (report.details.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        _ReportDetail(
                          icon: Icons.notes_rounded,
                          text: report.details,
                        ),
                      ],
                      const SizedBox(height: 10),
                      _ReportDetail(
                        icon: Icons.person_outline_rounded,
                        text: report.name.isEmpty
                            ? strings.t('anonymous')
                            : report.name,
                      ),
                      const SizedBox(height: 10),
                      _ReportDetail(
                        icon: Icons.phone_outlined,
                        text:
                            '${strings.t('contact')}: ${strings.valueOrKey(report.contactMethod)}',
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<ReportStatus>(
                        key: ValueKey('${report.id}-${report.status.name}'),
                        initialValue: report.status,
                        decoration: InputDecoration(
                          labelText: strings.t('status'),
                        ),
                        items: ReportStatus.values
                            .map(
                              (status) => DropdownMenuItem(
                                value: status,
                                child: Text(strings.reportStatus(status)),
                              ),
                            )
                            .toList(),
                        onChanged: (status) {
                          if (status != null) {
                            controller.updateReportStatus(report.id, status);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ReportDetail extends StatelessWidget {
  const _ReportDetail({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 21, color: AppTheme.muted),
        const SizedBox(width: 9),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class _AdminScheduleScreen extends StatefulWidget {
  const _AdminScheduleScreen();

  @override
  State<_AdminScheduleScreen> createState() => _AdminScheduleScreenState();
}

class _AdminScheduleScreenState extends State<_AdminScheduleScreen> {
  TimeOfDay? _start;
  TimeOfDay? _end;

  Future<void> _pickStart() async {
    final controller = AppScope.of(context);
    final selected = await showTimePicker(
      context: context,
      initialTime: _start ?? controller.schedule.start,
    );
    if (selected != null) setState(() => _start = selected);
  }

  Future<void> _pickEnd() async {
    final controller = AppScope.of(context);
    final selected = await showTimePicker(
      context: context,
      initialTime: _end ?? controller.schedule.end,
    );
    if (selected != null) setState(() => _end = selected);
  }

  int _minutes(TimeOfDay time) => time.hour * 60 + time.minute;

  void _save() {
    final controller = AppScope.of(context);
    final strings = context.strings;
    final start = _start ?? controller.schedule.start;
    final end = _end ?? controller.schedule.end;
    if (_minutes(end) <= _minutes(start)) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.danger,
          content: Text(strings.t('invalidSchedule')),
        ),
      );
      return;
    }
    controller.updateSchedule(start, end);
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(strings.t('scheduleSaved'))));
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final strings = context.strings;
    final start = _start ?? controller.schedule.start;
    final end = _end ?? controller.schedule.end;
    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            strings.t('waterSchedule'),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            strings.t('scheduleIntro'),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppTheme.waterBlue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Text(
                        strings.t('todaySchedule'),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${strings.formatTime(start)} – ${strings.formatTime(end)}',
                          style: const TextStyle(
                            color: AppTheme.primaryDark,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _TimeButton(
                  label: strings.t('starts'),
                  value: strings.formatTime(start),
                  onPressed: _pickStart,
                ),
                const SizedBox(height: 12),
                _TimeButton(
                  label: strings.t('ends'),
                  value: strings.formatTime(end),
                  onPressed: _pickEnd,
                ),
                const SizedBox(height: 22),
                FilledButton.icon(
                  key: const Key('save-schedule-button'),
                  onPressed: _save,
                  icon: const Icon(Icons.save_rounded),
                  label: Text(strings.t('saveSchedule')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeButton extends StatelessWidget {
  const _TimeButton({
    required this.label,
    required this.value,
    required this.onPressed,
  });

  final String label;
  final String value;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            const Icon(Icons.access_time_rounded),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 14, color: AppTheme.muted),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.edit_outlined),
          ],
        ),
      ),
    );
  }
}
