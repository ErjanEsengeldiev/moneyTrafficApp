import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:money_traffic_app/services/local_data_base/entity/expenses.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final List<Expenses> listExpenses;
  SearchBloc({required this.listExpenses}) : super(SearchInitial()) {
    on<SearchingEvent>((event, emit) {
      final List<Expenses> sortedListExpenses = [];
      int sum = 0;
      for (var element in listExpenses) {
        element.category.toLowerCase().contains(event.value.toLowerCase())
            ? sortedListExpenses.add(element)
            : () {};
      }

      emit(SearchingState(listExpenses: sortedListExpenses, sum: sum));
    });
  }
}
