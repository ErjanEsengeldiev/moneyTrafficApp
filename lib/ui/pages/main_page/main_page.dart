import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_traffic_app/bloc/theme_bloc.dart';
import 'package:money_traffic_app/ui/alert_dialog/expenses_alert.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_traffic_app/ui/pages/main_page/bloc/expenses_bloc.dart';
import 'package:money_traffic_app/services/local_data_base/entity/expenses.dart';
import 'package:money_traffic_app/ui/pages/search/search_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ExpensesBloc _expensesBloc;
  List<Expenses> listExpenses = [];
  List<Expenses> listExpensesForFood = [];
  List<Expenses> listExpensesForTransport = [];
  int sum = 0;
  int sumForFood = 0;
  int sumForTransport = 0;

  @override
  void initState() {
    _expensesBloc = ExpensesBloc();
    _expensesBloc.add(GetExpenses());
    super.initState();
  }

  void _inputExpenses() {
    CustomAlertDialog.expensesAlertDialog(
      expensesBloc: _expensesBloc,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Text('все')),
              Tab(icon: Icon(Icons.fastfood)),
              Tab(icon: Icon(Icons.bus_alert_rounded)),
            ],
          ),
          title: TextButton(
            onPressed: () {},
            child: Text(
              '${DateTime.now().year}.${DateTime.now().month}.${DateTime.now().day}',
              style: TextStyle(
                  fontSize: 30,
                  color: Theme.of(context).buttonTheme.colorScheme!.onPrimary),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Hive.box('theme').get('theme') == 'dark'
                    ? context
                        .read<ThemeBloc>()
                        .add(ChangeThemeEvent(theme: 'light'))
                    : context
                        .read<ThemeBloc>()
                        .add(ChangeThemeEvent(theme: 'dark'));
              },
              icon: const Icon(Icons.mode_night_outlined),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SearchPage(
                          listExpenses: listExpenses,
                        )));
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        body: BlocProvider(
          create: (context) => _expensesBloc,
          child: BlocConsumer<ExpensesBloc, ExpensesState>(
            listener: (context, state) {
              listExpensesForFood.clear();
              listExpensesForTransport.clear();

              if (state is ExpensesLoadedState) {
                listExpenses = state.listExpenses;
                for (var e in listExpenses) {
                  sumForFood = state.sum;
                  e.category == 'Еда' ? listExpensesForFood.add(e) : () {};
                  for (var element in listExpensesForFood) {
                    sum += element.cost;
                  }
                }
                for (var e in listExpenses) {
                  sumForTransport = state.sum;

                  e.category == 'Транспорт'
                      ? listExpensesForTransport.add(e)
                      : () {};
                }

                sum = state.sum;
              }
            },
            builder: (context, state) {
              return TabBarView(
                children: [
                  _CustomListView(
                    expensesBloc: _expensesBloc,
                    sum: sum,
                    listExpenses: listExpenses,
                  ),
                  _CustomListView(
                    expensesBloc: _expensesBloc,
                    sum: sumForFood,
                    listExpenses: listExpensesForFood,
                  ),
                  _CustomListView(
                    expensesBloc: _expensesBloc,
                    sum: sumForTransport,
                    listExpenses: listExpensesForTransport,
                  ),
                ],
              );
            },
          ),
        ),
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 10),
            FloatingActionButton(
              heroTag: 'add',
              onPressed: _inputExpenses,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomListView extends StatelessWidget {
  final ExpensesBloc expensesBloc;
  const _CustomListView({
    Key? key,
    required this.expensesBloc,
    required this.sum,
    required this.listExpenses,
  }) : super(key: key);

  final int sum;
  final List<Expenses> listExpenses;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Text('Сумма: $sum сом'),
        ListView.builder(
            shrinkWrap: true,
            reverse: true,
            itemCount: listExpenses.length,
            itemBuilder: (context, index) => InkWell(
                  onLongPress: () async {
                    Scaffold.of(context).showBottomSheet(
                      (context) => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              final _box =
                                  await Hive.openBox<Expenses>('expenses');
                              await _box.deleteAt(index);
                              expensesBloc.add(GetExpenses());
                              Navigator.pop(context);
                            },
                            child: const Text('Удалить'),
                          ),
                          const SizedBox(height: 100, width: 40),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: const Text('Отменить'),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.grey,
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text('Категория: ${listExpenses[index].category}'),
                      leading: Text('Цена: ${listExpenses[index].cost}'),
                      trailing: Text(
                          'Дата: ${listExpenses[index].date.year}.${listExpenses[index].date.month}.${listExpenses[index].date.day}'),
                    ),
                  ),
                )),
      ],
    ));
  }
}
