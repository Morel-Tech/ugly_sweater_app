import 'dart:math';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:blurhash/blurhash.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:loading_bloc_builder/loading_bloc_builder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(CameraState());

  Future<void> init() async {
    emit(state.copyWith(camerasLoading: LoadingStatus.loading));
    final cameras = await availableCameras();

    final controller = CameraController(
      cameras[state.cameraNumber],
      ResolutionPreset.max,
      enableAudio: false,
    );
    await controller.initialize();

    emit(
      state.copyWith(
        camerasLoading: LoadingStatus.success,
        cameras: cameras,
        cameraController: controller,
      ),
    );
  }

  void nextCamera() {
    if (state.cameraController != null) {
      state.cameraController!.dispose();
    }
    emit(
      state.copyWith(
        cameraNumber: state.cameraNumber == 1 ? 0 : 1,
      ),
    );
    init();
  }

  void retakePhoto() {
    init();
  }

  Future<void> takePicture() async {
    final pic = await state.cameraController!.takePicture();
    final bytes = await pic.readAsBytes();
    emit(state.copyWith(imageData: () => bytes));
  }

  Future<void> uploadPhoto() async {
    emit(state.copyWith(uploadStatus: LoadingStatus.loading));
    try {
      final photoId = const Uuid().v4();
      await Supabase.instance.client.storage
          .from('photos')
          .uploadBinary('$photoId.png', state.imageData!);
      final blurHash = await BlurHash.encode(state.imageData!, 4, 3);

      await Supabase.instance.client.from('photos').insert({
        'id': photoId,
        'photohash': blurHash,
        'userId': Supabase.instance.client.auth.user()!.id,
      }).execute();
    } catch (_) {
      emit(state.copyWith(uploadStatus: LoadingStatus.failure));
    }
    emit(state.copyWith(uploadStatus: LoadingStatus.success));
  }
}
