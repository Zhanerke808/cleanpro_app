// widgets/star_rating.dart
import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class StarRating extends StatelessWidget {
  final int rating;
  final double size;
  final bool editable;
  final Function(int)? onRatingChanged;

  const StarRating({
    super.key,
    this.rating = 0,
    this.size = 24,
    this.editable = false,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: editable ? () => onRatingChanged?.call(index + 1) : null,
          child: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: index < rating ? AppTheme.gold : Colors.white38,
            size: size,
          ),
        );
      }),
    );
  }
}