import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ugly_sweater_app/login/login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: const LoginPageView(),
    );
  }
}

class LoginPageView extends StatelessWidget {
  const LoginPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('Sign in With Google'),
          onPressed: () {
            context.read<LoginCubit>().loginWithGoogle();
          },
        ),
      ),
    );
  }
}
