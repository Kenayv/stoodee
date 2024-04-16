import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:go_router/go_router.dart';

import '../globals.dart';
import '../containers.dart';


class AchievementTile extends StatelessWidget {
  const AchievementTile({super.key, required this.name, required this.path, required this.desc});
  final String name;
  final String path;
  final String desc;



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        context.go("/Achievements/dialog",extra:AchievementTileContainer(name: name, path: path, desc: desc));
      },
      child: Container(
        decoration: const BoxDecoration(
            color: analogusColor,
            borderRadius: BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(80, 80, 80, 1.0),
                blurRadius: 1,
                offset: Offset(1,2),
              )
            ]
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Svg(path),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
