import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
        return const Color(0xFF00C897);
      case CurrencyType.gold:
        return const Color(0xFFF39C12);
    }
  }

  List<Color> get _gradientColors {
    switch (summary.currency) {
      case CurrencyType.syp:
        return [const Color(0xFF6C63FF), const Color(0xFF9C8FFF)];
      case CurrencyType.usd:
        return [const Color(0xFF00C897), const Color(0xFF00897B)];
      case CurrencyType.gold:
        return [const Color(0xFFF39C12), const Color(0xFFE67E22)];
    }
  }

  IconData get _icon {
    switch (summary.currency) {
      case CurrencyType.syp:
        return Icons.monetization_on_rounded;
      case CurrencyType.usd:
        return Icons.attach_money_rounded;
      case CurrencyType.gold:
        return Icons.toll_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final isPositive = summary.balance >= 0;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _color.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  summary.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'الرصيد',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${NumberFormat('#,##0.##').format(summary.balance)} ${summary.symbol}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _StatChip(
                  label: 'دخل',
                  value:
                      '${NumberFormat('#,##0.##').format(summary.totalIncome)} ${summary.symbol}',
                  color: const Color(0xFF00C897),
                  icon: Icons.south_west_rounded,
                ),
                const SizedBox(width: 12),
                _StatChip(
                  label: 'مصروف',
                  value:
                      '${NumberFormat('#,##0.##').format(summary.totalExpenses)} ${summary.symbol}',
                  color: const Color(0xFFFF5C6C),
                  icon: Icons.north_east_rounded,
                ),
              ],
            ),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 12),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                        color: color.withValues(alpha: 0.7), fontSize: 11),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
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
