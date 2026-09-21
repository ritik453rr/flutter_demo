import 'package:flutter/material.dart';

class ExpensionTilePage extends StatefulWidget {
  const ExpensionTilePage({super.key});

  @override
  State<ExpensionTilePage> createState() => _ExpensionTilePageState();
}

class _ExpensionTilePageState extends State<ExpensionTilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ExpensionTileWidget()
          ],
        ),
      ),
    );
  }
}

class ExpensionTileWidget extends StatelessWidget {
  const ExpensionTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 22.5,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14),
          childrenPadding: EdgeInsets.zero,
          expansionAnimationStyle: const AnimationStyle(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            reverseDuration: Duration(milliseconds: 300),
            reverseCurve: Curves.easeInOut,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide.none,
          ),
          collapsedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide.none,
          ),

          leading: Text("Leading test"),
          expandedAlignment: Alignment.centerLeft,
          onExpansionChanged: (c) {},
          title: const SizedBox(),
          children: [
            Container(height: 100, width: double.infinity, color: Colors.red),
          ],
        ),
      ),
    );
  }
}
