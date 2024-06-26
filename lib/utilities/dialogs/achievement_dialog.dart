import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stoodee/utilities/theme/theme.dart';

Future<void> showAchievementDialog(
    {required BuildContext context,
    required String name,
    required String path,
    required String desc}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          children: [
            defaultBlurFilter(),
            Center(
              child: AlertDialog(
                elevation: 200,
                backgroundColor: usertheme.analogousColor,
                title: Center(
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
                    Text(
                      desc,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}
