import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LineWaves extends StatefulWidget {
  final Widget? child; // Add child property
  final double speed;
  final double innerLineCount;
  final double outerLineCount;
  final double warpIntensity;
  final double rotation;
  final double edgeFadeWidth;
  final double colorCycleSpeed;
  final double brightness;
  final Color color1;
  final Color color2;
  final Color color3;
  final bool enableMouseInteraction;
  final double mouseInfluence;

  const LineWaves({
    super.key,
    this.child, // Initialize child
    this.speed = 0.3,
    this.innerLineCount = 32.0,
    this.outerLineCount = 36.0,
    this.warpIntensity = 1.0,
    this.rotation = -45.0,
    this.edgeFadeWidth = 0.0,
    this.colorCycleSpeed = 1.0,
    this.brightness = 0.2,
    this.color1 = Colors.white,
    this.color2 = Colors.white,
    this.color3 = Colors.white,
    this.enableMouseInteraction = true,
    this.mouseInfluence = 2.0,
  });

  @override
  State<LineWaves> createState() => _LineWavesState();
}

class _LineWavesState extends State<LineWaves>
    with SingleTickerProviderStateMixin {
  ui.FragmentShader? _shader;
  late Ticker _ticker;
  double _elapsedTime = 0.0;

  Offset _targetMouse = const Offset(0.5, 0.5);
  Offset _currentMouse = const Offset(0.5, 0.5);

  @override
  void initState() {
    super.initState();
    _loadShader();
    _ticker = createTicker((Duration elapsed) {
      setState(() {
        _elapsedTime = elapsed.inMilliseconds / 1000.0;

        if (widget.enableMouseInteraction) {
          // Linear interpolation for mouse smoothing loop
          _currentMouse = Offset(
            _currentMouse.dx + 0.05 * (_targetMouse.dx - _currentMouse.dx),
            _currentMouse.dy + 0.05 * (_targetMouse.dy - _currentMouse.dy),
          );
        } else {
          _currentMouse = const Offset(0.5, 0.5);
        }
      });
    });
  }

  Future<void> _loadShader() async {
    final program = await ui.FragmentProgram.fromAsset(
      'shaders/line_wave.frag',
    );
    setState(() {
      _shader = program.fragmentShader();
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_shader == null) {
      return widget.child ?? const SizedBox.shrink();
    }

    // Background shader painter canvas
    Widget shaderCanvas = CustomPaint(
      painter: LineWavesPainter(
        shader: _shader!,
        time: _elapsedTime,
        speed: widget.speed,
        innerLines: widget.innerLineCount,
        outerLines: widget.outerLineCount,
        warpIntensity: widget.warpIntensity,
        rotationRad: (widget.rotation * math.pi) / 180.0,
        edgeFadeWidth: widget.edgeFadeWidth,
        colorCycleSpeed: widget.colorCycleSpeed,
        brightness: widget.brightness,
        color1: widget.color1,
        color2: widget.color2,
        color3: widget.color3,
        mouse: _currentMouse,
        mouseInfluence: widget.mouseInfluence,
        enableMouse: widget.enableMouseInteraction ? 1.0 : 0.0,
      ),
    );

    // If mouse interaction is active, clip pointer regions
    if (widget.enableMouseInteraction) {
      shaderCanvas = MouseRegion(
        onHover: (event) {
          final RenderBox box = context.findRenderObject() as RenderBox;
          final localPos = event.localPosition;
          _targetMouse = Offset(
            localPos.dx / box.size.width,
            1.0 - (localPos.dy / box.size.height),
          );
        },
        onExit: (_) {
          _targetMouse = const Offset(0.5, 0.5);
        },
        child: shaderCanvas,
      );
    }

    // Layer the background canvas and the content tree using a Stack
    return Stack(
      children: [
        Positioned.fill(child: shaderCanvas),
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

class LineWavesPainter extends CustomPainter {
  final ui.FragmentShader shader;
  final double time;
  final double speed;
  final double innerLines;
  final double outerLines;
  final double warpIntensity;
  final double rotationRad;
  final double edgeFadeWidth;
  final double colorCycleSpeed;
  final double brightness;
  final Color color1;
  final Color color2;
  final Color color3;
  final Offset mouse;
  final double mouseInfluence;
  final double enableMouse;

  LineWavesPainter({
    required this.shader,
    required this.time,
    required this.speed,
    required this.innerLines,
    required this.outerLines,
    required this.warpIntensity,
    required this.rotationRad,
    required this.edgeFadeWidth,
    required this.colorCycleSpeed,
    required this.brightness,
    required this.color1,
    required this.color2,
    required this.color3,
    required this.mouse,
    required this.mouseInfluence,
    required this.enableMouse,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. uResolution (vec3) -> width, height, aspect ratio
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, size.width / size.height);

    // 2. Base Uniform Scalar Configuration
    shader.setFloat(3, time);
    shader.setFloat(4, speed);
    shader.setFloat(5, innerLines);
    shader.setFloat(6, outerLines);
    shader.setFloat(7, warpIntensity);
    shader.setFloat(8, rotationRad);
    shader.setFloat(9, edgeFadeWidth);
    shader.setFloat(10, colorCycleSpeed);
    shader.setFloat(11, brightness);

    // 3. Normalized Vec3 Color Components Mapping
    shader.setFloat(12, color1.r);
    shader.setFloat(13, color1.g);
    shader.setFloat(14, color1.b);

    shader.setFloat(15, color2.r);
    shader.setFloat(16, color2.g);
    shader.setFloat(17, color2.b);

    shader.setFloat(18, color3.r);
    shader.setFloat(19, color3.g);
    shader.setFloat(20, color3.b);

    // 4. Mouse Position vector properties
    shader.setFloat(21, mouse.dx);
    shader.setFloat(22, mouse.dy);
    shader.setFloat(23, mouseInfluence);
    shader.setFloat(24, enableMouse);

    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant LineWavesPainter oldDelegate) {
    return oldDelegate.time != time ||
        oldDelegate.mouse != mouse ||
        oldDelegate.color1 != color1 ||
        oldDelegate.color2 != color2 ||
        oldDelegate.color3 != color3;
  }
}
