import 'dart:math';

import 'package:flutter/material.dart';

import '../data/board_config.dart';
import 'cao_3d.dart';

/// A design studio used for developing and testing [Cao3D] widget.
/// To use it, modify `main.dart` to make it call `runApp(Cao3DStudio())`.
class Cao3DStudio extends StatefulWidget {
  const Cao3DStudio({Key? key}) : super(key: key);

  @override
  _Cao3DStudioState createState() => _Cao3DStudioState();
}

class _Cao3DStudioState extends State<Cao3DStudio> {
  double _rx = -0.5, _ry = 0.0, _size = 100.0;

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
                  'ry: ${_ry.toStringAsFixed(2)} '
                  '(${(_ry / pi).toStringAsFixed(2)} pi)',
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
                  max: pi * 10,
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
