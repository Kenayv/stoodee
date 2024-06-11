import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:stoodee/localization/locales.dart';
import 'package:stoodee/utilities/theme/theme.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget(
      {super.key, required this.startingseconds, required this.func});

  final int startingseconds;
  final Function() func;

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late int _seconds = widget.startingseconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds <= 1) {
        widget.func();
        _timer?.cancel();
        _seconds = 1;
      }

      setState(() {
        _seconds--;
      });
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _seconds = 0;
  }

  @override
  Widget build(BuildContext context) {
    int minutes = _seconds ~/ 60;
    int seconds = _seconds % 60;

    String timeString = '$minutes:${seconds < 10 ? '0$seconds' : seconds}';

    return Column(
      children: [
        Text(
          '${LocaleData.fcRushTimeRemaining.getString(context)} $timeString',
          style: TextStyle(fontSize: 24, color: usertheme.textColor),
        ),
      ],
    );
  }
}
