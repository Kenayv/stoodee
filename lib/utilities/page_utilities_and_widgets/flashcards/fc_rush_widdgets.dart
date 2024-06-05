import 'package:flutter/material.dart';
import 'package:stoodee/utilities/theme/theme.dart';

Container buildTimer() {
  Container container = Container();

  return container;
}

Column buildMissCount(int count) {
  return Column(
    children: [
      Text("Misses:", style: TextStyle(color: usertheme.textColor)),
      Row(
        children: [
          for (int i = 0; i < count; i++)
            const Icon(
              Icons.close,
              color: Colors.red,
            ),
          if (count == 0)
            Text("none", style: TextStyle(color: usertheme.textColor))
        ],
      ),
    ],
  );
}
