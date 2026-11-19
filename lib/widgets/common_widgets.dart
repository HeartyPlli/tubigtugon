import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../core/app_strings.dart';
import '../core/app_theme.dart';
import '../models/app_models.dart';
import 'app_logo.dart';

class AppHeaderTitle extends StatelessWidget {
  const AppHeaderTitle({super.key, this.onLogoTap, this.admin = false});

  final VoidCallback? onLogoTap;
  final bool admin;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return Row(
      children: [
        AppLogo(size: 42, onTap: onLogoTap, tooltip: strings.t('adminAccess')),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TubigTugon',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppTheme.primaryDark,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (admin)
                Text(
                  strings.t('adminPanel'),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppTheme.muted),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class LanguageMenuButton extends StatelessWidget {
  const LanguageMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final strings = context.strings;
    return PopupMenuButton<AppLanguage>(
      key: const Key('language-menu'),
      tooltip: strings.t('language'),
      initialValue: controller.language,
      onSelected: controller.setLanguage,
      itemBuilder: (context) => AppLanguage.values
          .map(
            (language) => PopupMenuItem(
              value: language,
              child: Row(
                children: [
                  if (language == controller.language)
                    const Icon(Icons.check_rounded, size: 20)
                  else
                    const SizedBox(width: 20),
                  const SizedBox(width: 10),
                  Text(strings.languageName(language)),
                ],
              ),
            ),
          )
          .toList(),
      child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFB8C2CC)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.translate_rounded, size: 20),
            const SizedBox(width: 6),
            Text(
              strings.languageName(controller.language),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class PageBody extends StatelessWidget {
  const PageBody({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(18, 18, 18, 28),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SingleChildScrollView(padding: padding, child: child),
        ),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(18),
        child: child,
      ),
    );
  }
}

class WaterStatusBadge extends StatelessWidget {
  const WaterStatusBadge({super.key, required this.status});

  final WaterStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      WaterStatus.normal => AppTheme.success,
      WaterStatus.interrupted => AppTheme.warning,
      WaterStatus.pumpProblem => AppTheme.danger,
      WaterStatus.restored => AppTheme.primary,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: .35)),
      ),
      child: Text(
        context.strings.waterStatus(status),
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 44),
      child: Column(
        children: [
          Icon(icon, size: 48, color: AppTheme.muted),
          const SizedBox(height: 12),
          Text(message, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
