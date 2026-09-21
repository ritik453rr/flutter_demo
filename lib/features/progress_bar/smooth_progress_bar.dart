import 'package:flutter/material.dart';

import '../circle_progress/circle_step_indicator_page.dart';

class SmoothProgressBarWidget extends StatefulWidget {
  const SmoothProgressBarWidget({super.key});

  @override
  State<SmoothProgressBarWidget> createState() =>
      _SmoothProgressBarWidgetState();
}

var progressValue = 0.4;

class _SmoothProgressBarWidgetState extends State<SmoothProgressBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              progressValue += 0.2;
              if (progressValue > 1) {
                progressValue = 0;
              }
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(1000),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      width: constraints.maxWidth * progressValue,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF6982F8),
                            Color(0xFFA547FF).withValues(alpha: 0.9),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            CircleStepIndicator(currentStep: 4),
          ],
        ),
      ),
    );
  }
}
