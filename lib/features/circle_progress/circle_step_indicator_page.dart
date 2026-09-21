import 'dart:math';
import 'package:flutter/material.dart';

import '../flush_bar/flush_bar.dart';

class CircleStepIndicatorPage extends StatefulWidget {
  const CircleStepIndicatorPage({super.key});

  @override
  State<CircleStepIndicatorPage> createState() =>
      _CircleStepIndicatorPageState();
}

class _CircleStepIndicatorPageState extends State<CircleStepIndicatorPage> {
  int step = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: () {
            CustomFlushBar.show(context, msg: "Step $step completed!");
            // setState(() {
            //   step += 1;
            //   if (step > 4) {
            //     step = 1;
            //   }
            // });
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleStepIndicator(currentStep: step, unfilledColor: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class CircleStepIndicator extends StatefulWidget {
  final int currentStep;
  final double size;
  final double strokeWidth;
  final List<Color> stepColors;
  final double stepPadding;
  final Color unfilledColor;

  const CircleStepIndicator({
    super.key,
    required this.currentStep,
    this.size = 200,
    this.strokeWidth = 20,
    this.stepColors = const [
      Colors.green,
      Colors.red,
      Colors.yellow,
      Colors.orange,
    ],
    this.stepPadding = 10.0,
    this.unfilledColor = Colors.greenAccent,
  });

  @override
  CircleStepIndicatorState createState() => CircleStepIndicatorState();
}

class CircleStepIndicatorState extends State<CircleStepIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  double _oldStep = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _animation =
        Tween<double>(begin: 0, end: widget.currentStep.toDouble()).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        )..addListener(() {
          setState(() {});
        });

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant CircleStepIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.currentStep != oldWidget.currentStep) {
      _oldStep = _animation.value;
      _controller.reset();
      _animation =
          Tween<double>(
              begin: _oldStep,
              end: widget.currentStep.toDouble(),
            ).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
            )
            ..addListener(() {
              setState(() {});
            });
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: Size.square(widget.size),
          painter: StepProgressPainter(
            progress: _animation.value,
            stepPadding: widget.stepPadding,
            stepColors: widget.stepColors,
            strokeWidth: widget.strokeWidth,
            unfilledColor: widget.unfilledColor,
          ),
        ),
      ],
    );
  }
}

class StepProgressPainter extends CustomPainter {
  final double progress;
  final List<Color> stepColors;
  final double strokeWidth;
  final Color unfilledColor;
  final double stepPadding;

  StepProgressPainter({
    required this.progress,
    required this.stepColors,
    required this.strokeWidth,
    required this.unfilledColor,
    required this.stepPadding,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.width / 2) - strokeWidth / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final totalSteps = stepColors.length;
    final anglePerStep = 2 * pi / totalSteps;

    // Angle for rounded caps offset
    final capRadius = stepPadding; //5.0;//strokeWidth / 2;
    final capAngle = asin(capRadius / radius);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw all steps as unfilled (grey)
    paint.color = unfilledColor;
    for (int i = 0; i < totalSteps; i++) {
      final startAngle = -pi / 2 + anglePerStep * i + capAngle;
      final sweepAngle = anglePerStep - 2 * capAngle;
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
    }

    // Draw filled steps on top
    for (int i = 0; i < totalSteps; i++) {
      final stepProgress = (progress - i).clamp(0.0, 1.0);
      if (stepProgress <= 0) continue;

      paint.color = stepColors[i];

      final startAngle = -pi / 2 + anglePerStep * i + capAngle;
      final sweepAngle = (anglePerStep - 2 * capAngle) * stepProgress;

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant StepProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.stepColors != stepColors ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.unfilledColor != unfilledColor;
  }
}
