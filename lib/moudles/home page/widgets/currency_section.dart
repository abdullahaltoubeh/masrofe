import 'package:flutter/material.dart';
import 'package:masrofe/models/transaction_model.dart';
import 'package:masrofe/moudles/home page/cubit/home_page_cubit.dart';

class CurrencySection extends StatelessWidget {
  final List<CurrencySummary> currencies;

  const CurrencySection({super.key, required this.currencies});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: currencies
          .map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _CurrencyCard(summary: c),
              ))
          .toList(),
    );
  }
}

class _CurrencyCard extends StatelessWidget {
  final CurrencySummary summary;

  const _CurrencyCard({required this.summary});

  Color get _color {
    switch (summary.currency) {
      case CurrencyType.syp:
        return const Color(0xFF6C63FF);
      case CurrencyType.usd:
        return const Color(0xFF27AE60);
      case CurrencyType.gold:
        return const Color(0xFFF39C12);
    }
  }

  IconData get _icon {
    switch (summary.currency) {
      case CurrencyType.syp:
        return Icons.monetization_on_outlined;
      case CurrencyType.usd:
        return Icons.attach_money;
      case CurrencyType.gold:
        return Icons.toll_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _color.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(right: BorderSide(color: _color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(_icon, color: _color, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                summary.label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: _color,
                ),
              ),
              const Spacer(),
              Text(
                '${summary.balance.toStringAsFixed(2)} ${summary.symbol}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: summary.balance >= 0
                      ? const Color(0xFF2ECC71)
                      : const Color(0xFFE74C3C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _StatChip(
                label: 'دخل',
                value: '${summary.totalIncome.toStringAsFixed(0)} ${summary.symbol}',
                color: const Color(0xFF2ECC71),
                icon: Icons.arrow_downward_rounded,
              ),
              const SizedBox(width: 10),
              _StatChip(
                label: 'مصروف',
                value: '${summary.totalExpenses.toStringAsFixed(0)} ${summary.symbol}',
                color: const Color(0xFFE74C3C),
                icon: Icons.arrow_upward_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(color: color, fontSize: 11),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
