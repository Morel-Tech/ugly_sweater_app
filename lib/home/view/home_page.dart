import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_bloc_builder/loading_bloc_builder.dart';
import 'package:ugly_sweater_app/camera/camera.dart';
import 'package:ugly_sweater_app/home/cubit/home_cubit.dart';
import 'package:ugly_sweater_app/main/main.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..init(),
      child: const HomePageView(),
    );
  }
}

class HomePageView extends StatelessWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ugly Sweater'),
        leading: IconButton(
          icon: const Icon(Icons.leaderboard),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<MainCubit>().signOut();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push<void>(
          MaterialPageRoute(builder: (context) => const CameraPage()),
        ),
        child: Icon(
          Icons.camera_alt,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.thumb_down),
              ),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        const Positioned.fill(
                          child: Align(
                            child: Text(
                              'Come back later to put more people on the '
                              'naughty or nice list',
                            ),
                          ),
                        ),
                        for (final picture in state.pictures)
                          BlocBuilder<MainCubit, MainState>(
                            builder: (context, mainState) {
                              return Dismissible(
                                key: Key(const Uuid().v4()),
                                child: Image.memory(
                                  picture.image,
                                  fit: BoxFit.contain,
                                ),
                                onDismissed: (direction) {
                                  context.read<HomeCubit>().onSwipe(
                                        pictureId: picture.id,
                                        rating: direction ==
                                                DismissDirection.startToEnd
                                            ? 'nice'
                                            : 'naughty',
                                      );
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  );
                },
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.thumb_up),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
