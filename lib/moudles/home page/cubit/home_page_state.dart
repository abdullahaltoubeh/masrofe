part of 'home_page_cubit.dart';

abstract class HomePageState {}

class HomePageInitial extends HomePageState {}

class CurrencySummary {
  final CurrencyType currency;
  final double balance;
  final double totalIncome;
  final double totalExpenses;

  CurrencySummary({
    required this.currency,
    required this.balance,
    required this.totalIncome,
    required this.totalExpenses,
  });

  String get label {
    switch (currency) {
      case CurrencyType.syp:
        return 'الليرة السورية';
      case CurrencyType.usd:
        return 'الدولار';
      case CurrencyType.gold:
        return 'الذهب';
    }
  }

  String get symbol {
    switch (currency) {
      case CurrencyType.syp:
        return 'ل.س';
      case CurrencyType.usd:
        return '\$';
      case CurrencyType.gold:
        return 'غ';
    }
  }
}

class HomePageLoaded extends HomePageState {
  final List<CurrencySummary> currencies;
  final List<TransactionModel> recentTransactions;

  HomePageLoaded({
    required this.currencies,
    required this.recentTransactions,
  });
}
