import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:money_traffic_app/services/local_data_base/entity/expenses.dart';

part 'expenses_event.dart';
part 'expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  ExpensesBloc() : super(ExpensesInitial()) {
    on<AddExpenses>((event, emit) async {
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(ExpensesAdapter());
      }

      final _box = await Hive.openBox<Expenses>('expenses');
      _box.add(
        Expenses(
          category: event.categpry,
          cost: event.cost,
          date: DateTime.now(),
        ),
      );
    });

    on<GetExpenses>((event, emit) async {
      emit(ExpensesLoadingState());

      final List<Expenses>? listExpenses;
      int sum = 0;

      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(ExpensesAdapter());
      }

      final _box = await Hive.openBox<Expenses>('expenses');
      listExpenses = _box.values.toList();
      for (var i = 0; i < listExpenses.length; i++) {
        sum += listExpenses[i].cost;
      }
      print(sum);
      emit(ExpensesLoadedState(
        listExpenses: listExpenses,
        sum: sum,
      ));
    });
  }
}
