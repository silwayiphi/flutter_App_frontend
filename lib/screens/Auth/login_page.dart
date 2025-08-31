import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  InputDecoration _decoration({
    required String label,
    required IconData prefix,
    Widget? suffix,
  }) {
    const radius = BorderRadius.all(Radius.circular(20));
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.white,
        fontStyle: FontStyle.italic,
        letterSpacing: 0.6,
      ),
      prefixIcon: Icon(prefix, color: Colors.white),
      suffixIcon: suffix,
      enabledBorder: const OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: Colors.white, width: 1.5),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _email.text.trim();
    final pw = _password.text;

    setState(() => _loading = true);
    final messenger = ScaffoldMessenger.of(context);

    try {
      // 1) Create account (no email verification)
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pw);

      // 2) Create profile in Firestore
      await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
        'email': email,
        'role': 'student',
        'createdAt': FieldValue.serverTimestamp(),
        'stream': null, // fill after they choose a stream
        'provider': 'password',
        'status': 'active',
      });

      // 3) Sign out so they must log in with email+password
      await FirebaseAuth.instance.signOut();

      messenger.showSnackBar(
        const SnackBar(content: Text('Account created. Please sign in.')),
      );

      if (!mounted) return;
      context.go('/login/public');
    } on FirebaseAuthException catch (e) {
      String msg;
      switch (e.code) {
        case 'email-already-in-use':
          msg = 'That email is already registered.';
          break;
        case 'invalid-email':
          msg = 'Please enter a valid email address.';
          break;
        case 'weak-password':
          msg = 'Please use a stronger password (6+ characters).';
          break;
        case 'operation-not-allowed':
          msg = 'Email/password sign-in is not enabled in Firebase.';
          break;
        case 'network-request-failed':
          msg = 'Network error. Please try again.';
          break;
        default:
          msg = 'Registration failed: ${e.message ?? e.code}';
      }
      messenger.showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101216), // app bg (dark)
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 28),
              decoration: BoxDecoration(
                color: const Color(0xFF0A33FF), // blue card
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFF18E0DC), width: 1.2),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Tabs: sign up / sign in
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _HeaderTab(label: 'sign up', selected: true, onTap: () {}),
                        _HeaderTab(
                          label: 'sign in',
                          selected: false,
                          onTap: _loading ? null : () => context.go('/login/public'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // EMAIL
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: _decoration(label: 'EMAIL', prefix: Icons.person_outline),
                      validator: (v) {
                        final text = v?.trim() ?? '';
                        if (text.isEmpty) return 'Enter your email';
                        if (!text.contains('@') || !text.contains('.')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // PASSWORD
                    TextFormField(
                      controller: _password,
                      obscureText: _obscure1,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: _decoration(
                        label: 'PASSWORD',
                        prefix: Icons.lock_outline,
                        suffix: IconButton(
                          onPressed: () => setState(() => _obscure1 = !_obscure1),
                          icon: Icon(_obscure1 ? Icons.visibility_off : Icons.visibility, color: Colors.white),
                          tooltip: _obscure1 ? 'Show' : 'Hide',
                        ),
                      ),
                      validator: (v) {
                        final text = v ?? '';
                        if (text.isEmpty) return 'Enter a password';
                        if (text.length < 6) return 'Use 6+ characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // CONFIRM PASSWORD
                    TextFormField(
                      controller: _confirm,
                      obscureText: _obscure2,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: _decoration(
                        label: 'CONFIRM PASSWORD',
                        prefix: Icons.lock_outline,
                        suffix: IconButton(
                          onPressed: () => setState(() => _obscure2 = !_obscure2),
                          icon: Icon(_obscure2 ? Icons.visibility_off : Icons.visibility, color: Colors.white),
                          tooltip: _obscure2 ? 'Show' : 'Hide',
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Confirm your password';
                        if (v != _password.text) return 'Passwords do not match';
                        return null;
                      },
                      onFieldSubmitted: (_) => _submit(),
                    ),

                    const SizedBox(height: 28),

                    // Register button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton.tonal(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF0A33FF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                          textStyle: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                        ),
                        onPressed: _loading ? null : _submit,
                        child: _loading
                            ? const SizedBox(
                                width: 22, height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.login),
                                  SizedBox(width: 12),
                                  Text('Register'),
                                ],
                              ),
                      ),
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

class _HeaderTab extends StatelessWidget {
  const _HeaderTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = Colors.white.withOpacity(selected ? 1 : 0.85);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontStyle: FontStyle.italic,
            fontSize: 18,
            decoration: selected ? TextDecoration.underline : null,
          ),
        ),
      ),
    );
  }
}
