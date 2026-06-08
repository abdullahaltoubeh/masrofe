import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masrofe/data/transaction_repository.dart';
import 'package:masrofe/moudles/home page/cubit/home_page_cubit.dart';
import 'package:masrofe/moudles/home page/widgets/add_transaction_sheet.dart';
import 'package:masrofe/moudles/home page/widgets/balance_card.dart';
import 'package:masrofe/moudles/home page/widgets/summary_row.dart';
import 'package:masrofe/moudles/home page/widgets/transaction_tile.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomePageCubit(TransactionRepository()),
      child: BlocBuilder<HomePageCubit, HomePageState>(
        builder: (context, state) {
          if (state is HomePageLoaded) {
            return _HomePageContent(state: state);
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  final HomePageLoaded state;

  const _HomePageContent({required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFAB(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF6C63FF),
      elevation: 0,
      title: const Text(
        'مصروفي',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBody() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        BalanceCard(balance: state.balance),
        const SizedBox(height: 20),
        SummaryRow(
          totalIncome: state.totalIncome,
          totalExpenses: state.totalExpenses,
        ),
        const SizedBox(height: 28),
        const Text(
          'آخر المعاملات',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 12),
        ...state.recentTransactions.map((t) => TransactionTile(transaction: t)),
      ],
    );
  }

  FloatingActionButton _buildFAB(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color(0xFF6C63FF),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => BlocProvider.value(
            value: context.read<HomePageCubit>(),
            child: const AddTransactionSheet(),
          ),
        );
      },
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}