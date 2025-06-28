import 'package:flutter/material.dart';

class ScrollHint extends StatefulWidget {
  final Widget child;
  final double fadeHeight;
  final Alignment alignment;

  const ScrollHint({
    super.key,
    required this.child,
    this.fadeHeight = 30.0,
    this.alignment = Alignment.bottomCenter,
  });

  @override
  State<ScrollHint> createState() => _ScrollHintState();
}

class _ScrollHintState extends State<ScrollHint> with SingleTickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  bool _showHint = true;
  late final AnimationController _arrowController;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);

    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  void _onScroll() {
    final maxScroll = _controller.position.maxScrollExtent;
    final current = _controller.offset;
    setState(() => _showHint = current < maxScroll - 10);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    _arrowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fadeColor = Colors.black.withValues(alpha: 0.2);

    return Stack(
      alignment: widget.alignment,
      children: [
        SingleChildScrollView(
          controller: _controller,
          child: widget.child,
        ),
        if (_showHint)
          IgnorePointer(
            child: Container(
              height: widget.fadeHeight + 24,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    fadeColor,
                  ],
                ),
              ),
              child: FadeTransition(
                opacity: _arrowController.drive(CurveTween(curve: Curves.easeInOut)),
                child: SlideTransition(
                  position: _arrowController.drive(
                    Tween<Offset>(
                      begin: const Offset(0, 0),
                      end: const Offset(0, 0.2),
                    ).chain(CurveTween(curve: Curves.easeInOut)),
                  ),
                  child: const Icon(Icons.keyboard_arrow_down, size: 24),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
