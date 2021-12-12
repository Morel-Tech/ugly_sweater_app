part of 'leaderboard_cubit.dart';

class LeaderboardState extends Equatable {
  const LeaderboardState({
    this.topNaughtyUsers = const [],
    this.topNiceUsers = const [],
    this.loadingStatus = LoadingStatus.initial,
    this.viewingNice = true,
  });

  final LoadingStatus loadingStatus;
  final List<LeaderboardEntry> topNiceUsers;
  final List<LeaderboardEntry> topNaughtyUsers;

  final bool viewingNice;
  bool get viewingNaughty => !viewingNice;

  @override
  List<Object> get props => [
        loadingStatus,
        topNiceUsers,
        topNaughtyUsers,
        viewingNice,
      ];

  LeaderboardState copyWith({
    LoadingStatus? loadingStatus,
    List<LeaderboardEntry>? topNiceUsers,
    List<LeaderboardEntry>? topNaughtyUsers,
    bool? viewingNice,
  }) {
    return LeaderboardState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      topNiceUsers: topNiceUsers ?? this.topNiceUsers,
      topNaughtyUsers: topNaughtyUsers ?? this.topNaughtyUsers,
      viewingNice: viewingNice ?? this.viewingNice,
    );
  }
}

class LeaderboardEntry {
  const LeaderboardEntry(this.name, this.rank);

  final int rank;
  final String name;
}
