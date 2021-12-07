import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:loading_bloc_builder/loading_bloc_builder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(CameraState());

  Future<void> init() async {
    emit(const CameraState(camerasLoading: LoadingStatus.loading));
    final cameras = await availableCameras();
    final controller = CameraController(cameras[0], ResolutionPreset.max);
    await controller.initialize();
    emit(
      CameraState(
        camerasLoading: LoadingStatus.success,
        cameras: cameras,
        cameraController: controller,
      ),
    );
  }

  Future<void> takePicture() async {
    final pic = await state.cameraController!.takePicture();
    emit(state.copyWith(imageData: await pic.readAsBytes()));
  }

  Future<void> uploadPhoto() async {
    final photoId = const Uuid().v4();
    await Supabase.instance.client.storage
        .from('photos')
        .uploadBinary('$photoId.png', state.imageData!);
    Supabase.instance.client.from('photos').insert({
      'id': photoId,
    });
  }
}
