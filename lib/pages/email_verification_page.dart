import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stoodee/services/auth/auth_service.dart';
import 'package:stoodee/services/router/route_functions.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Your Email')),
      body: Column(
        children: [
          const Text("One more thing! You haven't verified your email yet!"),
          const Text('We have sent an email verification link to you'),
          const Text('To verify your account, Click the link inside of it'),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            },
            child: const Text(
              "Don't see a link? click here to resend verification email",
            ),
          ),
          TextButton(
            onPressed: () async {
              AuthService.firebase().logOut();
              goRouterToLogin(context);
            },
            child: const Text('Log-in'),
          ),
        ],
      ),
    );
  }
}
