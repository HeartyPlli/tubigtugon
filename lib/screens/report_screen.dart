import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../core/app_strings.dart';
import '../widgets/common_widgets.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _detailsController = TextEditingController();
  final _nameController = TextEditingController();

  String? _location;
  String? _problem;
  String _contact = 'contactNone';

  static const _locations = [
    'locNearTank',
    'locMainRoad',
    'locInside',
    'locOther',
  ];
  static const _problems = [
    'problemNoWater',
    'problemWeak',
    'problemPump',
    'problemLeak',
    'problemOther',
  ];
  static const _contacts = ['contactNone', 'contactText', 'contactCall'];

  @override
  void dispose() {
    _detailsController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final strings = context.strings;
    AppScope.of(context).addReport(
      location: _location!,
      problem: _problem!,
      details: _detailsController.text,
      contactMethod: _contact,
      name: _nameController.text,
    );

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.check_circle_rounded,
          color: Colors.green,
          size: 46,
        ),
        title: Text(strings.t('reportSent')),
        content: Text(strings.t('reportSentHelp'), textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(strings.t('done')),
          ),
        ],
      ),
    );

    if (!mounted) return;
    _formKey.currentState?.reset();
    _detailsController.clear();
    _nameController.clear();
    setState(() {
      _location = null;
      _problem = null;
      _contact = 'contactNone';
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return PageBody(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              strings.t('reportTitle'),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              strings.t('reportIntro'),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            SectionCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _FieldLabel(number: 1, text: strings.t('location')),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    key: const Key('location-dropdown'),
                    initialValue: _location,
                    isExpanded: true,
                    hint: Text(strings.t('select')),
                    items: _locations
                        .map(
                          (key) => DropdownMenuItem(
                            value: key,
                            child: Text(strings.t(key)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _location = value),
                    validator: (value) =>
                        value == null ? strings.t('requiredField') : null,
                  ),
                  const SizedBox(height: 20),
                  _FieldLabel(number: 2, text: strings.t('problemType')),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    key: const Key('problem-dropdown'),
                    initialValue: _problem,
                    isExpanded: true,
                    hint: Text(strings.t('select')),
                    items: _problems
                        .map(
                          (key) => DropdownMenuItem(
                            value: key,
                            child: Text(strings.t(key)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _problem = value),
                    validator: (value) =>
                        value == null ? strings.t('requiredField') : null,
                  ),
                  const SizedBox(height: 20),
                  _FieldLabel(number: 3, text: strings.t('detailsOptional')),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _detailsController,
                    minLines: 4,
                    maxLines: 6,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: strings.t('detailsHint'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _FieldLabel(number: 4, text: strings.t('contactOptional')),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _contact,
                    isExpanded: true,
                    items: _contacts
                        .map(
                          (key) => DropdownMenuItem(
                            value: key,
                            child: Text(strings.t(key)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _contact = value ?? 'contactNone'),
                  ),
                  const SizedBox(height: 20),
                  _FieldLabel(number: 5, text: strings.t('nameOptional')),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: strings.t('nameHint'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    key: const Key('submit-report-button'),
                    onPressed: _submit,
                    icon: const Icon(Icons.send_rounded),
                    label: Text(strings.t('submitReport')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$number. $text',
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}
