import 'package:flutter/widgets.dart';
import 'package:flutter_chirp/scratchcard/scratch_card_render.dart';
import 'package:flutter_chirp/scratchcard/scratch_data.dart';

class ScratchCardLayout extends SingleChildRenderObjectWidget {
  ScratchCardLayout({
                      Key key,
                      this.strokeWidth = 25.0,
                      @required this.data,
                      @required this.child,
                    }) : super(
    key: key,
    child: child,
  );

  final Widget child;
  final double strokeWidth;
  final ScratchData data;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return ScratchCardRender(
      strokeWidth: strokeWidth,
      data: data,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context, ScratchCardRender renderObject) {
    renderObject
      ..strokeWidth = strokeWidth
      ..data = data;
  }
}