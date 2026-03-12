import 'package:flutter/material.dart';

class CompleteButton extends StatelessWidget {
  const CompleteButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.condition = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool condition;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: condition
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox.square(
          dimension: 54,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                  : Text(
                      label,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
