import 'package:flutter/material.dart';

class ResizableOverlay extends StatefulWidget {
  final double initialSize;
  final ValueChanged<double> onSizeChanged;

  const ResizableOverlay({
    Key? key,
    required this.initialSize,
    required this.onSizeChanged,
  }) : super(key: key);

  @override
  State<ResizableOverlay> createState() => _ResizableOverlayState();
}

class _ResizableOverlayState extends State<ResizableOverlay> {
  late double cutOutSize;
  Offset topLeftCorner = const Offset(100, 100);

  @override
  void initState() {
    super.initState();
    cutOutSize = widget.initialSize;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            topLeftCorner += details.delta;

            topLeftCorner = Offset(
              topLeftCorner.dx
                  .clamp(0, MediaQuery.of(context).size.width - cutOutSize),
              topLeftCorner.dy
                  .clamp(0, MediaQuery.of(context).size.height - cutOutSize),
            );
          });
        },
        child: Container(
          width: cutOutSize + 10,
          height: cutOutSize + 10,
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      double newSize = cutOutSize - details.delta.dy;

                      if (newSize >= 100) {
                        topLeftCorner += details.delta;
                        cutOutSize = newSize;
                        widget.onSizeChanged(cutOutSize);
                      }
                    });
                  },
                  child: _buildHandle(),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      double newSize = cutOutSize + details.delta.dx;

                      if (newSize >= 100) {
                        cutOutSize = newSize;
                        widget.onSizeChanged(cutOutSize);
                      }
                    });
                  },
                  child: _buildHandle(),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      double newSize = cutOutSize + details.delta.dy;

                      if (newSize >= 100) {
                        topLeftCorner += Offset(0, details.delta.dy);
                        cutOutSize = newSize;
                        widget.onSizeChanged(cutOutSize);
                      }
                    });
                  },
                  child: _buildHandle(),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      double newSize = cutOutSize + details.delta.dy;

                      if (newSize >= 100) {
                        cutOutSize = newSize;
                        widget.onSizeChanged(cutOutSize);
                      }
                    });
                  },
                  child: _buildHandle(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
