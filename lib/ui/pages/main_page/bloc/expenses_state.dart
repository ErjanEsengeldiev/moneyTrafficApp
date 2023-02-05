part of 'expenses_bloc.dart';

@immutable
abstract class ExpensesState {}

class ExpensesInitial extends ExpensesState {}

class ExpensesLoadedState extends ExpensesState {
  final int sum;
  final List<Expenses> listExpenses;
  final DateTime date;

  ExpensesLoadedState({
    required this.sum,
    required this.listExpenses,
    required this.date,
  });
}

class ExpensesLoadingState extends ExpensesState {}
