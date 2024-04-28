import 'package:flutter/material.dart';
import 'package:stoodee/utilities/theme/theme.dart';

class StoodeeButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Size size;

  final Color color1 = usertheme.primaryAppColor;
  final Color color2 = usertheme.primaryAppColor.withOpacity(0.3);

  StoodeeButton(
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
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: usertheme.basicShaddow,
                blurRadius: 1,
                offset: const Offset(1, 2),
              )
            ]),
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
