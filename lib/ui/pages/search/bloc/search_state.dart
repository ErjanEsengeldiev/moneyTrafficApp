part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchingState extends SearchState {
  final List<Expenses> listExpenses;
  final int sum;
  SearchingState({
    required this.listExpenses,
    required this.sum,
  });
}
