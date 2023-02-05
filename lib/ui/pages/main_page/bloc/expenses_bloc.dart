import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:money_traffic_app/constans/app_constans.dart';
import 'package:money_traffic_app/services/local_data_base/entity/expenses.dart';

part 'expenses_event.dart';
part 'expenses_state.dart';

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  ExpensesBloc() : super(ExpensesInitial()) {
    on<AddExpenses>((event, emit) async {
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(ExpensesAdapter());
      }

      final _box = await Hive.openBox<Expenses>(AppConst.expensesHiveBox);
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

      final _box = await Hive.openBox<Expenses>(AppConst.expensesHiveBox);

      listExpenses = _box.values
          .where((element) => element.date.isSameDate(event.date))
          .toList();

      for (var i = 0; i < listExpenses.length; i++) {
        sum += listExpenses[i].cost;
      }
      emit(ExpensesLoadedState(
        date: event.date,
        listExpenses: listExpenses,
        sum: sum,
      ));
    });
  }
}
