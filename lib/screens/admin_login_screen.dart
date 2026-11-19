import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../core/app_strings.dart';
import '../core/app_theme.dart';
import '../widgets/app_logo.dart';
import '../widgets/common_widgets.dart';
import 'admin/admin_shell.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _loginError;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    setState(() => _loginError = null);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final success = AppScope.of(context)
        .login(_usernameController.text, _passwordController.text);
    if (!success) {
      setState(() => _loginError = context.strings.t('invalidLogin'));
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const AdminShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(child: LanguageMenuButton()),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Align(child: AppLogo(size: 76)),
                    const SizedBox(height: 14),
                    const Text(
                      'TubigTugon',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.primaryDark,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      strings.t('adminAccess'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      strings.t('adminLoginHelp'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppTheme.muted,
                      ),
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      key: const Key('username-field'),
                      controller: _usernameController,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.username],
                      decoration: InputDecoration(
                        labelText: strings.t('username'),
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? strings.t('fieldRequired')
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('password-field'),
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      autofillHints: const [AutofillHints.password],
                      onFieldSubmitted: (_) => _login(),
                      decoration: InputDecoration(
                        labelText: strings.t('password'),
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          tooltip: _obscurePassword
                              ? 'Show password'
                              : 'Hide password',
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: (value) => (value == null || value.isEmpty)
                          ? strings.t('fieldRequired')
                          : null,
                    ),
                    if (_loginError != null) ...[
                      const SizedBox(height: 12),
                      Semantics(
                        liveRegion: true,
                        child: Text(
                          _loginError!,
                          style: const TextStyle(
                            color: AppTheme.danger,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 22),
                    FilledButton.icon(
                      key: const Key('login-button'),
                      onPressed: _login,
                      icon: const Icon(Icons.login_rounded),
                      label: Text(strings.t('login')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
