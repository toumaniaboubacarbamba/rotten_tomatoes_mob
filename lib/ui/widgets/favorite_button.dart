import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onToggle;
  final double size;
  final Color? backgroundColor;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onToggle,
    this.size = 16,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: backgroundColor ??
              (isFavorite
                  ? Colors.red.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.15)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : Colors.white,
          size: size,
        ),
      ),
    );
  }
}
