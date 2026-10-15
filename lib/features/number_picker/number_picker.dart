import 'package:flutter/material.dart';

class HorizontalNumberPicker extends StatefulWidget {
  final int initialValue;
  final List<int> values;
  final ValueChanged<int> onChanged;
  final String unitLabel;
  final Color activeColor;

  const HorizontalNumberPicker({
    super.key,
    this.initialValue = 15,
    this.values = const [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60],
    required this.onChanged,
    this.unitLabel = 'Mins',
    this.activeColor = const Color(0xFFD4FE00),
  });

  @override
  State<HorizontalNumberPicker> createState() => _HorizontalNumberPickerState();
}

class _HorizontalNumberPickerState extends State<HorizontalNumberPicker> {
  late PageController _pageController;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.values.indexOf(widget.initialValue);
    if (_selectedIndex == -1) _selectedIndex = 0;
    _pageController = PageController(
      initialPage: _selectedIndex,
      viewportFraction: 0.22,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 140,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Center selection circle outline
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: widget.activeColor, width: 1.5),
                ),
              ),

              // PageView horizontal scrollable list of numbers
              AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double currentPage = _selectedIndex.toDouble();
                  if (_pageController.hasClients &&
                      _pageController.position.haveDimensions) {
                    currentPage = _pageController.page ?? currentPage;
                  }

                  return PageView.builder(
                    controller: _pageController,
                    itemCount: widget.values.length,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                      widget.onChanged(widget.values[index]);
                    },
                    itemBuilder: (context, index) {
                      final double distance = (currentPage - index).abs();

                      // Interpolate opacity and scale based on distance from center
                      final double opacity = (1.0 - (distance * 0.45)).clamp(
                        0.25,
                        1.0,
                      );
                      final double scale = (1.0 - (distance * 0.15)).clamp(
                        0.72,
                        1.0,
                      );

                      final String formattedText = widget.values[index]
                          .toString()
                          .padLeft(2, '0');

                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                          );
                        },
                        child: Center(
                          child: Transform.scale(
                            scale: scale,
                            child: Opacity(
                              opacity: opacity,
                              child: Text(
                                formattedText,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 34,
                                  fontWeight: distance < 0.5
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Unit label under center circle
        Text(
          widget.unitLabel,
          style: TextStyle(
            color: widget.activeColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
