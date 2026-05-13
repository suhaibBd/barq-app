import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class SeatIndicator extends StatelessWidget {
  final int totalSeats;
  final int reservedSeats;
  final double iconSize;

  const SeatIndicator({
    super.key,
    required this.totalSeats,
    required this.reservedSeats,
    this.iconSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalSeats, (i) {
        final isReserved = i < reservedSeats;
        return Padding(
          padding: EdgeInsets.only(left: i > 0 ? 4 : 0),
          child: Icon(
            Icons.event_seat_rounded,
            size: iconSize,
            color: isReserved ? AppColors.primary : AppColors.border,
          ),
        );
      }),
    );
  }
}
