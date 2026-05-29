// widgets/status_badge.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_constants.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final bool large;

  const StatusBadge({super.key, required this.status, this.large = false});

  @override
  Widget build(BuildContext context) {
    final color = AppConstants.statusColors[status] ?? Colors.grey;
    final name = AppConstants.statusNames[status] ?? status;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: large ? 16 : 10, vertical: large ? 8 : 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(large ? 16 : 10),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: large ? 10 : 8,
            height: large ? 10 : 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 6),
          Text(
            name,
            style: GoogleFonts.montserrat(
              color: color,
              fontSize: large ? 14 : 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}