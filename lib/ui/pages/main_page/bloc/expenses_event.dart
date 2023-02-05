part of 'expenses_bloc.dart';

@immutable
abstract class ExpensesEvent {}

class AddExpenses extends ExpensesEvent {
  final String categpry;
  final int cost;

  AddExpenses({
    required this.categpry,
    required this.cost,
  });
}

class GetExpenses extends ExpensesEvent {
  final DateTime date;

  GetExpenses({required this.date});
}
