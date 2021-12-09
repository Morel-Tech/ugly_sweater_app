part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({
    this.pictureStatus = LoadingStatus.initial,
    this.pictures = const [],
    this.pictureError = '',
    this.hasShownMessage = false,
  });

  final LoadingStatus pictureStatus;
  final List<Picture> pictures;
  final String pictureError;
  final bool hasShownMessage;

  @override
  List<Object> get props => [
        pictureStatus,
        pictures,
        pictureError,
        hasShownMessage,
      ];

  HomeState copyWith({
    LoadingStatus? pictureStatus,
    List<Picture>? pictures,
    String? pictureError,
    bool? hasShownMessage,
  }) {
    return HomeState(
      pictureStatus: pictureStatus ?? this.pictureStatus,
      pictures: pictures ?? this.pictures,
      pictureError: pictureError ?? this.pictureError,
      hasShownMessage: hasShownMessage ?? this.hasShownMessage,
    );
  }
}

class Picture extends Equatable {
  const Picture({
    required this.id,
    required this.image,
  });
  final String id;
  final Uint8List image;

  @override
  List<Object> get props => [id, image];
}
