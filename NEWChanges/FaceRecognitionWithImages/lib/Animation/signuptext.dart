import 'package:flutter/material.dart';

class SlideAnimationManager {
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;

  SlideAnimationManager(TickerProvider vsync) {
    _slideController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: vsync,
    );

    _slideAnimation = Tween<double>(
      begin: 0.0, // Start off-screen to the left
      end: 1.0, // End on-screen
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
  }

  void startAnimation() {
    _slideController.forward();
  }

  void dispose() {
    _slideController.dispose();
  }

  Widget buildAnimatedText(String text, double fontSize, double screenHeight) {
    return SlideTransition(
      position: _slideAnimation.drive(
        Tween(begin: Offset(-1, 0), end: Offset(0, 0)),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.02),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
