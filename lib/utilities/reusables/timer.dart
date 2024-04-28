import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stoodee/utilities/theme/theme.dart';

class TimerWidget extends StatefulWidget {
  TimerWidget({required this.startingseconds, required this.func});

  final int startingseconds;
  final Function() func;

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late int _seconds = widget.startingseconds;
  Timer? _timer;

  @override
  void initState() {
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds <= 1) {
        print("Timer internal: Finished");
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

  Widget build(BuildContext context) {
    int minutes = _seconds ~/ 60;
    int seconds = _seconds % 60;

    String timeString = '$minutes:${seconds < 10 ? '0$seconds' : seconds}';

    return Column(
      children: [
        Text(
          'Time remaining: $timeString',
          style: TextStyle(fontSize: 24, color: usertheme.textColor),
        ),
      ],
    );
  }
}
