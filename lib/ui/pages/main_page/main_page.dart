import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';
import 'package:money_traffic_app/bloc/theme_bloc.dart';
import 'package:money_traffic_app/init/lang/locale_keys.g.dart';
import 'package:money_traffic_app/services/local_data_base/entity/expenses.dart';
import 'package:money_traffic_app/ui/alert_dialog/expenses_alert.dart';
import 'package:money_traffic_app/ui/pages/main_page/bloc/expenses_bloc.dart';
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
    _expensesBloc.add(GetExpenses(date: DateTime.now()));
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
              Tab(icon: Icon(Icons.show_chart_sharp)),
              Tab(icon: Icon(Icons.fastfood)),
              Tab(icon: Icon(Icons.bus_alert_rounded)),
            ],
          ),
          title: BlocBuilder<ExpensesBloc, ExpensesState>(
            bloc: _expensesBloc,
            builder: (context, state) {
              if (state is ExpensesLoadedState) {
                return TextButton(
                  onPressed: () async {
                    DateTime selectedDate = DateTime.now();
                    final DateTime? dateFromPicker = await showDatePicker(
                      context: context,
                      initialDate: state.date,
                      firstDate: DateTime(2023, 0),
                      lastDate: DateTime.now(),
                    );
                    selectedDate = dateFromPicker ?? DateTime.now();

                    _expensesBloc.add(GetExpenses(date: selectedDate));
                  },
                  child: Row(
                    children: [
                      Text(
                        '${state.date.year}.${state.date.month}.${state.date.day}',
                        style: TextStyle(
                          fontSize: 30,
                          color: Theme.of(context)
                              .buttonTheme
                              .colorScheme!
                              .onBackground,
                        ),
                      ),
                      Transform.rotate(
                        angle: pi / -2,
                        child: Icon(
                          Icons.chevron_left,
                          size: 35,
                          color: Theme.of(context)
                              .buttonTheme
                              .colorScheme!
                              .onBackground,
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
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
              onPressed: () async {
                switch (EasyLocalization.of(context)?.locale.languageCode) {
                  case 'ru':
                    await EasyLocalization.of(context)?.setLocale(
                        const Locale.fromSubtags(languageCode: 'en'));
                    break;
                  case 'en':
                    await EasyLocalization.of(context)?.setLocale(
                        const Locale.fromSubtags(languageCode: 'ky'));
                    break;
                  case 'ky':
                    await EasyLocalization.of(context)?.setLocale(
                        const Locale.fromSubtags(languageCode: 'ru'));
                    break;
                }
              },
              icon: Text(
                EasyLocalization.of(context)
                        ?.locale
                        .languageCode
                        .toUpperCase() ??
                    '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SearchPage(
                      listExpenses: listExpenses,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        body: BlocProvider(
          create: (context) => _expensesBloc,
          child: BlocConsumer<ExpensesBloc, ExpensesState>(
            listener: (context, state) {
              listExpenses.clear();
              listExpensesForFood.clear();
              listExpensesForTransport.clear();

              sum = 0;
              sumForFood = 0;
              sumForTransport = 0;

              if (state is ExpensesLoadedState) {
                listExpenses = state.listExpenses;
                for (var e in listExpenses) {
                  if (e.category == 'Еда') {
                    listExpensesForFood.add(e);
                    sumForFood += e.cost;
                  } else if (e.category == 'Транспорт') {
                    listExpensesForTransport.add(e);
                    sumForTransport += e.cost;
                  }
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
  final int sum;

  final List<Expenses> listExpenses;
  const _CustomListView({
    Key? key,
    required this.expensesBloc,
    required this.sum,
    required this.listExpenses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: Text(
              '${LocaleKeys.sum.tr()}: $sum',
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: listExpenses.length,
            itemBuilder: (context, index) => InkWell(
              onLongPress: () async {
                CustomAlertDialog.deleteExpensesDialog(
                  context,
                  expensesBloc: expensesBloc,
                  index: index,
                );
              },
              child: Card(
                child: ListTile(
                  title: Text(
                      '${LocaleKeys.category.tr()}: ${listExpenses[index].category}'),
                  leading: Text(
                      '${LocaleKeys.price.tr()}: ${listExpenses[index].cost}'),
                  trailing: Text(
                      '${LocaleKeys.date.tr()}: ${listExpenses[index].date.year}.${listExpenses[index].date.month}.${listExpenses[index].date.day}'),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
