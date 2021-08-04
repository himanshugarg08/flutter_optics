import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Physics',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double focalLength = 100.0;
  double objectMinimumDistance = -390;
  double objectMaximumDistance = -10.0;
  late double value;
  bool isConvex = true;

  @override
  void initState() {
    value = (objectMinimumDistance + objectMaximumDistance) / 2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String lens = isConvex ? "Convex" : "Concave";

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: LayoutBuilder(builder: (context, boxConstraints) {
        if ((boxConstraints.maxHeight <= 600 ||
                boxConstraints.maxWidth <= 1400) &&
            boxConstraints.maxHeight < boxConstraints.maxWidth) {
          return const Center(
            child: Text(
              "Please use larger Dimention of the tab for better Experience.",
              style: TextStyle(fontSize: 20),
            ),
          );
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 60,
                ),
                Column(
                  children: [
                    Text(
                      "Object Ray Diagram Of $lens Lens.",
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "u: Object Distance",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Text(
                          "v: Image Distance",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Text(
                          "f: Focal Length",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "u = ${value.toStringAsFixed(1)} units",
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        isConvex
                            ? Text(
                                "f = $focalLength units",
                                style: const TextStyle(fontSize: 18),
                              )
                            : Text(
                                "f = -$focalLength units",
                                style: const TextStyle(fontSize: 18),
                              ),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isConvex
                        ? const Text("  Convex Lens")
                        : const Text("Concave Lens"),
                    Switch(
                        value: !isConvex,
                        onChanged: (value) {
                          setState(() {
                            isConvex = !value;
                          });
                        }),
                  ],
                )
              ],
            ),
            AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              switchInCurve: Curves.fastOutSlowIn,
              child: SizedBox(
                key: ValueKey(isConvex),
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 2,
                child: CustomPaint(
                  painter: OpticsPainter(
                    objectDistance: value,
                    focalLength: isConvex ? focalLength : -focalLength,
                  ),
                ),
              ),
            ),
            Slider(
                value: value,
                max: objectMaximumDistance,
                min: objectMinimumDistance,
                onChanged: (v) {
                  setState(() {
                    value = v;
                  });
                }),
          ],
        );
      }),
    );
  }
}

class OpticsPainter extends CustomPainter {
  late double objectDistance;
  late double focalLength;

  OpticsPainter({required this.objectDistance, required this.focalLength});
  @override
  void paint(Canvas canvas, Size size) {
    double centerHeight = size.height / 2;
    double centerWidth = size.width / 2;
    // print(centerWidth);
    // print(centerHeight);
    // print(objectDistance);

    //Offset center = Offset(centerWidth, centerHeight);

    //background
    Paint paintForSimpleLine = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(centerWidth * 0.05, centerHeight),
        Offset(size.width - centerWidth * 0.05, centerHeight),
        paintForSimpleLine);
    canvas.drawLine(
        Offset(centerWidth, centerHeight * 0.1),
        Offset(centerWidth, size.height - centerHeight * 0.1),
        paintForSimpleLine);

    //lens properties

    canvas.drawLine(
        Offset(centerWidth + focalLength, centerHeight + 2),
        Offset(centerWidth + focalLength, centerHeight - 2),
        paintForSimpleLine);
    canvas.drawLine(
        Offset(centerWidth + 2 * focalLength, centerHeight + 2),
        Offset(centerWidth + 2 * focalLength, centerHeight - 2),
        paintForSimpleLine);

    if (focalLength > 0) {
      canvas.drawLine(
          Offset(centerWidth - focalLength, centerHeight + 2),
          Offset(centerWidth - focalLength, centerHeight - 2),
          paintForSimpleLine);
      canvas.drawLine(
          Offset(centerWidth - 2 * focalLength, centerHeight + 2),
          Offset(centerWidth - 2 * focalLength, centerHeight - 2),
          paintForSimpleLine);
    }

    const textStyleForF = TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    const textSpanForF = TextSpan(text: "F", style: textStyleForF);

    final textPainterForF =
        TextPainter(text: textSpanForF, textDirection: TextDirection.ltr);
    textPainterForF.layout(minWidth: 0, maxWidth: 200);

    textPainterForF.paint(
        canvas, Offset(centerWidth + focalLength + 2, centerHeight - 20));

    if (focalLength > 0) {
      textPainterForF.paint(
          canvas, Offset(centerWidth - focalLength + 2, centerHeight + 2));
    }

    const textSpanFor2F = TextSpan(text: "2F", style: textStyleForF);

    final textPainterFor2F =
        TextPainter(text: textSpanFor2F, textDirection: TextDirection.ltr);
    textPainterFor2F.layout(minWidth: 0, maxWidth: 200);

    textPainterFor2F.paint(
        canvas, Offset(centerWidth + 2 * focalLength + 2, centerHeight - 20));

    if (focalLength > 0) {
      textPainterFor2F.paint(
          canvas, Offset(centerWidth - 2 * focalLength + 2, centerHeight + 2));
    }
    //object
    Paint paintForObject = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    double objectHeight = 80.0;

    canvas.drawLine(
        Offset(centerWidth + objectDistance, centerHeight),
        Offset(centerWidth + objectDistance, centerHeight - objectHeight),
        paintForObject);

    //object naming
    const textStyleForObject = TextStyle(
      color: Colors.blue,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );

    const textSpanForObject =
        TextSpan(text: "object", style: textStyleForObject);

    final textPainterForObject =
        TextPainter(text: textSpanForObject, textDirection: TextDirection.ltr);
    textPainterForObject.layout(minWidth: 0, maxWidth: 200);

    textPainterForObject.paint(
        canvas, Offset(centerWidth + objectDistance + 2, centerHeight + 2));

    //image
    Paint paintForImage = Paint()
      ..color = Colors.green
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    late double imageDistance;

    imageDistance =
        (-objectDistance * focalLength) / (-objectDistance - focalLength);

    late double imageHeight;

    imageHeight = -(objectHeight * imageDistance / objectDistance);

    canvas.drawLine(
        Offset(centerWidth + imageDistance, centerHeight),
        Offset(centerWidth + imageDistance, centerHeight + imageHeight),
        paintForImage);

    //image naming
    const textStyleForImage = TextStyle(
      color: Colors.green,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );

    const textSpanForImage = TextSpan(text: "image", style: textStyleForImage);

    final textPainterForImage =
        TextPainter(text: textSpanForImage, textDirection: TextDirection.ltr);
    textPainterForImage.layout(minWidth: 0, maxWidth: 200);

    if (focalLength < 0) {
      textPainterForImage.paint(
          canvas, Offset(centerWidth + imageDistance + 4, centerHeight + 2));
    } else {
      textPainterForImage.paint(
          canvas, Offset(centerWidth + imageDistance + 4, centerHeight - 25));
    }
    //rays

    Paint paintForRays = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
        Offset(centerWidth + objectDistance, centerHeight - objectHeight),
        Offset(centerWidth + imageDistance, centerHeight + imageHeight),
        paintForRays);

    canvas.drawLine(
        Offset(centerWidth + objectDistance, centerHeight - objectHeight),
        Offset(centerWidth, centerHeight - objectHeight),
        paintForRays);

    canvas.drawLine(
        Offset(centerWidth, centerHeight - objectHeight),
        Offset(centerWidth + imageDistance, centerHeight + imageHeight),
        paintForRays);

    //dotted lines
    // if (focalLength < 0) {
    //   Paint paintForRays = Paint()
    //     ..color = Colors.red
    //     ..strokeWidth = 2
    //     ..strokeCap = StrokeCap.round;
    //   canvas.drawLine(
    //       Offset(centerWidth + imageDistance, centerHeight + imageHeight),
    //       Offset(centerWidth + focalLength, centerHeight),
    //       paintForRays);
    //   canvas.drawLine(
    //       Offset(centerWidth + imageDistance, centerHeight + imageHeight),
    //       Offset(centerWidth, centerHeight),
    //       paintForRays);
    // }

    //text painter
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 18,
    );

    final textSpan = TextSpan(
        text: "v = ${imageDistance.toStringAsFixed(1)} units",
        style: textStyle);

    final textPainter =
        TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout(minWidth: 50, maxWidth: 200);

    textPainter.paint(
        canvas, Offset(centerWidth * (3 / 2), centerHeight * (1 / 10)));

    final textSpanForHeight = TextSpan(
        text: "Image height = ${imageHeight.abs().toStringAsFixed(1)} units",
        style: textStyle);

    final textPainterForHeight =
        TextPainter(text: textSpanForHeight, textDirection: TextDirection.ltr);
    textPainterForHeight.layout(minWidth: 50, maxWidth: 400);

    textPainterForHeight.paint(
        canvas, Offset(centerWidth * (3 / 2), centerHeight * (2.5 / 10)));
  }

  @override
  bool shouldRepaint(OpticsPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(OpticsPainter oldDelegate) => false;
}
