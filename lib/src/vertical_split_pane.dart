import 'package:desktop_split_pane/src/child_holder.dart';
import 'package:flutter/material.dart';

class VerticalSplitPane extends StatefulWidget {
  VerticalSplitPane({
    super.key,
    required this.children,
    required this.constraints,
    this.fractions,
    required this.separatorColor,
    required this.separatorThickness,
  });

  final List<Widget> children;
  final BoxConstraints constraints;
  final List<double>? fractions;
  final Color separatorColor;
  final double separatorThickness;

  @override
  State<VerticalSplitPane> createState() => VerticalSplitPaneState();
}

class VerticalSplitPaneState extends State<VerticalSplitPane> {
  late VerticalResizeController sizeController;
  List<double> heights = [];
  bool scheduled = false;

  void rebuild() {
    setState(() {});
  }

  void calculatePrefHeight() {
    double numberOfSeparators = widget.children.length - 1;
    double maxHeight = widget.constraints.maxHeight -
        numberOfSeparators * widget.separatorThickness;
    if (widget.fractions != null) {
      double sum = 0.0;
      for (var fraction in widget.fractions!) {
        sum += fraction;
      }
      if (sum == 1.0) {
        heights = [];
        for (var fraction in widget.fractions!) {
          heights.add(fraction * maxHeight);
        }
      }
    } else {
      heights = List<double>.filled(
          widget.children.length, maxHeight / widget.children.length);
    }
  }

  @override
  void initState() {
    super.initState();
    calculatePrefHeight();
  }

  List<Widget> _build() {
    sizeController = VerticalResizeController(constraints: widget.constraints);
    List<Widget> widgets = [];
    var count = 0;
    var index = -1;
    for (var child in widget.children) {
      count++;
      index++;
      widgets.add(ChildHolder(child: child));
      if (count == 1) {
        count = 0;
        widgets.add(VerticalSeparator(
          index: index,
          paneState: this,
          separatorColor: widget.separatorColor,
          separatorThickness: widget.separatorThickness,
        ));
      }
    }
    widgets.removeLast();
    List<ChildHolder> holders = [];
    for (var widget in widgets) {
      if (widget is ChildHolder) {
        holders.add(widget);
      }
    }
    sizeController.children = holders;
    sizeController.init(heights);
    return widgets;
  }

  void scheduleRebuild() {
    if (scheduled) {
      return;
    }
    scheduled = true;
    Future.delayed(Duration(milliseconds: 500), () {
      scheduled = false;
      rebuild();
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (SizeChangedLayoutNotification notification) {
        calculatePrefHeight();
        Future.delayed(Duration(milliseconds: 500), () => scheduleRebuild());
        return true;
      },
      child: SizeChangedLayoutNotifier(
        child: Column(
          children: _build(),
        ),
      ),
    );
  }
}

class VerticalResizeController {
  final BoxConstraints constraints;
  late List<ChildHolder> children;
  List<Size> sizes = [];

  VerticalResizeController({
    required this.constraints,
  });

  void init(List<double> heights) {
    double prefWidth = constraints.maxWidth;
    for (var child in children) {
      child.size = Size(prefWidth, heights[children.indexOf(child)]);
    }
  }
}

class VerticalSeparator extends StatefulWidget {
  const VerticalSeparator({
    super.key,
    required this.paneState,
    required this.index,
    required this.separatorColor,
    required this.separatorThickness,
  });

  final int index;
  final VerticalSplitPaneState paneState;
  final Color separatorColor;
  final double separatorThickness;

  @override
  State<VerticalSeparator> createState() => _VerticalSeparatorState();
}

class _VerticalSeparatorState extends State<VerticalSeparator> {
  double startY = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        startY = details.localPosition.dy;
      },
      onPanUpdate: (details) {
        double diff = startY - details.localPosition.dy;
        if (diff != 0) {
          startY = details.localPosition.dy;
          var direction = diff < 0 ? "right" : "left";
          if (direction == "right") {
            if (widget.paneState.heights[widget.index + 1] + diff > 0) {
              widget.paneState.heights[widget.index] =
                  widget.paneState.heights[widget.index] - diff;
              widget.paneState.heights[widget.index + 1] =
                  widget.paneState.heights[widget.index + 1] + diff;
            }
          } else {
            if (widget.paneState.heights[widget.index] - diff > 0) {
              widget.paneState.heights[widget.index] =
                  widget.paneState.heights[widget.index] - diff;
              widget.paneState.heights[widget.index + 1] =
                  widget.paneState.heights[widget.index + 1] + diff;
            }
          }
          widget.paneState.rebuild();
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeRow,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: widget.separatorThickness,
          color: widget.separatorColor,
        ),
      ),
    );
  }
}
