import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:masrofe/models/transaction_model.dart';
import 'package:masrofe/moudles/home page/cubit/home_page_cubit.dart';

class TransactionDetailPage extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailPage({super.key, required this.transaction});

  Color get _color => transaction.type == TransactionType.income
      ? const Color(0xFF2ECC71)
      : const Color(0xFFE74C3C);

  String get _currencySymbol {
    switch (transaction.currency) {
      case CurrencyType.syp:
        return 'ل.س';
      case CurrencyType.usd:
        return '\$';
      case CurrencyType.gold:
        return 'غ';
    }
  }

  String get _currencyLabel {
    switch (transaction.currency) {
      case CurrencyType.syp:
        return 'الليرة السورية';
      case CurrencyType.usd:
        return 'الدولار';
      case CurrencyType.gold:
        return 'الذهب';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'تفاصيل المعاملة',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAmountCard(isIncome),
            const SizedBox(height: 20),
            _buildInfoCard(context),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'حذف المعاملة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('هل تريد حذف هذه المعاملة؟ سيتم استرجاع الرصيد تلقائياً.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE74C3C),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<HomePageCubit>().deleteTransaction(transaction.id);
      if (context.mounted) Navigator.pop(context, true);
    }
  }

  Widget _buildAmountCard(bool isIncome) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _color.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border(right: BorderSide(color: _color, width: 5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isIncome
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  color: _color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                isIncome ? 'دخل' : 'مصروف',
                style: TextStyle(
                  color: _color,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            transaction.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${isIncome ? '+' : '-'}${transaction.amount.toStringAsFixed(2)} $_currencySymbol',
            style: TextStyle(
              color: _color,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildRow(
            Icons.calendar_today_outlined,
            'التاريخ',
            DateFormat('EEEE، d MMMM yyyy', 'ar').format(transaction.date),
          ),
          const Divider(height: 28),
          _buildRow(
            Icons.access_time_outlined,
            'الوقت',
            DateFormat('hh:mm a').format(transaction.date),
          ),
          const Divider(height: 28),
          _buildRow(
            Icons.account_balance_wallet_outlined,
            'العملة',
            _currencyLabel,
          ),
          if (transaction.description.isNotEmpty) ...[
            const Divider(height: 28),
            _buildDescription(),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF6C63FF)),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF2D3142),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.notes_outlined, size: 20, color: Color(0xFF6C63FF)),
            SizedBox(width: 12),
            Text(
              'الوصف',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          transaction.description,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF2D3142),
            height: 1.7,
          ),
        ),
      ],
    );
  }
}
