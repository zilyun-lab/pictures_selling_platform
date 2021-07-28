// // Dart imports:
// import 'dart:math' as math;
//
// // Flutter imports:
// import 'package:flutter/material.dart';
//
// // Package imports:
// import 'package:arkit_plugin/arkit_plugin.dart';
// import 'package:vector_math/vector_math_64.dart' as vector;
//
// class WidgetProjectionPage extends StatefulWidget {
//   @override
//   _WidgetProjectionPageState createState() => _WidgetProjectionPageState();
// }
//
// class _WidgetProjectionPageState extends State<WidgetProjectionPage> {
//   ARKitController arkitController;
//   String anchorId;
//   double x, y;
//   double width = 1, height = 1;
//   Matrix4 transform = Matrix4.identity();
//
//   @override
//   void dispose() {
//     arkitController?.onAddNodeForAnchor = null;
//     arkitController?.onUpdateNodeForAnchor = null;
//     arkitController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//       appBar: AppBar(
//         title: const Text('Widget Projection'),
//       ),
//       body: Stack(
//         children: [
//           ARKitSceneView(
//             trackingImagesGroupName: 'AR Resources',
//             onARKitViewCreated: onARKitViewCreated,
//             worldAlignment: ARWorldAlignment.camera,
//             configuration: ARKitConfiguration.imageTracking,
//           ),
//           Positioned(
//             left: x,
//             top: y,
//             child: Container(
//               transform: transform,
//               width: width,
//               height: height,
//               child: const MyHomePage(
//                 title: 'Widgets in AR',
//               ),
//             ),
//           ),
//         ],
//       ));
//
//   void onARKitViewCreated(ARKitController arkitController) {
//     this.arkitController = arkitController;
//     this.arkitController.onAddNodeForAnchor = _handleAddAnchor;
//     this.arkitController.onUpdateNodeForAnchor = _handleUpdateAnchor;
//   }
//
//   void _handleAddAnchor(ARKitAnchor anchor) {
//     if (anchor is ARKitImageAnchor) {
//       anchorId = anchor.identifier;
//       _updatePosition(anchor);
//       _updateRotation(anchor);
//     }
//   }
//
//   void _handleUpdateAnchor(ARKitAnchor anchor) {
//     if (anchor.identifier == anchorId) {
//       _updatePosition(anchor);
//       _updateRotation(anchor);
//     }
//   }
//
//   Future _updateRotation(ARKitAnchor anchor) async {
//     final t = anchor.transform.clone();
//     t.invertRotation();
//     t.rotateZ(math.pi / 2);
//     t.rotateX(math.pi / 2);
//     setState(() {
//       transform = t;
//     });
//   }
//
//   Future _updatePosition(ARKitImageAnchor anchor) async {
//     final transform = anchor.transform;
//     final width = anchor.referenceImagePhysicalSize.x / 2;
//     final height = anchor.referenceImagePhysicalSize.y / 2;
//
//     final topRight = vector.Vector4(width, 0, -height, 1)
//       ..applyMatrix4(transform);
//     final bottomRight = vector.Vector4(width, 0, height, 1)
//       ..applyMatrix4(transform);
//     final bottomLeft = vector.Vector4(-width, 0, -height, 1)
//       ..applyMatrix4(transform);
//     final topLeft = vector.Vector4(-width, 0, height, 1)
//       ..applyMatrix4(transform);
//
//     final pointsWorldSpace = [topRight, bottomRight, bottomLeft, topLeft];
//
//     final pointsViewportSpace = pointsWorldSpace.map(
//         (p) => arkitController.projectPoint(vector.Vector3(p.x, p.y, p.z)));
//     final pointsViewportSpaceResults = await Future.wait(pointsViewportSpace);
//
//     setState(() {
//       x = pointsViewportSpaceResults[2].x;
//       y = pointsViewportSpaceResults[2].y;
//       this.width = pointsViewportSpaceResults[0]
//           .distanceTo(pointsViewportSpaceResults[3]);
//       this.height = pointsViewportSpaceResults[1]
//           .distanceTo(pointsViewportSpaceResults[2]);
//     });
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key key, this.title}) : super(key: key);
//   final String title;
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() => setState(() => _counter++);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
//
// class Test extends StatelessWidget {
//   const Test({Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center(
//           child: Image.network(
//               "https://firebasestorage.googleapis.com/v0/b/selling-pictures.appspot.com/o/IMG_5438.JPG?alt=media&token=df59a6cd-3a93-49b0-81dd-81777331d49e")),
//     );
//   }
// }

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';

class Bubbles extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BubblesState();
  }
}

class _BubblesState extends State<Bubbles> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List<Bubble> bubbles;
  final int numberOfBubbles = 200;
  final Color color = mainColorOfLEEWAY;
  final double maxBubbleSize = 10.0;

  @override
  void initState() {
    super.initState();

    // Initialize bubbles
    bubbles = List();
    int i = numberOfBubbles;
    while (i > 0) {
      bubbles.add(Bubble(color, maxBubbleSize));
      i--;
    }

    // Init animation controller
    _controller = new AnimationController(
        duration: const Duration(seconds: 1000), vsync: this);
    _controller.addListener(() {
      updateBubblePosition();
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter:
          BubblePainter(bubbles: bubbles, controller: _controller),
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height),
    );
  }

  void updateBubblePosition() {
    bubbles.forEach((it) => it.updatePosition());
    setState(() {});
  }
}

class BubblePainter extends CustomPainter {
  List<Bubble> bubbles;
  AnimationController controller;

  BubblePainter({this.bubbles, this.controller});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    bubbles.forEach((it) => it.draw(canvas, canvasSize));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Bubble {
  Color colour;
  double direction;
  double speed;
  double radius;
  double x;
  double y;

  Bubble(Color colour, double maxBubbleSize) {
    this.colour = colour.withOpacity(Random().nextDouble());
    this.direction = Random().nextDouble() * 360;
    this.speed = 1;
    this.radius = Random().nextDouble() * maxBubbleSize;
  }

  draw(Canvas canvas, Size canvasSize) {
    Paint paint = new Paint()
      ..color = colour
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    assignRandomPositionIfUninitialized(canvasSize);

    randomlyChangeDirectionIfEdgeReached(canvasSize);

    canvas.drawCircle(Offset(x, y), radius, paint);
  }

  void assignRandomPositionIfUninitialized(Size canvasSize) {
    if (x == null) {
      this.x = Random().nextDouble() * canvasSize.width;
    }

    if (y == null) {
      this.y = Random().nextDouble() * canvasSize.height;
    }
  }

  updatePosition() {
    var a = 180 - (direction + 90);
    direction > 0 && direction < 180
        ? x += speed * sin(direction) / sin(speed)
        : x -= speed * sin(direction) / sin(speed);
    direction > 90 && direction < 270
        ? y += speed * sin(a) / sin(speed)
        : y -= speed * sin(a) / sin(speed);
  }

  randomlyChangeDirectionIfEdgeReached(Size canvasSize) {
    if (x > canvasSize.width || x < 0 || y > canvasSize.height || y < 0) {
      direction = Random().nextDouble() * 360;
    }
  }
}
