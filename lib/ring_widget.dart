import 'dart:math';

import 'package:flutter/material.dart';

class RenderRingWidget extends RenderBox {
  RenderRingWidget(
      {required this.color,
      required this.radius,
      required this.content,
      required this.ringPadding,
      required this.fill,
      required this.ringItemsCount,
      required this.contentStyle,
      required this.smallCircleRadius,
      required this.smallCircleColors})
      : assert(radius > 0, "Radius must be greater than zero"),
        assert(ringPadding >= 0, "Ring padding must not be negative."),
        assert(
            ringItemsCount > 0, "Ring items count must be greater than zero."),
        assert(smallCircleRadius > 0,
            "Small circle radius must be greater than zero."),
        assert(content.isNotEmpty, "Content cannot be empty.");

  Color color;
  double radius;
  List<String> content;
  int ringItemsCount;
  bool fill;
  List<Color> smallCircleColors;
  double smallCircleRadius;
  double ringPadding;
  TextStyle contentStyle;

  @override
  void performLayout() {
    int numRings = (content.length / 6).ceil();

    double totalRadius =
        radius + (numRings - 1) * (smallCircleRadius + ringPadding);
    size = Size(totalRadius * 2, totalRadius * 2);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Paint paint = Paint()
      ..color = color
      ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke;

    final Offset center = offset + Offset(size.width / 2, size.height / 2);
    Paint centerPointPaint = Paint()..color = Colors.black;

    context.canvas.drawCircle(center, 20, centerPointPaint);

    int numRings = (content.length / ringItemsCount).ceil();
    int contentIndex = 0;

    for (int ringIndex = 0; ringIndex < numRings; ringIndex++) {
      double currentRadius =
          radius + ringIndex * (smallCircleRadius + ringPadding);
      context.canvas.drawCircle(center, currentRadius, paint);

      int itemsInRing = min(ringItemsCount, content.length - contentIndex);
      double baseAngle = ringIndex % 2 == 0 ? 0 : (pi / itemsInRing);
      double sweepAngle = 2 * pi / itemsInRing;

      for (int i = 0; i < itemsInRing; i++) {
        final double angle = baseAngle + i * sweepAngle;

        final double x = center.dx + currentRadius * cos(angle);

        final double y = center.dy + currentRadius * sin(angle);

        final Paint smallCirclePaint = Paint()
          ..color = smallCircleColors[
              ((contentIndex + i) % smallCircleColors.length).toInt()];

        context.canvas
            .drawCircle(Offset(x, y), smallCircleRadius, smallCirclePaint);

        final TextSpan span =
            TextSpan(text: content[contentIndex + i], style: contentStyle);

        final TextPainter textPainter =
            TextPainter(text: span, textDirection: TextDirection.ltr);

        textPainter.layout();

        final Offset textOffset =
            Offset(x - textPainter.width / 2, y - textPainter.height / 2);

        textPainter.paint(context.canvas, textOffset);
      }

      contentIndex += itemsInRing;
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
  final double ringPadding;
  final int ringItemsCount;
  final TextStyle contentStyle;

  RingWidget(
      {super.key,
      required this.outerCircleColor,
      required this.radius,
      this.ringPadding = 10.0,
      required this.content,
      this.ringItemsCount = 6,
      this.fill = false,
      this.smallCircleRadius = 40,
      this.contentStyle = const TextStyle(
          color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
      this.smallCircleColors})
      : assert(radius > 0, "Radius must be greater than zero"),
        assert(radius > 0, "Radius must be greater than zero"),
        assert(ringPadding >= 0, "Ring padding must not be negative."),
        assert(
            ringItemsCount > 0, "Ring items count must be greater than zero."),
        assert(smallCircleRadius > 0,
            "Small circle radius must be greater than zero."),
        assert(content.isNotEmpty, "Content cannot be empty.");

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderRingWidget(
        color: outerCircleColor,
        smallCircleRadius: smallCircleRadius,
        contentStyle: contentStyle,
        radius: radius,
        content: content,
        fill: fill,
        ringPadding: ringPadding,
        ringItemsCount: ringItemsCount,
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
      ..contentStyle = contentStyle
      ..radius = radius
      ..content = content
      ..ringPadding = ringPadding
      ..ringItemsCount = ringItemsCount
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
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RingWidget(
            outerCircleColor: Colors.grey,
            radius: 200,
            contentStyle: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ringItemsCount: 6,
            content: const [
              "SEO",
              "CMS",
              "DM",
              "DEV",
            ],
            ringPadding: 20,
            smallCircleRadius: 30,
          )
        ],
      ),
    );
  }
}
