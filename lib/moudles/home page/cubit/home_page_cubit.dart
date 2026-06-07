import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masrofe/models/transaction_model.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(HomePageInitial()) {
    loadData();
  }

  void loadData() {
    final transactions = [
      TransactionModel(
        id: '1',
        title: 'Salary',
        amount: 2000,
        type: TransactionType.income,
        date: DateTime.now().subtract(const Duration(days: 1)),
        category: 'Work',
      ),
      TransactionModel(
        id: '2',
        title: 'Groceries',
        amount: 150,
        type: TransactionType.expense,
        date: DateTime.now().subtract(const Duration(days: 2)),
        category: 'Food',
      ),
      TransactionModel(
        id: '3',
        title: 'Netflix',
        amount: 15,
        type: TransactionType.expense,
        date: DateTime.now().subtract(const Duration(days: 3)),
        category: 'Entertainment',
      ),
      TransactionModel(
        id: '4',
        title: 'Freelance',
        amount: 500,
        type: TransactionType.income,
        date: DateTime.now().subtract(const Duration(days: 4)),
        category: 'Work',
      ),
      TransactionModel(
        id: '5',
        title: 'Electricity Bill',
        amount: 80,
        type: TransactionType.expense,
        date: DateTime.now().subtract(const Duration(days: 5)),
        category: 'Utilities',
      ),
      TransactionModel(
        id: '6',
        title: 'Restaurant',
        amount: 55,
        type: TransactionType.expense,
        date: DateTime.now().subtract(const Duration(days: 6)),
        category: 'Food',
      ),
      TransactionModel(
        id: '7',
        title: 'Transport',
        amount: 30,
        type: TransactionType.expense,
        date: DateTime.now().subtract(const Duration(days: 7)),
        category: 'Transport',
      ),
      TransactionModel(
        id: '8',
        title: 'Gym',
        amount: 50,
        type: TransactionType.expense,
        date: DateTime.now().subtract(const Duration(days: 8)),
        category: 'Health',
      ),
    ];

    final totalIncome = transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalExpenses = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    emit(HomePageLoaded(
      balance: totalIncome - totalExpenses,
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      recentTransactions: transactions,
    ));
  }
}
