import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_traffic_app/init/lang/locale_keys.g.dart';
import 'package:money_traffic_app/services/local_data_base/entity/expenses.dart';
import 'package:money_traffic_app/ui/pages/search/bloc/search_bloc.dart';

class SearchPage extends StatefulWidget {
  final List<Expenses> listExpenses;

  const SearchPage({
    Key? key,
    required this.listExpenses,
  }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late SearchBloc searchBloc;
  late List<Expenses> listExpenses;

  @override
  void initState() {
    listExpenses = widget.listExpenses;
    searchBloc = SearchBloc(listExpenses: widget.listExpenses);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: TextField(
              onChanged: (value) {
                searchBloc.add(SearchingEvent(value: value));
              },
              autofocus: true,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixIcon: const Icon(Icons.search),
                hintText: LocaleKeys.search.tr(),
              ),
            ),
          ),
          BlocConsumer<SearchBloc, SearchState>(
            bloc: searchBloc,
            listener: (context, state) {
              if (state is SearchingState) {
                listExpenses = state.listExpenses;
              }
            },
            builder: (context, state) => Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listExpenses.length,
                itemBuilder: (context, index) => Card(
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
          )
        ],
      ),
    );
  }
}
