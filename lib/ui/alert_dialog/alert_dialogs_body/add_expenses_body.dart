import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_traffic_app/constans/app_constans.dart';
import 'package:money_traffic_app/init/lang/locale_keys.g.dart';
import 'package:money_traffic_app/services/local_data_base/entity/expenses.dart';
import 'package:money_traffic_app/ui/pages/main_page/bloc/expenses_bloc.dart';

class AddExpenesBody extends StatefulWidget {
  final ExpensesBloc expensesBloc;
  const AddExpenesBody({
    required this.expensesBloc,
    Key? key,
  }) : super(key: key);

  @override
  State<AddExpenesBody> createState() => _AddExpenesBodyState();
}

class _AddExpenesBodyState extends State<AddExpenesBody> {
  List<String> _listOfCommonValues = [];
  List<String> _listOfCommonCategory = [];

  final TextEditingController _controllerForExpans = TextEditingController();
  final TextEditingController _controllerForCategory = TextEditingController();

  String? errorTextValues;
  String? errorTextCategory;

  @override
  void didChangeDependencies() async {
    final _box = await Hive.openBox<String>(AppConst.commonValuesHiveBox);
    final _categoryBox =
        await Hive.openBox<String>(AppConst.commonCategoryHiveBox);

    _listOfCommonCategory = _categoryBox.values.toList().isEmpty
        ? AppConst.commonCategory
        : _categoryBox.values.toList();
    _listOfCommonValues = _box.values.toList().isEmpty
        ? AppConst.commonValues
        : _box.values.toList();

    setState(() {});

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _InputForm(
              error: errorTextValues,
              keyboardType: const TextInputType.numberWithOptions(),
              title: LocaleKeys.enterCosts.tr(),
              controller: _controllerForExpans,
              listOfCommonValues: _listOfCommonValues,
            ),
            const SizedBox(height: 30),
            _InputForm(
              error: errorTextCategory,
              keyboardType: TextInputType.text,
              isCategory: true,
              title: LocaleKeys.enterCatergory.tr(),
              controller: _controllerForCategory,
              listOfCommonValues: _listOfCommonCategory,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width, 0),
                  backgroundColor: Theme.of(context).indicatorColor,
                  foregroundColor: Theme.of(context).canvasColor,
                ),
                onPressed: () {
                  errorTextCategory = null;
                  errorTextValues = null;
                  if (_controllerForExpans.text.isNotEmpty &&
                      _controllerForCategory.text.isNotEmpty) {
                    widget.expensesBloc.add(
                      AddExpenses(
                        categpry: _controllerForCategory.text,
                        cost: int.parse(_controllerForExpans.text),
                      ),
                    );
                    widget.expensesBloc
                        .add(GetExpenses(date: DateTime(2023, 2, 4)));
                    Navigator.pop(context);
                  } else {
                    setState(() {
                      if (_controllerForCategory.text.isEmpty &&
                          _controllerForExpans.text.isNotEmpty) {
                        errorTextCategory = LocaleKeys.enterCatergory.tr();
                      } else if (_controllerForExpans.text.isEmpty &&
                          _controllerForCategory.text.isNotEmpty) {
                        errorTextValues = LocaleKeys.enterCosts.tr();
                      } else {
                        errorTextCategory = LocaleKeys.enterCatergory.tr();
                        errorTextValues = LocaleKeys.enterCosts.tr();
                      }
                    });
                  }
                },
                child: const Icon(Icons.done),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _InputForm extends StatefulWidget {
  final String? error;
  final TextInputType keyboardType;
  final bool isCategory;
  final String title;
  final TextEditingController controller;
  List<String> listOfCommonValues;

  _InputForm({
    this.error,
    required this.keyboardType,
    this.isCategory = false,
    required this.title,
    required this.listOfCommonValues,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  State<_InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<_InputForm> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title),
              IconButton(
                color: Theme.of(context).indicatorColor,
                icon: const Icon(Icons.edit_note_sharp),
                onPressed: () {
                  showDialog(
                    useRootNavigator: true,
                    context: context,
                    builder: (context) => AlertDialog(
                      content: SafeArea(
                        child: StatefulBuilder(
                          builder: (BuildContext context,
                                  void Function(void Function()) setState) =>
                              SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 50),
                                SizedBox(
                                  height: 100,
                                  child: ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(width: 10),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: widget.listOfCommonValues.length,
                                    itemBuilder: (context, index) => Stack(
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context)
                                                .indicatorColor,
                                            foregroundColor:
                                                Theme.of(context).canvasColor,
                                          ),
                                          onPressed: () {},
                                          child: Text(
                                            widget.listOfCommonValues[index],
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            onTap: () {
                                              setState(() {
                                                widget.listOfCommonValues
                                                    .removeAt(index);
                                              });
                                            },
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.black38),
                                                color:
                                                    Theme.of(context).cardColor,
                                              ),
                                              child: const Icon(
                                                Icons.remove,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  child: TextField(
                                    keyboardType: widget.isCategory
                                        ? TextInputType.text
                                        : const TextInputType
                                            .numberWithOptions(),
                                    autofocus: true,
                                    textAlign: TextAlign.center,
                                    controller: _controller,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).indicatorColor,
                                      foregroundColor:
                                          Theme.of(context).canvasColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        widget.listOfCommonValues
                                            .add(_controller.text);
                                        _controller.clear();
                                      });
                                    },
                                    child: const Icon(Icons.add)),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(
                                          MediaQuery.of(context).size.width,
                                          50),
                                      backgroundColor:
                                          Theme.of(context).indicatorColor,
                                      foregroundColor:
                                          Theme.of(context).canvasColor,
                                    ),
                                    onPressed: () async {
                                      Navigator.of(context).pop();

                                      final _box = widget.isCategory
                                          ? await Hive.openBox<String>(
                                              AppConst.commonCategoryHiveBox,
                                            )
                                          : await Hive.openBox<String>(
                                              AppConst.commonValuesHiveBox,
                                            );
                                      await _box.clear();
                                      for (var i = 0;
                                          i < widget.listOfCommonValues.length;
                                          i++) {
                                        _box.put(
                                          widget.listOfCommonValues[i],
                                          widget.listOfCommonValues[i],
                                        );
                                      }
                                    },
                                    child: const Icon(
                                      Icons.done_sharp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ).whenComplete(() => setState(() {}));
                },
              )
            ],
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                errorText: widget.error,
              ),
              textAlign: TextAlign.center,
              controller: widget.controller,
              keyboardType: widget.keyboardType,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: widget.listOfCommonValues.length,
              itemBuilder: (context, index) => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).indicatorColor,
                  foregroundColor: Theme.of(context).canvasColor,
                ),
                onPressed: () {
                  setState(() {
                    widget.controller.text = widget.listOfCommonValues[index];
                  });
                },
                child: Text(
                  widget.listOfCommonValues[index],
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(width: 20),
            ),
          ),
        ],
      ),
    );
  }
}
