import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ugly_sweater_app/camera/camera.dart';
import 'package:ugly_sweater_app/home/home.dart';

class ExperimentalHomePage extends StatelessWidget {
  const ExperimentalHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..init(),
      child: const ExperimentalHomePageView(),
    );
  }
}

class ExperimentalHomePageView extends StatefulWidget {
  const ExperimentalHomePageView({Key? key}) : super(key: key);

  @override
  State<ExperimentalHomePageView> createState() =>
      _ExperimentalHomePageViewState();
}

class _ExperimentalHomePageViewState extends State<ExperimentalHomePageView>
    with SingleTickerProviderStateMixin {
  var _dragOffset = 0.0;
  var _animating = false;
  double get _offset => _animating ? _dismissAnimation.value : _dragOffset;

  late AnimationController _dismissAnimation;

  @override
  void initState() {
    super.initState();
    _dismissAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      upperBound: 500,
      lowerBound: -500,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _dismissAnimation,
          builder: (context, _) {
            return BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                final topPicture =
                    state.pictures.isNotEmpty ? state.pictures.last : null;
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
                    const Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(
                          'Ugly Sweater Contest 2021',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: (_offset / 200).clamp(0, 1).toDouble(),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 48),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'NICE',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SvgPicture.asset(
                                'assets/present.svg',
                                height: 50,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: (_offset / -200).clamp(0, 1).toDouble(),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 48),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'NAUGHTY',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SvgPicture.asset(
                                'assets/coal.svg',
                                height: 50,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (state.pictures.isNotEmpty)
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
                                if (_dragOffset.abs() < 100) {
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
                                    _dragOffset > 0 ? 500 : -500,
                                  );

                                  context.read<HomeCubit>().onSwipe(
                                        pictureId: picture.id,
                                        rating: _dragOffset > 0
                                            ? 'nice'
                                            : 'naughty',
                                      );
                                  setState(() {
                                    _dragOffset = 0;
                                  });
                                  await _dismissAnimation.animateTo(
                                    0,
                                  );

                                  setState(() {
                                    _animating = false;
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
                                      (2 / 3),
                                  height: MediaQuery.of(context).size.height *
                                      (2 / 3),
                                  child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 200),
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
                        child: ElevatedButton(
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
    final opacity = (_offset.abs() / 50).clamp(0, 1).toDouble();
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
