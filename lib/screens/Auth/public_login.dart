import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PublicLoginPage extends StatefulWidget {
  const PublicLoginPage({super.key});

  @override
  State<PublicLoginPage> createState() => _PublicLoginPageState();
}

class _PublicLoginPageState extends State<PublicLoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
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
        letterSpacing: 0.5,
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

  Future<void> _login() async {
    final email = _email.text.trim();
    final pw = _password.text;

    if (email.isEmpty || pw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter email and password')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final cred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pw);

      final uid = cred.user!.uid;
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        await FirebaseAuth.instance.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account not registered in our database.'),
          ),
        );
        setState(() => _loading = false);
        return;
      }

      if (!mounted) return;
      context.go('/streams');
    } on FirebaseAuthException catch (e) {
      String msg;
      switch (e.code) {
        case 'user-not-found':
          msg = 'No account found for that email.';
          break;
        case 'wrong-password':
          msg = 'Incorrect password.';
          break;
        case 'invalid-email':
          msg = 'Invalid email address.';
          break;
        case 'user-disabled':
          msg = 'This account has been disabled.';
          break;
        case 'network-request-failed':
          msg = 'Network error. Please try again.';
          break;
        default:
          msg = 'Login failed: ${e.message ?? e.code}';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _forgotPassword() async {
    final email = _email.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your email first')),
      );
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent')),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? e.code)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101216),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 28),
              decoration: BoxDecoration(
                color: const Color(0xFF0A33FF),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFF18E0DC), width: 1.2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _HeaderTab(label: 'Public', selected: true, onTap: () {}),
                      _HeaderTab(
                        label: 'Private',
                        selected: false,
                        onTap: () => context.go('/login/private'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: _decoration(
                      label: 'EMAIL',
                      prefix: Icons.person_outline,
                    ),
                    onSubmitted: (_) => _login(),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: _password,
                    obscureText: _obscure,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: _decoration(
                      label: 'PASSWORD',
                      prefix: Icons.lock_outline,
                      suffix: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white,
                        ),
                        tooltip: _obscure ? 'Show' : 'Hide',
                      ),
                    ),
                    onSubmitted: (_) => _login(),
                  ),

                  const SizedBox(height: 36),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF0A33FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      onPressed: _loading ? null : _login,
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
                                Text('login'),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _loading ? null : _forgotPassword,
                      child: const Text(
                        'FORGOT PASSWORD',
                        style: TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                ],
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
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Colors.white.withOpacity(selected ? 1 : 0.8);
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
