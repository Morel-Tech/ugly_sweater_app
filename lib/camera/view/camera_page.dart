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
      body: LoadingBlocBuilder<CameraCubit, CameraState>(
        statusGetter: (state) => state.camerasLoading,
        successBuilder: (context, state) {
          return Stack(
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    child: const Text('Take a picture'),
                    onPressed: () => context.read<CameraCubit>().takePicture(),
                  ),
                ),
              if (state.imageData != null)
                SizedBox(
                  width: MediaQuery.of(context).size.width * (5 / 6),
                  height: MediaQuery.of(context).size.height * (5 / 6),
                  child: Image.memory(
                    state.imageData!,
                    fit: BoxFit.cover,
                  ),
                ),
              if (state.imageData != null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      OutlinedButton(
                        child: const Text('Retake'),
                        onPressed: () =>
                            context.read<CameraCubit>().retakePhoto(),
                      ),
                      ElevatedButton(
                        child: const Text('Upload'),
                        onPressed: () =>
                            context.read<CameraCubit>().uploadPhoto(),
                      ),
                    ],
                  ),
                ),
              SizedBox(
                width: MediaQuery.of(context).size.width * (11 / 12),
                height: MediaQuery.of(context).size.height * (11 / 12),
                child: SvgPicture.asset(
                  'assets/camera_frame.svg',
                  fit: BoxFit.fill,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
