import 'dart:math';

import 'package:flutter/material.dart';

class ExperimentalHomePage extends StatefulWidget {
  const ExperimentalHomePage({Key? key}) : super(key: key);

  @override
  State<ExperimentalHomePage> createState() => _ExperimentalHomePageState();
}

class _ExperimentalHomePageState extends State<ExperimentalHomePage>
    with SingleTickerProviderStateMixin {
  var _dragOffset = 0.0;
  var _animating = false;
  double get _offset => _animating ? _animation.value : _dragOffset;

  late AnimationController _animation;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      upperBound: 500,
      lowerBound: -500,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Testing...')),
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, 2),
                      radius: 5,
                      colors: [_calculateColor, Colors.white],
                    ),
                  ),
                ),
                Opacity(
                  opacity: (_offset / 200).clamp(0, 1).toDouble(),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Nice'),
                  ),
                ),
                Opacity(
                  opacity: (_offset / -200).clamp(0, 1).toDouble(),
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Naughty'),
                  ),
                ),
                Align(
                  child: Transform.translate(
                    offset: Offset(_offset, 0),
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        setState(() {
                          _dragOffset = _dragOffset + details.delta.dx;
                        });
                      },
                      onHorizontalDragEnd: (details) async {
                        _animation.value = _dragOffset;
                        setState(() {
                          _animating = true;
                        });
                        if (_dragOffset.abs() < 100) {
                          await _animation.animateTo(
                            0,
                            duration: Duration(
                              milliseconds: _dragOffset.abs().round() * 2,
                            ),
                          );
                          setState(() {
                            _dragOffset = 0;
                            _animating = false;
                          });
                        } else {
                          await _animation.animateTo(
                            _dragOffset > 0 ? 500 : -500,
                          );
                        }
                      },
                      child: Transform.rotate(
                        angle: _offset / (200 * pi),
                        origin: const Offset(0, 200),
                        child: Container(
                          width: 300,
                          height: 600,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Color get _calculateColor {
    final opacity = (_offset.abs() / 50).clamp(0, 1).toDouble();
    if (_offset == 0) {
      return Colors.white;
    } else if (_offset > 0) {
      return Colors.green.withOpacity(opacity);
    } else {
      return Colors.red.withOpacity(opacity);
    }
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }
}
