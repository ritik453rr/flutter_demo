import 'package:flutter/material.dart';

class StepProgressBar extends StatefulWidget {
  const StepProgressBar({super.key});

  @override
  State<StepProgressBar> createState() => _StepProgressBarState();
}

var currentStep = 2;

class _StepProgressBarState extends State<StepProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              currentStep += 1;
              if (currentStep > 4) {
                currentStep = 0;
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
            Row(
              children: List.generate(4, (index) {
                final isFilled = index < currentStep;

                return Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.only(right: index != 3 ? 4 : 0),
                    height: 3,
                    decoration: BoxDecoration(
                      color: isFilled ? Colors.green : Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(1000),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
