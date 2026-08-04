import 'package:flutter/material.dart';

class CallProgressIndicator extends StatelessWidget {
  final int currentAttempt;
  final int maxAttempts;

  const CallProgressIndicator({
    super.key,
    required this.currentAttempt,
    required this.maxAttempts,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            maxAttempts,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _buildDot(index + 1 <= currentAttempt),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Attempt $currentAttempt of $maxAttempts',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.blue : Colors.grey.shade300,
      ),
    );
  }
}
