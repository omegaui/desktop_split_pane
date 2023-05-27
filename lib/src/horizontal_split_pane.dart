import 'package:flutter/material.dart';

import 'child_holder.dart';

class HorizontalSplitPane extends StatefulWidget {
  HorizontalSplitPane({
    super.key,
    required this.constraints,
    this.fractions,
    required this.separatorColor,
    required this.separatorThickness,
    required this.children,
    this.onResize,
  }) {
    children.removeWhere(
        (element) => element is Offstage && (element as Offstage).offstage);
  }

  final List<Widget> children;
  final BoxConstraints constraints;
  final List<double>? fractions;
  final Color separatorColor;
  final double separatorThickness;

  /// Called when widgets are resized or are just build again
  ///
  /// Parameter is the list of widths of each widget
  final void Function(List<double>)? onResize;

  @override
  State<HorizontalSplitPane> createState() => HorizontalSplitPaneState();
}

class HorizontalSplitPaneState extends State<HorizontalSplitPane> {
  late HorizontalResizeController sizeController;
  List<double> widths = [];
  bool scheduled = false;
  int previousBuildsChildrenLength = 0;

  void rebuild() {
    setState(() {});
  }

  void calculatePrefWidth() {
    previousBuildsChildrenLength = widget.children.length;
    double numberOfSeparators = widget.children.length - 1;
    double maxWidth = widget.constraints.maxWidth -
        numberOfSeparators * widget.separatorThickness;
    if (widget.fractions != null) {
      double sum = 0.0;
      for (var fraction in widget.fractions!) {
        sum += fraction;
      }
      if (sum == 1.0) {
        widths = [];
        if (widget.fractions!.length == widget.children.length) {
          for (var fraction in widget.fractions!) {
            widths.add(fraction * maxWidth);
          }
        } else if (widget.fractions!.length > widget.children.length) {
          for (var i = 0; i < widget.children.length; i++) {
            widths.add(widget.fractions![i] * maxWidth);
          }
          var lastIndex = widget.children.length - 1;
          var combinedFraction = widget.fractions![lastIndex];
          widths[lastIndex] = widths[lastIndex] / combinedFraction;
          for (var i = lastIndex + 1; i < widget.fractions!.length; i++) {
            combinedFraction += widget.fractions![i];
          }
          widths[lastIndex] = widths[lastIndex] * combinedFraction;
        }
      }
    } else {
      widths = List<double>.filled(
          widget.children.length, maxWidth / widget.children.length);
    }
    if (widget.onResize != null) {
      widget.onResize!(widths);
    }
  }

  @override
  void initState() {
    super.initState();
    calculatePrefWidth();
  }

  List<Widget> _build() {
    sizeController =
        HorizontalResizeController(constraints: widget.constraints);
    List<Widget> widgets = [];
    var index = -1;
    for (var child in widget.children) {
      index++;
      widgets.add(ChildHolder(child: child));
      widgets.add(HorizontalSeparator(
        index: index,
        paneState: this,
        separatorColor: widget.separatorColor,
        separatorThickness: widget.separatorThickness,
      ));
    }
    widgets.removeLast();
    List<ChildHolder> holders = [];
    for (var widget in widgets) {
      if (widget is ChildHolder) {
        holders.add(widget);
      }
    }
    sizeController.children = holders;
    sizeController.init(widths);
    return widgets;
  }

  void scheduleRebuild() {
    if (scheduled) {
      return;
    }
    scheduled = true;
    Future.delayed(Duration(milliseconds: 125), () {
      scheduled = false;
      rebuild();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (previousBuildsChildrenLength != widget.children.length) {
      calculatePrefWidth();
    }
    return NotificationListener(
      onNotification: (SizeChangedLayoutNotification notification) {
        calculatePrefWidth();
        Future.delayed(Duration(milliseconds: 125), () => scheduleRebuild());
        return true;
      },
      child: SizeChangedLayoutNotifier(
        child: Row(
          children: _build(),
        ),
      ),
    );
  }
}

class HorizontalResizeController {
  final BoxConstraints constraints;
  late List<ChildHolder> children;
  List<Size> sizes = [];

  HorizontalResizeController({
    required this.constraints,
  });

  void init(List<double> widths) {
    double prefHeight = constraints.maxHeight;
    for (var child in children) {
      child.size = Size(widths[children.indexOf(child)], prefHeight);
    }
  }
}

class HorizontalSeparator extends StatefulWidget {
  const HorizontalSeparator({
    super.key,
    required this.paneState,
    required this.index,
    required this.separatorColor,
    required this.separatorThickness,
  });

  final int index;
  final HorizontalSplitPaneState paneState;
  final Color separatorColor;
  final double separatorThickness;

  @override
  State<HorizontalSeparator> createState() => _HorizontalSeparatorState();
}

class _HorizontalSeparatorState extends State<HorizontalSeparator> {
  double startX = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        startX = details.localPosition.dx;
      },
      onPanUpdate: (details) {
        double diff = startX - details.localPosition.dx;
        if (diff != 0) {
          startX = details.localPosition.dx;
          var direction = diff < 0 ? "right" : "left";
          if (direction == "right") {
            if (widget.paneState.widths[widget.index + 1] + diff > 0) {
              widget.paneState.widths[widget.index] =
                  widget.paneState.widths[widget.index] - diff;
              widget.paneState.widths[widget.index + 1] =
                  widget.paneState.widths[widget.index + 1] + diff;
            }
          } else {
            if (widget.paneState.widths[widget.index] - diff > 0) {
              widget.paneState.widths[widget.index] =
                  widget.paneState.widths[widget.index] - diff;
              widget.paneState.widths[widget.index + 1] =
                  widget.paneState.widths[widget.index + 1] + diff;
            }
          }
          widget.paneState.rebuild();
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeColumn,
        child: Container(
          width: widget.separatorThickness,
          color: widget.separatorColor,
        ),
      ),
    );
  }
}
