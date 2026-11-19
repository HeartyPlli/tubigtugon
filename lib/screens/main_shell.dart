import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../core/app_strings.dart';
import '../widgets/common_widgets.dart';
import 'admin/admin_shell.dart';
import 'admin_login_screen.dart';
import 'home_screen.dart';
import 'report_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  void _openStaffAccess() {
    final controller = AppScope.of(context);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => controller.isAdminLoggedIn
            ? const AdminShell()
            : const AdminLoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        titleSpacing: 16,
        title: AppHeaderTitle(onLogoTap: _openStaffAccess),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(child: LanguageMenuButton()),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(onStartReport: () => setState(() => _selectedIndex = 1)),
          const ReportScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (value) =>
            setState(() => _selectedIndex = value),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: strings.t('home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.campaign_outlined),
            selectedIcon: const Icon(Icons.campaign_rounded),
            label: strings.t('report'),
          ),
        ],
      ),
    );
  }
}
