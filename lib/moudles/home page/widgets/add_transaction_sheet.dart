import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masrofe/models/transaction_model.dart';
import 'package:masrofe/moudles/home page/cubit/home_page_cubit.dart';

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  TransactionType _selectedType = TransactionType.expense;
  String _selectedCategory = 'Food';

  static const _categories = [
    'Food',
    'Work',
    'Entertainment',
    'Utilities',
    'Transport',
    'Health',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final transaction = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      type: _selectedType,
      date: DateTime.now(),
      category: _selectedCategory,
    );

    context.read<HomePageCubit>().addTransaction(transaction);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Transaction',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _titleController,
              decoration: _inputDecoration('Title'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter a title' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: _inputDecoration('Amount'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Enter an amount';
                if (double.tryParse(v.trim()) == null) return 'Invalid number';
                return null;
              },
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: _inputDecoration('Category'),
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _TypeChip(
                  label: 'Expense',
                  color: const Color(0xFFE74C3C),
                  selected: _selectedType == TransactionType.expense,
                  onTap: () =>
                      setState(() => _selectedType = TransactionType.expense),
                ),
                const SizedBox(width: 12),
                _TypeChip(
                  label: 'Income',
                  color: const Color(0xFF2ECC71),
                  selected: _selectedType == TransactionType.income,
                  onTap: () =>
                      setState(() => _selectedType = TransactionType.income),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _submit,
                child: const Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
