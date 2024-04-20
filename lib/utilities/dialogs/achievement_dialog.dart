import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AchievementDialog extends StatelessWidget {
  final String name;
  final String path;
  final String desc;

  const AchievementDialog({
    super.key,
    required this.name,
    required this.path,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        shadowColor: Colors.black,
        elevation: 200,
        backgroundColor: analogusColor,
        title: Center(
            child: Text(name,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10.0),
            SvgPicture.asset(
              path,
              width: 150.0,
              height: 150.0,
            ),
            const SizedBox(height: 10.0),
            Text(desc, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
