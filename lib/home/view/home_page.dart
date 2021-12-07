import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_bloc_builder/loading_bloc_builder.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.thumb_down),
                ),
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: 100,
                      height: 100,
                      child: Stack(
                        children: [
                          for (final picture in state.pictureList)
                            Dismissible(
                              key: Key(const Uuid().v4()),
                              child: Image.memory(picture),
                            )
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
            )
          ],
        ),
      ),
    );
  }
}
