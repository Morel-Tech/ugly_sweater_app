// ignore_for_file: avoid_dynamic_calls,argument_type_not_assignable

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:loading_bloc_builder/loading_bloc_builder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  LeaderboardCubit() : super(const LeaderboardState());

  Future<void> init() async {
    emit(state.copyWith(loadingStatus: LoadingStatus.loading));
    try {
      final results = await Future.wait(
        [
          Supabase.instance.client.from('nice_leaderboard').select().execute(),
          Supabase.instance.client
              .from('naughty_leaderboard')
              .select()
              .execute(),
        ],
      );

      final niceResults = List<dynamic>.from(results[0].data);
      final naughtyResults = List<dynamic>.from(results[1].data);
      emit(
        state.copyWith(
          loadingStatus: LoadingStatus.success,
          topNiceUsers: niceResults
              .map(
                (dynamic entry) => LeaderboardEntry(
                  entry['name'],
                  entry['count'],
                ),
              )
              .toList(),
          topNaughtyUsers: naughtyResults
              .map(
                (dynamic entry) => LeaderboardEntry(
                  entry['name'],
                  entry['count'],
                ),
              )
              .toList(),
        ),
      );
    } catch (_) {
      emit(state.copyWith(loadingStatus: LoadingStatus.failure));
    }
  }

  void viewNice() {
    emit(state.copyWith(viewingNice: true));
  }

  void viewNaughty() {
    emit(state.copyWith(viewingNice: false));
  }
}
