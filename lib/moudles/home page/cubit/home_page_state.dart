part of 'home_page_cubit.dart';

abstract class HomePageState {}

class HomePageInitial extends HomePageState {}

class HomePageLoaded extends HomePageState {
  final double balance;
  final double totalIncome;
  final double totalExpenses;
  final List<TransactionModel> recentTransactions;

  HomePageLoaded({
    required this.balance,
    required this.totalIncome,
    required this.totalExpenses,
    required this.recentTransactions,
  });
}
