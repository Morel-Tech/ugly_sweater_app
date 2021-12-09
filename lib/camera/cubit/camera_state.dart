part of 'camera_cubit.dart';

class CameraState extends Equatable {
  const CameraState({
    this.cameras = const [],
    this.camerasLoading = LoadingStatus.initial,
    this.cameraController,
    this.imageData,
  });

  final List<CameraDescription> cameras;
  final LoadingStatus camerasLoading;
  final CameraController? cameraController;

  final Uint8List? imageData;

  @override
  List<Object?> get props => [
        cameras,
        camerasLoading,
        cameraController,
        imageData,
      ];

  CameraState copyWith({
    List<CameraDescription>? cameras,
    LoadingStatus? camerasLoading,
    CameraController? cameraController,
    Uint8List? Function()? imageData,
  }) {
    return CameraState(
      cameras: cameras ?? this.cameras,
      camerasLoading: camerasLoading ?? this.camerasLoading,
      cameraController: cameraController ?? this.cameraController,
      imageData: imageData != null ? imageData() : this.imageData,
    );
  }
}
