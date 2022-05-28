import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_traffic_app/bloc/theme_bloc.dart';
import 'package:money_traffic_app/ui/alert_dialog/expenses_alert.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_traffic_app/ui/pages/main_page/bloc/expenses_bloc.dart';
import 'package:money_traffic_app/services/local_data_base/entity/expenses.dart';

import 'package:provider/src/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controllerForExpans = TextEditingController();
  final TextEditingController _controllerForCategory = TextEditingController();
  late ExpensesBloc _expensesBloc;
  List<Expenses> listExpenses = [];
  int sum = 0;

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
      controllerForExpans: _controllerForExpans,
      controllerForCategory: _controllerForCategory,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
          )
        ],
      ),
      body: BlocProvider(
        create: (context) => _expensesBloc,
        child: BlocConsumer<ExpensesBloc, ExpensesState>(
          listener: (context, state) {
            if (state is ExpensesLoadedState) {
              listExpenses = state.listExpenses;
              sum = state.sum;
            }
          },
          builder: (context, state) {
            return Center(
                child: Column(
              children: [
                Text('Сумма: $sum сом'),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: listExpenses.length,
                    itemBuilder: (context, index) => Card(
                          child: ListTile(
                            title: Text(
                                'Категория: ${listExpenses[index].category}'),
                            leading: Text('Цена: ${listExpenses[index].cost}'),
                            trailing:
                                Text('Дата: ${listExpenses[index].date.day}'),
                          ),
                        )),
              ],
            ));
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: _inputExpenses,
            tooltip: 'Increment',
            child: const Icon(Icons.delete),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _inputExpenses,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
