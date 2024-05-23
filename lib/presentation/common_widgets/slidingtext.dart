import 'package:flutter/material.dart';

class SlidingText extends StatefulWidget {
  final String word;
  final int interval;
  final bool isDelay;

  const SlidingText(this.word, this.interval, this.isDelay, {super.key});

  @override
  SlidingTextState createState() => SlidingTextState();
}

class SlidingTextState extends State<SlidingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _animControllerSlideIn;
  late Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _animControllerSlideIn = AnimationController(
        duration: Duration(seconds: widget.interval), vsync: this);

    _slideIn =
        Tween<Offset>(begin: const Offset(-1.1, 0), end: const Offset(0, 0))
            .animate(CurvedAnimation(
                parent: _animControllerSlideIn, curve: Curves.easeOut));

    if (widget.isDelay) {
      Future.delayed(const Duration(milliseconds: 0), () {
        _animControllerSlideIn.fling();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return SlideTransition(
      position: _slideIn,
      child: Text(widget.word),
    );
  }
}
