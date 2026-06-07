import 'package:flutter/material.dart';
import 'package:masrofe/moudles/home page/widgets/summary_card.dart';

class SummaryRow extends StatelessWidget {
  final double totalIncome;
  final double totalExpenses;

  const SummaryRow({
    super.key,
    required this.totalIncome,
    required this.totalExpenses,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SummaryCard(
            label: 'Income',
            amount: totalIncome,
            icon: Icons.arrow_downward_rounded,
            color: const Color(0xFF2ECC71),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SummaryCard(
            label: 'Expenses',
            amount: totalExpenses,
            icon: Icons.arrow_upward_rounded,
            color: const Color(0xFFE74C3C),
          ),
        ),
      ],
    );
  }
}
