import 'package:flutter/material.dart';
import '../number_picker/number_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111210),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center area with Number Picker
            Expanded(
              child: Center(
                child: HorizontalNumberPicker(
                  // initialValue: _selectedTiming,
                  onChanged: (value) {
                    print(value);
                    // setState(() {
                    //   _selectedTiming = value;
                    // });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
