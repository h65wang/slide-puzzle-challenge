import 'dart:math';

import 'package:flutter/material.dart';
import 'package:slide_puzzle/ui/cao_3d.dart';

import 'ui/board_config.dart';

/// A test bench for [Cao3D] widget that displays a 3D puzzle piece.
/// To use it, modify `main.dart` to make it call `runApp(Test3D())`.
class Test3D extends StatefulWidget {
  const Test3D({Key? key}) : super(key: key);

  @override
  _Test3DState createState() => _Test3DState();
}

class _Test3DState extends State<Test3D> {
  double _rx = 0.0, _ry = 0.0, _size = 100.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: BoardConfig(
          unitSize: _size,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Cao3D(
                  width: _size * 2,
                  height: _size * 2,
                  depth: _size * 0.18,
                  rotateX: _rx,
                  rotateY: _ry,
                ),
                const SizedBox(height: 48),
                Text(
                  'rx: ${_rx.toStringAsFixed(2)}, '
                  'ry: ${_ry.toStringAsFixed(2)}',
                  style: const TextStyle(fontFamily: 'Courier'),
                ),
                Slider(
                  min: -1.2,
                  max: 1.2,
                  value: _rx,
                  onChanged: (v) => setState(() => _rx = v),
                ),
                Slider(
                  min: 0.0,
                  max: pi * 20,
                  value: _ry,
                  onChanged: (v) => setState(() => _ry = v),
                ),
                Slider(
                  min: 10.0,
                  max: 300.0,
                  value: _size,
                  onChanged: (v) => setState(() => _size = v),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
