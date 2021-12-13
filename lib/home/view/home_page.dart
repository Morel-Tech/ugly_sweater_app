// ignore_for_file: lines_longer_than_80_chars

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_bloc_builder/loading_bloc_builder.dart';
import 'package:ugly_sweater_app/camera/camera.dart';
import 'package:ugly_sweater_app/home/home.dart';
import 'package:ugly_sweater_app/leaderboard/leaderboard.dart';

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

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView>
    with SingleTickerProviderStateMixin {
  var _dragOffset = 0.0;
  var _animating = false;
  var _reversingAnimation = false;
  bool get _isInNaughty => _offset < 0;
  bool get _isPastThreshold =>
      _offset.abs() > MediaQuery.of(context).size.width / 4;

  double get _offset {
    return _animating ? _dismissAnimation.value : _dragOffset * 1.1;
  }

  late AnimationController _dismissAnimation;

  @override
  void initState() {
    super.initState();
    _dismissAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      upperBound: 1000,
      lowerBound: -1000,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Center(
        child: AnimatedBuilder(
          animation: _dismissAnimation,
          builder: (context, _) {
            return BlocConsumer<HomeCubit, HomeState>(
              listenWhen: (_, curr) => !curr.hasShownMessage,
              listener: (context, state) {
                showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('How it Works'),
                    contentPadding: const EdgeInsets.all(24),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '1. Drag photos to the right for vote it as nice (you love it!) or the left to vote as naughty (you love how bad it is!)',
                          ),
                          SizedBox(height: 10),
                          Text(
                            '2. Tap the button below to share your own holiday sweater!',
                          ),
                          SizedBox(height: 10),
                          Text(
                            // ignore: avoid_escaping_inner_quotes
                            '3. Tap the button in the top left to see who\'s sweater is the most naughty and nice.',
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.read<HomeCubit>().dismissInstructions();
                        },
                        child: const Text('Got it!'),
                      ),
                    ],
                  ),
                );
              },
              builder: (context, state) {
                final topPicture =
                    state.pictures.isNotEmpty && !_reversingAnimation
                        ? state.pictures.last
                        : null;
                return Stack(
                  children: [
                    Container(
                      color: Colors.blue,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [_calculateColor, Colors.white],
                        ),
                      ),
                    ),
                    if (state.pictureStatus == LoadingStatus.loading)
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                    if (state.pictureStatus == LoadingStatus.failure)
                      Center(
                        child: Text(state.pictureError),
                      ),
                    const Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(
                          'Vote on sweaters by swiping left for naughty and right for nice!',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.blue,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: ((_offset.abs() * 4) /
                              MediaQuery.of(context).size.width)
                          .clamp(0, 1)
                          .toDouble(),
                      child: Align(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _isInNaughty ? 'NAUGHTY' : 'NICE',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SvgPicture.asset(
                              _isInNaughty
                                  ? 'assets/coal.svg'
                                  : 'assets/present.svg',
                              height: 100,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (state.pictures.isEmpty &&
                        state.pictureStatus == LoadingStatus.success)
                      const Align(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            // ignore: lines_longer_than_80_chars
                            'No more sweaters left to vote on.\nShare your sweater below, or share with your friends for more!',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    if (state.pictures.isNotEmpty &&
                        state.pictureStatus == LoadingStatus.success)
                      for (final picture in state.pictures)
                        Align(
                          child: Transform.translate(
                            offset:
                                Offset(topPicture == picture ? _offset : 0, 0),
                            child: GestureDetector(
                              onHorizontalDragUpdate: (details) {
                                setState(() {
                                  _dragOffset = _dragOffset + details.delta.dx;
                                });
                              },
                              onHorizontalDragEnd: (details) async {
                                _dismissAnimation.value = _dragOffset;
                                setState(() {
                                  _animating = true;
                                });
                                if (!_isPastThreshold) {
                                  await _dismissAnimation.animateTo(
                                    0,
                                    duration: Duration(
                                      milliseconds:
                                          _dragOffset.abs().round() * 2,
                                    ),
                                  );
                                  setState(() {
                                    _dragOffset = 0;
                                    _animating = false;
                                  });
                                } else {
                                  await _dismissAnimation.animateTo(
                                    _isInNaughty ? -1000 : 1000,
                                  );

                                  context.read<HomeCubit>().onSwipe(
                                        pictureId: picture.id,
                                        rating: _dragOffset > 0
                                            ? 'nice'
                                            : 'naughty',
                                      );
                                  setState(() {
                                    _dragOffset = 0;
                                    _reversingAnimation = true;
                                  });
                                  await _dismissAnimation.animateTo(0);

                                  setState(() {
                                    _animating = false;
                                    _reversingAnimation = false;
                                  });
                                }
                              },
                              child: Transform.rotate(
                                angle: topPicture == picture
                                    ? _offset / (200 * pi)
                                    : 0,
                                origin: const Offset(0, 200),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      (11 / 12),
                                  height: MediaQuery.of(context).size.height *
                                      (2 / 3),
                                  child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                    opacity: topPicture == picture ? 1 : 0,
                                    child: Image.memory(
                                      picture.image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(color: Colors.white, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).push<void>(
                                  MaterialPageRoute(
                                    builder: (context) => const CameraPage(),
                                  ),
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  'Enter Your Own Sweater!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextButton(
                              child: const Text(
                                'Leaderboard',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (context) =>
                                        const LeaderboardPage(),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Color get _calculateColor {
    final opacity = (_offset.abs() / 150).clamp(0, 1).toDouble();
    if (_offset == 0) {
      return Colors.transparent;
    } else if (_offset > 0) {
      return Colors.green.withOpacity(opacity);
    } else {
      return Colors.red.withOpacity(opacity);
    }
  }

  @override
  void dispose() {
    _dismissAnimation.dispose();
    super.dispose();
  }
}
