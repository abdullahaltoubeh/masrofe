import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masrofe/data/transaction_repository.dart';
import 'package:masrofe/models/transaction_model.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  final TransactionRepository _repository;

  HomePageCubit(this._repository) : super(HomePageInitial()) {
    loadData();
  }

  Future<void> loadData() async {
    final transactions = await _repository.getAll();

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

  Future<void> addTransaction(TransactionModel transaction) async {
    await _repository.add(transaction);
    await loadData();
  }

  Future<void> deleteTransaction(String id) async {
    await _repository.delete(id);
    await loadData();
  }
}
