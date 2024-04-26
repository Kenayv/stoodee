import 'package:flutter/material.dart';
import 'package:stoodee/utilities/theme/theme.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title = '',
    this.leading,
    this.titleWidget,
    this.leftWidget,
  });

  final String title;
  final Widget? leading;
  final Widget? titleWidget;
  final Widget? leftWidget;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      height: 90, //TODO: In Future remove the height
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: usertheme.primaryAppColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          /*
          BoxShadow(
            color: primaryAppColor.withOpacity(0.3),
            offset: const Offset(0, 5),
            blurRadius: 20,
          ),

           */
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25 / 2.5),
        child: Stack(
          children: [
            Positioned.fill(
              child: titleWidget == null
                  ? Center(child: Text(title))
                  : Center(child: titleWidget!),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                leading ??
                    Transform.translate(
                      offset: const Offset(0, 0),
                      child: const Text("nothing"),
                    ),
                Align(
                    alignment: Alignment.centerRight,
                    child: leftWidget ?? const Text(''))
              ],
            )
          ],
        ),
      ),
    ));
  }

  @override
  Size get preferredSize => const Size(
        double.maxFinite,
        80,
      );
}
