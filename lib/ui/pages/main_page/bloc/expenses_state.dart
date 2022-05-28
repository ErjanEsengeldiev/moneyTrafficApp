part of 'expenses_bloc.dart';

@immutable
abstract class ExpensesState {}

class ExpensesInitial extends ExpensesState {}

class ExpensesLoadedState extends ExpensesState {
  final int sum;
  final List<Expenses> listExpenses;

  ExpensesLoadedState({
    required this.sum,
    required this.listExpenses,
  });
}

class ExpensesLoadingState extends ExpensesState {}
