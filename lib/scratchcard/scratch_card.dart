import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_chirp/scratchcard/scratch_card_layout.dart';
import 'dart:math' as math;

import 'package:flutter_chirp/scratchcard/scratch_data.dart';

class ScratchCard extends StatefulWidget {
  const ScratchCard({
    Key key,
    this.cover,
    this.reveal,
    this.strokeWidth = 25.0,
    this.finishPercent,
    this.onComplete,
  }) : super(key: key);

  final Widget cover;
  final Widget reveal;
  final double strokeWidth;
  final int finishPercent;
  final VoidCallback onComplete;

  @override
  _ScratchCardState createState() => _ScratchCardState();
}

class _ScratchCardState extends State<ScratchCard> {
  ScratchData _data = ScratchData();

  Offset _lastPoint;

  Offset _globalToLocal(Offset global) {
    return (context.findRenderObject() as RenderBox).globalToLocal(global);
  }

  double _distanceBetween(Offset point1, Offset point2) {
    return math.sqrt(math.pow(point2.dx - point1.dx, 2) +
        math.pow(point2.dy - point1.dy, 2));
  }

  double _angleBetween(Offset point1, Offset point2) {
    return math.atan2(point2.dx - point1.dx, point2.dy - point1.dy);
  }

  void _onPanDown(DragDownDetails details) {
    _lastPoint = _globalToLocal(details.globalPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final currentPoint = _globalToLocal(details.globalPosition);
    final distance = _distanceBetween(_lastPoint, currentPoint);
    final angle = _angleBetween(_lastPoint, currentPoint);
    for (double i = 0.0; i < distance; i++) {
      _data.addPoint(Offset(
        _lastPoint.dx + (math.sin(angle) * i),
        _lastPoint.dy + (math.cos(angle) * i),
      ));
    }
    _lastPoint = currentPoint;
  }

  void _onPanEnd(TapUpDetails details) {
    double touchArea = math.pi * widget.strokeWidth * widget.strokeWidth;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: _onPanDown,
      onPanUpdate: _onPanUpdate,
      onTapUp: _onPanEnd,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          widget.reveal,
          ScratchCardLayout(
            strokeWidth: widget.strokeWidth,
            data: _data,
            child: widget.cover,
          ),
        ],
      ),
    );
  }
}
