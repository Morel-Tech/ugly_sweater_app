part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({
    this.pictureStatus = LoadingStatus.initial,
    this.pictureList = const [],
    this.pictureIdList = const [],
    this.pictureError = '',
  });

  final LoadingStatus pictureStatus;
  final List<Uint8List> pictureList;
  final List<String> pictureIdList;
  final String pictureError;

  @override
  List<Object> get props =>
      [pictureStatus, pictureList, pictureIdList, pictureError];

  HomeState copyWith({
    LoadingStatus? pictureStatus,
    List<Uint8List>? pictureList,
    List<String>? pictureIdList,
    String? pictureError,
  }) {
    return HomeState(
      pictureStatus: pictureStatus ?? this.pictureStatus,
      pictureList: pictureList ?? this.pictureList,
      pictureIdList: pictureIdList ?? this.pictureIdList,
      pictureError: pictureError ?? this.pictureError,
    );
  }
}
