import 'package:flutter/material.dart';

class AnimatedCircularProgressIndicator extends StatelessWidget {
  final int progress;

  const AnimatedCircularProgressIndicator({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated Circular Progress Bar
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress.toDouble()),
            duration: const Duration(seconds: 2),
            builder: (context, value, child) {
              return CircularProgressIndicator(
                value: value / 100, // Divide by 100 to get a percentage
                strokeWidth: 8.0,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              );
            },
          ),
          const SizedBox(height: 8),
          // Progress text below the progress circle
          Text(
            '$progress%',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
