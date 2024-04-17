import 'package:flutter/material.dart';
import 'package:stoodee/utilities/globals.dart';

class StoodeeButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Size size;

  final Color color1 = primaryAppColor;
  final Color color2 = const Color.fromRGBO(92, 0, 208, 1.0);

  const StoodeeButton(
      {super.key,
      required this.child,
      required this.onPressed,
      this.size = const Size(10, 10)});

  Widget resolveWidgetSize() {
    if (size == const Size(10, 10)) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: FittedBox(fit: BoxFit.fitWidth, child: child),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          alignment: Alignment.center,
          width: size.width,
          height: size.height,
          child: child,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPressed,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(80, 80, 80, 1.0),
              blurRadius: 1,
              offset: Offset(1,2),
            )
          ]
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Container(
            decoration: BoxDecoration(
                color: color1,
                border: Border(
                  bottom: BorderSide(
                    color: color2,
                    width: 2.5,
                  ),
                )),
            child: resolveWidgetSize(),
          ),
        ),
      ),
    );
  }
}
