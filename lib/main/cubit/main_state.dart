part of 'main_cubit.dart';

class MainState extends Equatable {
  const MainState({
    this.session,
  });

  final Session? session;

  @override
  List<Object?> get props => [session];
}
