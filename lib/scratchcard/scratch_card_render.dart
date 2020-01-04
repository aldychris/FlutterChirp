import 'package:flutter/rendering.dart';
import 'package:flutter_chirp/scratchcard/scratch_data.dart';

class ScratchCardRender extends RenderProxyBox {
  ScratchCardRender({
                       RenderBox child,
                       double strokeWidth,
                       ScratchData data,
                     })  : assert(data != null),
      _strokeWidth = strokeWidth,
      _data = data,
      super(child);

  double _strokeWidth;
  ScratchData _data;

  set strokeWidth(double strokeWidth) {
    assert(strokeWidth != null);
    if (_strokeWidth == strokeWidth) {
      return;
    }
    _strokeWidth = strokeWidth;
    markNeedsPaint();
  }

  set data(ScratchData data) {
    assert(data != null);
    if (_data == data) {
      return;
    }
    if (attached) {
      _data.removeListener(markNeedsPaint);
      data.addListener(markNeedsPaint);
    }
    _data = data;
    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _data.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _data.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      context.canvas.saveLayer(offset & size, Paint());
      context.paintChild(child, offset);

      Paint clear = Paint()
        ..blendMode = BlendMode.clear;

      _data.points.forEach((point) =>
        context.canvas.drawCircle(offset + point, _strokeWidth, clear));

      context.canvas.restore();
    }
  }

  @override
  bool get alwaysNeedsCompositing => child != null;
}