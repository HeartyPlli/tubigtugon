import 'package:flutter/material.dart';

import '../core/app_theme.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 44, this.onTap, this.tooltip});

  final double size;
  final VoidCallback? onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final logo = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(size * .32),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.water_drop_rounded, color: Colors.white, size: size * .6),
          Positioned(
            right: size * .13,
            bottom: size * .12,
            child: Container(
              width: size * .26,
              height: size * .26,
              decoration: BoxDecoration(
                color: const Color(0xFF35B6A6),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return logo;
    return Semantics(
      button: true,
      label: tooltip,
      child: Tooltip(
        message: tooltip ?? '',
        child: InkWell(
          key: const Key('app-logo-button'),
          onTap: onTap,
          borderRadius: BorderRadius.circular(size * .32),
          child: logo,
        ),
      ),
    );
  }
}
