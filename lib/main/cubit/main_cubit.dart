import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(const MainState());

  Future<void> init() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      emit(MainState(session: session));
    } else {
      final response =
          await Supabase.instance.client.auth.getSessionFromUrl(Uri.base);
      if (response.data != null) {
        emit(MainState(session: response.data));
      }
    }
  }
}
