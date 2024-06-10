import 'package:flutter/material.dart';
import 'package:stoodee/utilities/theme/theme.dart';

class ReusableCard extends StatelessWidget {
  const ReusableCard({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        color: usertheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 2,
        shadowColor: usertheme.basicShaddow,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: usertheme.textColor),
            ),
          ),
        ),
      ),
    );
  }
}
