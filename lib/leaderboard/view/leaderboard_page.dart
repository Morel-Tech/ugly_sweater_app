import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_bloc_builder/loading_bloc_builder.dart';
import 'package:ugly_sweater_app/leaderboard/leaderboard.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeaderboardCubit()..init(),
      child: const LeaderboardPageView(),
    );
  }
}

class LeaderboardPageView extends StatelessWidget {
  const LeaderboardPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
      ),
      body: Stack(
        children: [
          BlocBuilder<LeaderboardCubit, LeaderboardState>(
            builder: (context, state) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      if (state.loadingStatus != LoadingStatus.loading)
                        state.viewingNice ? Colors.green : Colors.red
                      else
                        Colors.blue,
                      Colors.white
                    ],
                  ),
                ),
              );
            },
          ),
          LoadingBlocBuilder<LeaderboardCubit, LeaderboardState>(
            statusGetter: (state) => state.loadingStatus,
            successBuilder: (context, state) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              context.read<LeaderboardCubit>().viewNice(),
                          child: AnimatedContainer(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              color: state.viewingNice
                                  ? Colors.green
                                  : Colors.green.shade100,
                            ),
                            duration: const Duration(milliseconds: 500),
                            child: const Text(
                              'Nice',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () =>
                              context.read<LeaderboardCubit>().viewNaughty(),
                          child: AnimatedContainer(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              color: state.viewingNaughty
                                  ? Colors.red
                                  : Colors.red.shade100,
                            ),
                            duration: const Duration(milliseconds: 500),
                            child: const Text(
                              'Naughty',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.viewingNice
                          ? state.topNiceUsers.length
                          : state.topNaughtyUsers.length,
                      itemBuilder: (context, index) {
                        final entry = state.viewingNice
                            ? state.topNiceUsers[index]
                            : state.topNaughtyUsers[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text('${index + 1}.'),
                                const SizedBox(width: 6),
                                Text(entry.name),
                                const Spacer(),
                                Text('${entry.rank}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
