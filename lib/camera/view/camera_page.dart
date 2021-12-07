import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_bloc_builder/loading_bloc_builder.dart';
import 'package:ugly_sweater_app/camera/camera.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CameraCubit()..init(),
      child: const CameraPageView(),
    );
  }
}

class CameraPageView extends StatelessWidget {
  const CameraPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
        ],
      ),
      body: LoadingBlocBuilder<CameraCubit, CameraState>(
        statusGetter: (state) => state.camerasLoading,
        successBuilder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(32),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CameraPreview(
                        state.cameraController!,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          child: const Text('Take a picture'),
                          onPressed: () =>
                              context.read<CameraCubit>().takePicture(),
                        ),
                      ),
                    ],
                  ),
                  if (state.imageData != null)
                    Stack(
                      children: [
                        Image.memory(
                          state.imageData!,
                          fit: BoxFit.cover,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            child: const Text('Upload'),
                            onPressed: () =>
                                context.read<CameraCubit>().uploadPhoto(),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
