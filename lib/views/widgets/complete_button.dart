import 'package:flutter/material.dart';

class CompleteButton extends StatelessWidget {
  const CompleteButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onPressed == null;

    return GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isLoading
              ? theme.colorScheme.primary
              : isDisabled
                  ? Colors.grey.shade300
                  : (color ?? theme.colorScheme.primary),
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
                        color: isDisabled
                            ? Colors.grey.shade500
                            : theme.colorScheme.onPrimary,
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
