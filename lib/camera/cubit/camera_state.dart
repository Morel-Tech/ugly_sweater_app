part of 'camera_cubit.dart';

class CameraState extends Equatable {
  const CameraState({
    this.cameras = const [],
    this.camerasLoading = LoadingStatus.initial,
    this.cameraController,
    this.imageData,
    this.uploadStatus = LoadingStatus.initial,
    this.cameraNumber = 0,
    this.photoName = '',
  });

  final List<CameraDescription> cameras;
  final LoadingStatus camerasLoading;
  final CameraController? cameraController;

  final Uint8List? imageData;
  final LoadingStatus uploadStatus;
  final int cameraNumber;

  bool get isValid => photoName != '';

  final String photoName;

  @override
  List<Object?> get props => [
        cameras,
        camerasLoading,
        cameraController,
        imageData,
        uploadStatus,
        cameraNumber,
        photoName,
      ];

  CameraState copyWith({
    List<CameraDescription>? cameras,
    LoadingStatus? camerasLoading,
    CameraController? cameraController,
    Uint8List? Function()? imageData,
    LoadingStatus? uploadStatus,
    int? cameraNumber,
    String? photoName,
  }) {
    return CameraState(
      cameras: cameras ?? this.cameras,
      camerasLoading: camerasLoading ?? this.camerasLoading,
      cameraController: cameraController ?? this.cameraController,
      imageData: imageData != null ? imageData() : this.imageData,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      cameraNumber: cameraNumber ?? this.cameraNumber,
      photoName: photoName ?? this.photoName,
    );
  }
}
