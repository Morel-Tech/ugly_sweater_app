part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({
    this.pictureStatus = LoadingStatus.initial,
    this.pictureList = const [],
  });

  final LoadingStatus pictureStatus;
  final List<Uint8List> pictureList;

  @override
  List<Object> get props => [pictureStatus, pictureList];

  HomeState copyWith({
    LoadingStatus? pictureStatus,
    List<Uint8List>? pictureList,
  }) {
    return HomeState(
      pictureStatus: pictureStatus ?? this.pictureStatus,
      pictureList: pictureList ?? this.pictureList,
    );
  }
}
