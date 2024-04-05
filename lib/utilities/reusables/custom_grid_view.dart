import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter/material.dart';

class CustomGridLayout extends StatefulWidget {
  const CustomGridLayout({
    super.key,
    required this.crossAxisCount,
    required this.items,
  })
  // we only plan to use this with 1 or 2 columns
      : assert(crossAxisCount == 1 || crossAxisCount == 2);
  final int crossAxisCount;
  final List<Widget>? items;

  @override
  State<CustomGridLayout> createState() => _CustomGridLayout();

}
class _CustomGridLayout extends State<CustomGridLayout>{

  @override
  Widget build(BuildContext context) {
    final rowCount = (widget.items!.length / widget.crossAxisCount).ceil();

    return LayoutGrid(
      columnSizes: widget.crossAxisCount == 2 ? [1.fr, 1.fr] : [1.fr],
      rowSizes: widget.items!.isEmpty ? [auto] : List.generate(rowCount, (_) => auto),
      rowGap: 20,
      columnGap: 0,
      children: [
        // render all the cards with *automatic child placement*
        for (var i = 0; i < widget.items!.length; i++) widget.items![i]
      ],
    );
  }
}

