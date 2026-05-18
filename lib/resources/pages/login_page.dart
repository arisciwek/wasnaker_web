import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/networking/api_service.dart';
import '/bootstrap/extensions.dart';
import '/resources/pages/home_page.dart';

class LoginPage extends NyStatefulWidget {
  static RouteView path = ("/login", (_) => LoginPage());

  LoginPage({super.key}) : super(child: () => _LoginPageState());
}

class _LoginPageState extends NyPage<LoginPage> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword     = true;
  String? _errorMessage;

  @override
  get init => () {};

  @override
  LoadingStyle get loadingStyle => LoadingStyle.none();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final email    = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Email and password are required');
      return;
    }
    setState(() => _errorMessage = null);

    await lockRelease('login', perform: () async {
      final response = await api<ApiService>(
        (service) => service.login(email, password),
      );

      if (response == null) {
        setState(() => _errorMessage = 'Connection failed. Check your network.');
        return;
      }
      if (response['status'] != true) {
        setState(() => _errorMessage = response['message'] ?? 'Login failed');
        return;
      }

      final data  = response['data'];
      final token = data['token'];
      final staff = data['staff'];

      await Auth.set((_) => {'token': token, 'staff': staff});

      showToastSuccess(
        title: 'Welcome back',
        description: '${staff['firstname']} ${staff['lastname']}',
      );

      routeTo(HomePage.path);
    });
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.general.background,
      body: Row(
        children: [
          // ── Kiri: Branding ────────────────────────────────────────────────
          Expanded(
            flex: 5,
            child: Container(
              color: context.color.general.primaryAccent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.verified_outlined,
                      size: 80, color: Colors.white),
                  const SizedBox(height: 24),
                  const Text('Wasnaker',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      )),
                  const SizedBox(height: 12),
                  Text(
                    'Labor Inspection Services Platform',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withAlpha(200)),
                  ),
                ],
              ),
            ),
          ),

          // ── Kanan: Form ───────────────────────────────────────────────────
          Expanded(
            flex: 4,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Sign In',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.color.general.content,
                              )),
                      const SizedBox(height: 8),
                      Text('Sign in to your Wasnaker account',
                          style: TextStyle(
                              color: context.color.general.primaryAccent)),
                      const SizedBox(height: 40),

                      if (_errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            border: Border.all(color: Colors.red.shade200),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(_errorMessage!,
                              style: TextStyle(color: Colors.red.shade700)),
                        ),
                        const SizedBox(height: 16),
                      ],

                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: context.color.general.surface,
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _onLogin(),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: context.color.general.surface,
                        ),
                      ),
                      const SizedBox(height: 32),

                      isLocked('login')
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: _onLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    context.color.general.primaryAccent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 18),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                elevation: 0,
                              ),
                              child: const Text('Sign In',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
