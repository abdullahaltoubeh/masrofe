import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masrofe/models/transaction_model.dart';
import 'package:masrofe/moudles/home page/cubit/home_page_cubit.dart';
import 'package:masrofe/moudles/home page/widgets/type_chip.dart';

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  TransactionType _selectedType = TransactionType.expense;
  CurrencyType _selectedCurrency = CurrencyType.syp;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
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
      description: _descriptionController.text.trim(),
      currency: _selectedCurrency,
    );

    context.read<HomePageCubit>().addTransaction(transaction);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          _buildSheetHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 8,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleField(),
                    const SizedBox(height: 14),
                    _buildAmountField(),
                    const SizedBox(height: 14),
                    _buildDescriptionField(),
                    const SizedBox(height: 20),
                    _buildSectionLabel('نوع المعاملة'),
                    const SizedBox(height: 10),
                    _buildTypeSelector(),
                    const SizedBox(height: 20),
                    _buildSectionLabel('العملة'),
                    const SizedBox(height: 10),
                    _buildCurrencySelector(),
                    const SizedBox(height: 32),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSheetHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 16),
      decoration: const BoxDecoration(
        color: Color(0xFF6C63FF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'إضافة معاملة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF9E9E9E),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: _inputDecoration('العنوان'),
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'أدخل عنواناً' : null,
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: _inputDecoration('المبلغ'),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'أدخل مبلغاً';
        if (double.tryParse(v.trim()) == null) return 'رقم غير صحيح';
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: _inputDecoration('الوصف (اختياري)'),
      maxLines: 2,
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      children: [
        TypeChip(
          label: 'مصروف',
          color: const Color(0xFFFF5C6C),
          selected: _selectedType == TransactionType.expense,
          onTap: () => setState(() => _selectedType = TransactionType.expense),
        ),
        const SizedBox(width: 12),
        TypeChip(
          label: 'دخل',
          color: const Color(0xFF00C897),
          selected: _selectedType == TransactionType.income,
          onTap: () => setState(() => _selectedType = TransactionType.income),
        ),
      ],
    );
  }

  Widget _buildCurrencySelector() {
    const labels = {
      CurrencyType.syp: 'ل.س',
      CurrencyType.usd: 'دولار',
      CurrencyType.gold: 'ذهب',
    };
    const colors = {
      CurrencyType.syp: Color(0xFF6C63FF),
      CurrencyType.usd: Color(0xFF00C897),
      CurrencyType.gold: Color(0xFFF39C12),
    };
    return Row(
      children: CurrencyType.values.map((c) {
        final isSelected = _selectedCurrency == c;
        final color = colors[c]!;
        return Padding(
          padding: const EdgeInsets.only(left: 8),
          child: TypeChip(
            label: labels[c]!,
            color: color,
            selected: isSelected,
            onTap: () => setState(() => _selectedCurrency = c),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
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
          'إضافة',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}

