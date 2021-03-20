import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MousePainter extends CustomPainter {
  List<Offset> offsets;
  Color pickedColor;
  List<Color> rainbow = [
    Color(0XFF80F31F),
    Color(0XFFA5DE0B),
    Color(0XFFC7C101),
    Color(0XFFE39E03),
    Color(0XFFF6780F),
    Color(0XFFFE5326),
    Color(0XFFFB3244),
    Color(0XFFED1868),
    Color(0XFFD5078E),
    Color(0XFFB601B3),
    Color(0XFF9106D3),
    Color(0XFF6B16EC),
    Color(0XFF472FFA),
    Color(0XFF2850FE),
    Color(0XFF1175F7),
    Color(0XFF039BE5),
    Color(0XFF01BECA),
    Color(0XFF0ADCA8),
    Color(0XFF1DF283),
    Color(0XFF3AFD5D)
  ];

  MousePainter(this.offsets, {this.pickedColor});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    var rainbowIndex = 0;

    Paint backgroundPaint = Paint()..color = Colors.black87;
    canvas.drawRect(rect, backgroundPaint);
    Paint paint = Paint()
      ..color = Colors.red[800]
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10
      ..isAntiAlias = true;

    for (int i = 0; i < offsets.length - 1; i++) {
      if (rainbowIndex == rainbow.length) {
        rainbowIndex = 0;
      }
      if (pickedColor == null) {
        paint.color = rainbow[rainbowIndex];
      } else {
        paint.color = pickedColor;
      }

      if (offsets[i] != null && offsets[i + 1] != null) {
        canvas.drawLine(offsets[i], offsets[i + 1], paint);
      } else if (offsets[i] != null && offsets[i + 1] == null) {
        canvas.drawPoints(PointMode.points, [offsets[i]], paint);
      }
      rainbowIndex++;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class Math {}
