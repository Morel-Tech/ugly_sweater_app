import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.red,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            onPressed: () => context.read<CameraCubit>().nextCamera(),
            iconSize: 30,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: LoadingBlocBuilder<CameraCubit, CameraState>(
        statusGetter: (state) => state.camerasLoading,
        successBuilder: (context, state) {
          return BlocListener<CameraCubit, CameraState>(
            listenWhen: (_, current) =>
                current.uploadStatus == LoadingStatus.success,
            listener: (context, state) => Navigator.pop(context),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.blue, Colors.white],
                    ),
                  ),
                ),
                if (state.imageData == null)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * (5 / 6),
                    height: MediaQuery.of(context).size.height * (5 / 6),
                    child: CameraPreview(
                      state.cameraController!,
                    ),
                  ),
                if (state.imageData == null)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        child: const Text('Take a picture'),
                        onPressed: () =>
                            context.read<CameraCubit>().takePicture(),
                      ),
                    ),
                  ),
                if (state.imageData != null &&
                    state.uploadStatus != LoadingStatus.failure)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * (5 / 6),
                    height: MediaQuery.of(context).size.height * (5 / 6),
                    child: Image.memory(
                      state.imageData!,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (state.imageData != null &&
                    state.uploadStatus != LoadingStatus.failure)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (state.uploadStatus != LoadingStatus.loading)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                child: const Text('Retake'),
                                onPressed: () =>
                                    context.read<CameraCubit>().retakePhoto(),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                child: const Text('Upload'),
                                onPressed: () =>
                                    context.read<CameraCubit>().uploadPhoto(),
                              ),
                            ],
                          ),
                        if (state.uploadStatus == LoadingStatus.loading)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                if (state.imageData != null &&
                    state.uploadStatus == LoadingStatus.failure)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        const Text('Upload failed, please try again.'),
                        const SizedBox(height: 4),
                        OutlinedButton(
                          child: const Text('Retry'),
                          onPressed: () =>
                              context.read<CameraCubit>().retakePhoto(),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
