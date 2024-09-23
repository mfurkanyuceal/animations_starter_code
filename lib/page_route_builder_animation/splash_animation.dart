import 'dart:async';

import 'package:flutter/material.dart';

class SplashAnimation extends StatefulWidget {
  const SplashAnimation({super.key});

  @override
  State<SplashAnimation> createState() => _SplashAnimationState();
}

class _SplashAnimationState extends State<SplashAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 10).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    // _animationController.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => const Destination(),
    //       ),
    //     );

    //     Timer(const Duration(milliseconds: 500), () {
    //       _animationController.reset();
    //     });
    //   }
    // });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).push(
          MyCustomPageTransition(
            route: const Destination(),
          ),
        );

        Timer(const Duration(milliseconds: 500), () {
          _animationController.reset();
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            _animationController.forward();
          },
          child: Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Destination extends StatelessWidget {
  const Destination({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('Go Back'),
      ),
      body: const Center(
        child: Text('Hello, World!'),
      ),
    );
  }
}

class MyCustomPageTransition extends PageRouteBuilder {
  final Widget route;
  MyCustomPageTransition({required this.route})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => route,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween(begin: const Offset(0, -1), end: Offset.zero).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ));
            return SlideTransition(
              position: tween,
              child: child,
            );
          },
        );
}
