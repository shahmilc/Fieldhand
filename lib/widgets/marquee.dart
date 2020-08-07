import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Marquee extends StatefulWidget {
  final Widget child;
  final Axis direction;
  final pauseDuration;
  final double forwardTimeFactor, backwardTimeFactor;

  Marquee({
    @required this.child,
    this.direction: Axis.horizontal,
    this.pauseDuration: const Duration(milliseconds: 1000),
    this.forwardTimeFactor: 1.0,
    this.backwardTimeFactor: 1.0,
  });

  @override
  _MarqueeState createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> {
  ScrollController _scrollController;
  Duration animationDuration;
  Duration backDuration;

  @override
  void initState() {
    _scrollController = ScrollController(initialScrollOffset: 50.0);
    WidgetsBinding.instance.addPostFrameCallback(scroll);
    super.initState();
  }

  @override
  void dispose(){
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: widget.child,
      scrollDirection: widget.direction,
      controller: _scrollController,
    );
  }

  void scroll(_) async {
    animationDuration = Duration(milliseconds: (10 * _scrollController.position.maxScrollExtent * widget.forwardTimeFactor).toInt());
    backDuration = Duration(milliseconds: (5 * _scrollController.position.maxScrollExtent * widget.backwardTimeFactor).toInt());
    while (_scrollController.hasClients && _scrollController.position.maxScrollExtent != 0.0) {
      await Future.delayed(widget.pauseDuration);
      if(_scrollController.hasClients && _scrollController.position.userScrollDirection == ScrollDirection.idle)
        await _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: animationDuration,
            curve: Curves.linear);
      await Future.delayed(widget.pauseDuration);
      if(_scrollController.hasClients && _scrollController.position.userScrollDirection == ScrollDirection.idle)
        await _scrollController.animateTo(0.0,
            duration: backDuration, curve: Curves.easeOut);
    }
  }
}