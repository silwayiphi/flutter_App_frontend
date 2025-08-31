import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PrivateLoginPage extends StatefulWidget {
  const PrivateLoginPage({super.key});

  @override
  State<PrivateLoginPage> createState() => _PrivateLoginPageState();
}

class _PrivateLoginPageState extends State<PrivateLoginPage> {
  final _email = TextEditingController();
  final _key = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _key.dispose();
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
    final key = _key.text;

    if (email.isEmpty || key.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Enter email and key')));
      return;
    }

    setState(() => _loading = true);
    try {
      // Treat KEY as password
      final cred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: key);

      final uid = cred.user!.uid;
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        await FirebaseAuth.instance.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account not registered in our database.')),
        );
        setState(() => _loading = false);
        return;
      }

      if (!mounted) return;
      context.go('/streams');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? e.code)));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _forgotKey() async {
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
        const SnackBar(content: Text('Reset link sent to your email')),
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
                border: Border.all(
                  color: const Color(0xFF18E0DC),
                  width: 1.2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _HeaderTab(
                        label: 'Public',
                        selected: false,
                        onTap: _loading ? null : () => context.go('/login/public'),
                      ),
                      const _HeaderTab(
                        label: 'Private',
                        selected: true,
                        onTap: null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Email
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

                  // Key
                  TextField(
                    controller: _key,
                    obscureText: _obscure,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: _decoration(
                      label: 'KEY',
                      prefix: Icons.vpn_key_outlined,
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
                      onPressed: _loading ? null : _forgotKey,
                      child: const Text(
                        'FORGOT KEY',
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
  final VoidCallback? onTap;

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
