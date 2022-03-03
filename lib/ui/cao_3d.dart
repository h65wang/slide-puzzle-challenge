import 'dart:math';

import 'package:flutter/material.dart';
import 'package:slide_puzzle/ui/shiny_text.dart';

class Cao3D extends StatelessWidget {
  final double width, height, depth;
  final double rotateX, rotateY;

  const Cao3D({
    Key? key,
    required this.width,
    required this.height,
    required this.depth,
    this.rotateX = 0.0,
    rotateY = 0.0,
  })  : rotateY = rotateY % (pi * 2),
        assert(
            rotateX <= 1.2 && rotateX >= -1.2,
            'rotateX: $rotateX, '
            'but only rotateX between -1.2 and 1.2 is supported.'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    late final front = Transform(
      transform: Matrix4.translationValues(0.0, 0.0, depth / -2),
      alignment: Alignment.center,
      child: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xff2c867b),
              Color(0xff50a464),
              Color(0xff399170),
              Color(0xff2c867b),
            ],
            stops: [0.0, 0.2, 0.4, 1.0],
          ),
        ),
        child: const Center(child: ShinyText(label: '曹操')),
      ),
    );

    late final back = Transform(
      transform: Matrix4.translationValues(0.0, 0.0, depth / 2),
      alignment: Alignment.center,
      child: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff0c665b),
              Color(0xff197150),
              Color(0xff0c665b),
            ],
            stops: [0.0, 0.2, 1.0],
          ),
        ),
      ),
    );

    final List<Widget> children;
    late final top = _buildSide(side: 0);
    late final starboard = _buildSide(side: 1);
    late final bottom = _buildSide(side: 2);
    late final port = _buildSide(side: 3);

    // Determine the layer order, divided into 45 degree sections.
    if (rotateY < pi / 4) {
      children = [starboard, front];
    } else if (rotateY < pi / 2) {
      children = [front, starboard];
    } else if (rotateY < 3 * pi / 4) {
      children = [back, starboard];
    } else if (rotateY < pi) {
      children = [starboard, back];
    } else if (rotateY < 5 * pi / 4) {
      children = [port, back];
    } else if (rotateY < 3 * pi / 2) {
      children = [back, port];
    } else if (rotateY < 7 * pi / 4) {
      children = [front, port];
    } else {
      children = [port, front];
    }
    if (rotateX > 0.0) {
      // fixme: 0.0 is not perfect - did not consider perspective
      children.add(top);
    } else {
      children.add(bottom);
    }

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(rotateX)
        ..rotateY(rotateY),
      alignment: Alignment.center,
      child: Stack(children: children),
    );
  }

  /// Build 4 thinner sides: 0=top; 1=starboard(right); 2=bottom; 3=port(left)
  Widget _buildSide({required int side}) {
    final double translate;
    switch (side) {
      case 0: // top
        translate = height / -2;
        break;
      case 1: // starboard
        translate = width / 2;
        break;
      case 2: // bottom
        translate = height / 2;
        break;
      case 3: // port
        translate = width / -2;
        break;
      default:
        throw Exception('Invalid side: $side');
    }

    final topOrBottom = side == 0 || side == 2;
    final Matrix4 transform;

    if (topOrBottom) {
      transform = Matrix4.identity()
        ..translate(0.0, translate, 0.0)
        ..rotateX(pi / 2);
    } else {
      transform = Matrix4.identity()
        ..translate(translate, 0.0, 0.0)
        ..rotateY(pi / 2);
    }

    return Positioned.fill(
      child: Transform(
        transform: transform,
        alignment: Alignment.center,
        child: Center(
          child: Container(
            width: topOrBottom ? width : depth,
            height: topOrBottom ? depth : height,
            decoration: const BoxDecoration(
              // color: Colors.primaries[side * 2].withOpacity(1.0),
              color: const Color(0xff0b4040),
              // borderRadius: BorderRadius.circular(unitSize * 0.04),
            ),
          ),
        ),
      ),
    );
  }
}
