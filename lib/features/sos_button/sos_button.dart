import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/extension/sized_box_extension.dart';

class SosButton extends StatefulWidget {
  final bool status;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onPress;
  final Duration holdDuration;

  const SosButton({
    super.key,
    this.status = false,
    this.onChanged,
    this.onPress,
    this.holdDuration = const Duration(seconds: 3),
  });

  @override
  State<SosButton> createState() => SosButtonState();
}

class SosButtonState extends State<SosButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool _isHolding = false;

  static const Color _red = Color(0xFFF4433D);
  static const Color _darkRing = Color(0xFF382426);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.holdDuration,
    )..addStatusListener(_handleAnimationStatus);
  }

  @override
  void didUpdateWidget(covariant SosButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.holdDuration != widget.holdDuration) {
      _controller.duration = widget.holdDuration;
    }

    if (oldWidget.status != widget.status && !widget.status) {
      _isHolding = false;
      _controller
        ..stop()
        ..reset();
    }
  }

  void _handleAnimationStatus(AnimationStatus animationStatus) {
    if (animationStatus != AnimationStatus.completed || !_isHolding) return;

    setState(() {
      _isHolding = false;
    });

    _controller.reset();

    widget.onChanged?.call(true);
    widget.onPress?.call();
  }

  void _startHolding() {
    if (_isHolding || widget.status) return;

    setState(() {
      _isHolding = true;
    });

    _controller.forward(from: 0);
  }

  void _cancelHolding() {
    if (!_isHolding) return;

    _controller
      ..stop()
      ..reset();

    setState(() {
      _isHolding = false;
    });
  }

  void reset() {
    _controller
      ..stop()
      ..reset();

    if (!mounted) return;

    setState(() {
      _isHolding = false;
    });

    widget.onChanged?.call(false);
  }

  @override
  void dispose() {
    _controller
      ..removeStatusListener(_handleAnimationStatus)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 250,
        height: 250,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer border: animated progress.
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(244, 244),
                  painter: _SosProgressPainter(
                    progress: _controller.value,
                    trackColor: _darkRing,
                    progressColor: _red,
                    strokeWidth: 11,
                  ),
                );
              },
            ),

            // Only the red middle circle responds to touch.
            Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: (_) => _startHolding(),
              onPointerUp: (_) => _cancelHolding(),
              onPointerCancel: (_) => _cancelHolding(),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final int secondsRemaining =
                      (widget.holdDuration.inMilliseconds *
                              (1 - _controller.value) /
                              1000)
                          .ceil()
                          .clamp(0, widget.holdDuration.inSeconds);

                  return AnimatedScale(
                    scale: _isHolding ? 0.97 : 1,
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 222,
                      height: 222,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFF4433D), Color(0xFFD51D1D)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _red.withValues(
                              alpha: _isHolding ? 0.35 : 0.18,
                            ),
                            blurRadius: _isHolding ? 26 : 18,
                            spreadRadius: _isHolding ? 3 : 1,
                          ),
                        ],
                      ),
                      child: Center(
                        child: _isHolding
                            ? _buildCountdown(secondsRemaining)
                            : _buildButtonContent(),
                      ),
                     ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.notifications_active, size: 54, color: Colors.white),
        8.h,
        const Text(
          'SOS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCountdown(int secondsRemaining) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$secondsRemaining',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 68,
            fontWeight: FontWeight.bold,
          ),
        ),
        2.h,
        const Text(
          'seconds remaining',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _SosProgressPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  const _SosProgressPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = math.min(size.width, size.height) / 2 - strokeWidth / 2;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Unfilled dark outer border.
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress moves clockwise from 12 o'clock.
    if (progress <= 0) return;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _SosProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
