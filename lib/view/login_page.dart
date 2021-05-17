import 'package:flutter/material.dart';
import 'package:flutter_firebase_note_app/provider/user.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
      ),
      body: _buildButtons(context),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SignInButton(Buttons.Google, onPressed: () async {
            await context.read(userNotifierProvider).signInWithGoogle();
          }),
          SizedBox(height: 21),
          SignInButtonBuilder(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icons.login_rounded,
            text: 'Sign in Anonymously',
            height: 45,
            onPressed: () async {
              await context.read(userNotifierProvider).signInAnonymously();
            },
          ),
        ],
      ),
    );
  }
}
