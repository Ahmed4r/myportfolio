import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class InteractiveAuroraBackground extends StatefulWidget {
  final Widget? child;
  const InteractiveAuroraBackground({super.key, this.child});

  @override
  State<InteractiveAuroraBackground> createState() =>
      _InteractiveAuroraBackgroundState();
}

class _InteractiveAuroraBackgroundState
    extends State<InteractiveAuroraBackground>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double _time = 0;
  Offset _mousePos = Offset.zero;
  ui.FragmentShader? _shader;

  @override
  void initState() {
    super.initState();
    _loadShader();
    _ticker = createTicker((elapsed) {
      if (_shader != null) {
        // تحديث الحالة فقط لو الشادر جاهز لتقليل العمليات
        setState(() {
          _time = elapsed.inMilliseconds / 1000;
        });
      }
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    _shader?.dispose(); // تنظيف الذاكرة الأصلية للشادر لمنع التسريب
    super.dispose();
  }

  Future<void> _loadShader() async {
    try {
      // تصحيح المسار ليتوافق مع pubspec.yaml المحدث
      final program = await ui.FragmentProgram.fromAsset('shaders/aurora.frag');
      setState(() {
        _shader = program.fragmentShader();
      });
      _ticker.start(); // بدء المؤقت فقط بعد التأكد من تحميل الشادر بنجاح
    } catch (e) {
      debugPrint("Error loading shader: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        if (_shader != null) {
          setState(() {
            _mousePos = event.localPosition;
          });
        }
      },
      child: Stack(
        children: [
          // شاشة سوداء بديلة لحين انتهاء التحميل لمنع الانهيار
          if (_shader == null)
            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xff040D21)),
              ),
            )
          else
            Positioned.fill(
              child: CustomPaint(
                painter: AuroraPainter(
                  shader: _shader!,
                  time: _time,
                  mouse: _mousePos,
                ),
              ),
            ),
          // الـ Grid Overlay المضاف فوق تأثير الموائع
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: CustomPaint(painter: GridPainter()),
            ),
          ),
          if (widget.child != null) widget.child!,
        ],
      ),
    );
  }
}

class AuroraPainter extends CustomPainter {
  final ui.FragmentShader shader;
  final double time;
  final Offset mouse;

  AuroraPainter({
    required this.shader,
    required this.time,
    required this.mouse,
  });

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, mouse.dx);
    shader.setFloat(3, mouse.dy);
    shader.setFloat(4, time);

    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant AuroraPainter oldDelegate) =>
      oldDelegate.time != time || oldDelegate.mouse != mouse;
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..strokeWidth = 0.5;

    const double step = 40.0;

    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) => false;
}
