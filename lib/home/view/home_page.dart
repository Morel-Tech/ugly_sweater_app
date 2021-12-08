import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_bloc_builder/loading_bloc_builder.dart';
import 'package:ugly_sweater_app/camera/camera.dart';
import 'package:ugly_sweater_app/home/cubit/home_cubit.dart';
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
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Align(
          child: ColoredBox(
            color: Colors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ColoredBox(
                  color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.thumb_down),
                      ),
                      BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          return Stack(
                            children: [
                              const Positioned.fill(
                                child: Align(
                                  child: Text(
                                    'Come back later to put more people on the '
                                    'naughty or nice list.',
                                  ),
                                ),
                              ),
                              for (final picture in state.pictureList)
                                Dismissible(
                                  key: Key(const Uuid().v4()),
                                  behavior: HitTestBehavior.deferToChild,
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.75,
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    child: Expanded(
                                      child: Image.memory(
                                        picture,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                  onDismissed: (direction) => () {},
                                  // context.read<HomeCubit>().,
                                ),
                            ],
                          );
                        },
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.thumb_up),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  child: const Text('Add picture'),
                  onPressed: () {
                    Navigator.of(context).push<void>(
                      MaterialPageRoute(
                          builder: (context) => const CameraPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
