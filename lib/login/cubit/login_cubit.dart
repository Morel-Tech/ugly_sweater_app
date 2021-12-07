import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  Future<void> loginWithGoogle() async {
    await Supabase.instance.client.auth.signInWithProvider(
      Provider.google,
      options: AuthOptions(),
    );
  }
}
