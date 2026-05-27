import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DarkVeil extends StatefulWidget {
  final double hueShift;
  final double noiseIntensity;
  final double scanlineIntensity;
  final double speed;
  final double scanlineFrequency;
  final double warpAmount;
  final Widget child;

  const DarkVeil({
    Key? key,
    this.hueShift = 0.0,
    this.noiseIntensity = 0.0,
    this.scanlineIntensity = 0.0,
    this.speed = 0.5,
    this.scanlineFrequency = 0.0,
    this.warpAmount = 0.0,
    required this.child,
  }) : super(key: key);

  @override
  State<DarkVeil> createState() => _DarkVeilState();
}

class _DarkVeilState extends State<DarkVeil>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  FragmentProgram? _program;
  double _time = 0.0;

  @override
  void initState() {
    super.initState();
    _loadShader();
    _ticker = createTicker((elapsed) {
      if (_program != null) {
        setState(() {
          _time = (elapsed.inMicroseconds / 1000000.0) * widget.speed;
        });
      }
    });
  }

  Future<void> _loadShader() async {
    _program = await FragmentProgram.fromAsset('shaders/dark_veil.frag');
    setState(() {});
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_program == null) {
      return const SizedBox.shrink();
    }


return LayoutBuilder(
  builder: (context, constraints) {
    return Stack(
      children: [
        CustomPaint(
          painter: _DarkVeilPainter(
            program: _program!,
            time: _time,
            hueShift: widget.hueShift,
            noiseIntensity: widget.noiseIntensity,
            scanlineIntensity: widget.scanlineIntensity,
            scanlineFrequency: widget.scanlineFrequency,
            warpAmount: widget.warpAmount,
          ),
          child: SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
          ),
        ),
        widget.child,
      ],
    );
  },
);
  }
}

class _DarkVeilPainter extends CustomPainter {
  final FragmentProgram program;
  final double time;
  final double hueShift;
  final double noiseIntensity;
  final double scanlineIntensity;
  final double scanlineFrequency;
  final double warpAmount;

  _DarkVeilPainter({
    required this.program,
    required this.time,
    required this.hueShift,
    required this.noiseIntensity,
    required this.scanlineIntensity,
    required this.scanlineFrequency,
    required this.warpAmount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final shader = program.fragmentShader();

    // Map Uniforms to Shader Index mapping
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, time);
    shader.setFloat(3, hueShift);
    shader.setFloat(4, noiseIntensity);
    shader.setFloat(5, scanlineIntensity);
    shader.setFloat(6, scanlineFrequency);
    shader.setFloat(7, warpAmount);

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()..shader = shader;

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _DarkVeilPainter oldDelegate) {
    return oldDelegate.time != time ||
        oldDelegate.hueShift != hueShift ||
        oldDelegate.noiseIntensity != noiseIntensity ||
        oldDelegate.scanlineIntensity != scanlineIntensity ||
        oldDelegate.scanlineFrequency != scanlineFrequency ||
        oldDelegate.warpAmount != warpAmount;
  }
}
