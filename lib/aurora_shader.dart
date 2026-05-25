import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AuroraShader extends StatefulWidget {
  const AuroraShader({super.key});

  @override
  State<AuroraShader> createState() => _AuroraShaderState();
}

class _AuroraShaderState extends State<AuroraShader>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double time = 0;
  Offset mouse = Offset.zero;
  ui.FragmentShader? shader;

  @override
  void initState() {
    super.initState();
    _loadShader();
    _ticker = createTicker((elapsed) {
      setState(() {
        time = elapsed.inMilliseconds / 1000;
      });
    });
  }

  Future<void> _loadShader() async {
    // Ensure you register 'shaders/aurora.frag' under the flutter -> shaders asset tree in pubspec.yaml
    final program = await ui.FragmentProgram.fromAsset('shaders/aurora.frag');
    setState(() {
      shader = program.fragmentShader();
    });
    _ticker.start(); // Only start ticking once the shader asset is ready
  }

  @override
  void dispose() {
    _ticker.dispose();
    shader?.dispose(); // Prevent native memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fallback widget to prevent null-pointer crashes during async asset load
    if (shader == null) {
      return SizedBox.expand(child: Container(color: Colors.black));
    }

    return MouseRegion(
      onHover: (e) {
        setState(() {
          mouse = e.localPosition;
        });
      },
      child: CustomPaint(
        painter: AuroraPainter(shader!, time, mouse),
        size: Size.infinite,
      ),
    );
  }
}

class AuroraPainter extends CustomPainter {
  final ui.FragmentShader shader;
  final double time;
  final Offset mouse;

  AuroraPainter(this.shader, this.time, this.mouse);

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Pass canvas resolution limits
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);

    // 2. Pass cursor coordinate points
    shader.setFloat(2, mouse.dx);
    shader.setFloat(3, mouse.dy);

    // 3. Pass elapsed runtime clock value
    shader.setFloat(4, time);

    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant AuroraPainter oldDelegate) {
    // Optimized condition to prevent unnecessary hardware repaint cycles
    return oldDelegate.time != time || oldDelegate.mouse != mouse;
  }
}
