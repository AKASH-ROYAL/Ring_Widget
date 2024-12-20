import 'dart:math';

import 'package:flutter/material.dart';

class RenderRingWidget extends RenderBox {
  RenderRingWidget(
      {required this.color,
      required this.radius,
      required this.content,
      required this.fill,
      required this.smallCircleRadius,
      required this.smallCircleColors});

  Color color;
  double radius;

  List<String> content;
  bool fill;
  List<Color> smallCircleColors;
  double smallCircleRadius;

  @override
  void performLayout() {
    size = Size(radius * 2, radius * 2);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    var numSegments = content.length;
    final Paint paint = Paint()
      ..color = color
      ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke;

    // Center of the circle
    final Offset center = offset + Offset(radius, radius);

    // Define the bounding box for the circle
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    // Draw the main ring
    context.canvas.drawCircle(center, radius, paint);
    // Draw the small circle
    // List<Color> smallCircleColors = [
    //   Colors.green,
    //   Colors.green,
    //   Colors.blue,
    //   Colors.green,
    //   Colors.blue,
    //   Colors.yellow,
    // ];
    // Angle for each segment (360° / 6 = 60° or π/3 radians)
    double sweepAngle = 2 * 3.141592653589793 / numSegments;

    // Draw small circles at each mark
    for (int i = 0; i < numSegments; i++) {
      // Calculate the angle for the current segment
      final double angle = i * sweepAngle;

      // Calculate the position of the small circle
      final double x = center.dx + radius * cos(angle);
      final double y = center.dy + radius * sin(angle);

      final Paint smallCirclePaint = Paint()
        ..color = smallCircleColors[i % numSegments];
// Different color
      context.canvas.drawCircle(Offset(x, y), smallCircleRadius,
          smallCirclePaint); // Radius 10 for small circle

      final TextSpan span = TextSpan(
          text: content[i],
          style: TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold));

      final TextPainter textPainter =
          TextPainter(text: span, textDirection: TextDirection.ltr);

      textPainter.layout();

      final Offset textOffset =
          Offset(x - textPainter.width / 2, y - textPainter.height / 2);

      textPainter.paint(context.canvas, textOffset);
    }
  }
}

class RingWidget extends LeafRenderObjectWidget {
  final Color outerCircleColor;

  final double radius;
  final bool fill;
  final List<Color>? smallCircleColors;
  final List<String> content;
  final double smallCircleRadius;

  const RingWidget(
      {super.key,
      required this.outerCircleColor,
      required this.radius,
      required this.content,
      this.fill = false,
      this.smallCircleRadius = 40,
      this.smallCircleColors});

  @override
  RenderObject createRenderObject(BuildContext context) {
    // TODO: implement createRenderObject
    return RenderRingWidget(
        color: outerCircleColor,
        smallCircleRadius: smallCircleRadius,
        radius: radius,
        content: content,
        fill: fill,
        // numSegments: numSegments,
        smallCircleColors: smallCircleColors ??
            List.generate(content.length, (index) => Colors.green));
  }

  @override
  void updateRenderObject(BuildContext context, RenderRingWidget renderObject) {
    var availableColors = [
      Colors.blue,
      Colors.green,
      // Colors.yellow,
      // Colors.orange,
    ];
    renderObject
      ..color = outerCircleColor
      ..radius = radius
      ..content = content
      ..smallCircleRadius = smallCircleRadius
      ..smallCircleColors = smallCircleColors ??
          List.generate(content.length, (index) {
            return availableColors[Random().nextInt(availableColors.length)];
          })
      ..fill = fill;
  }
}

class CustomRingWidget extends StatelessWidget {
  const CustomRingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RingWidget(
            outerCircleColor: Colors.red,
            radius: 200,
            // numSegments: 6,
            content: [
              "SEO",
              "CMS",
              "DM",
              "DEV",
              "UI",
              "UX",
              "API",
              "DB",
              "Cloud",
              "AI",
              "ML",
              "IoT"
            ],
            smallCircleRadius: 40,
            // smallCircleColors: [
            //   Colors.blue,
            //   Colors.green,
            //   Colors.yellow,
            //   Colors.orange,
            // ],
          )
        ],
      ),
    );
  }
}
