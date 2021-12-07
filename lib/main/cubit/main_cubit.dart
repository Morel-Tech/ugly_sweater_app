import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(const MainState());

  void init() {
    Supabase.instance.client.auth.onAuthStateChange((event, session) {});
  }

  void updateAuth(AuthChangeEvent event, Session? session) {
    emit(MainState(session: session));
  }
}
