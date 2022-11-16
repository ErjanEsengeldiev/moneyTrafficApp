import 'package:flutter/material.dart';
import 'package:money_traffic_app/ui/pages/main_page/bloc/expenses_bloc.dart';

class CustomAlertDialog {
  static expensesAlertDialog({
    required ExpensesBloc expensesBloc,
    required BuildContext context,
  }) {
    List<String> _listOfCommonValues = ['15', '11', '50'];
    final TextEditingController _controllerForExpans = TextEditingController();
    final TextEditingController _controllerForCategory =
        TextEditingController();

    List<String> _listOfCommonCategory = ['Транспорт', 'Еда', 'Личный быт'];

    String? errorTextValues = null;
    String? errorTextCategory = null;

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _InputForm(
                      error: errorTextValues,
                      keyboardType: const TextInputType.numberWithOptions(),
                      title: 'Введите затраты',
                      controller: _controllerForExpans,
                      listOfCommonValues: _listOfCommonValues,
                    ),
                    const SizedBox(height: 30),
                    _InputForm(
                      error: errorTextCategory,
                      keyboardType: TextInputType.text,
                      isCategory: true,
                      title: 'Укажите категорию',
                      controller: _controllerForCategory,
                      listOfCommonValues: _listOfCommonCategory,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize:
                                Size(MediaQuery.of(context).size.width, 0)),
                        onPressed: () {
                          errorTextCategory = null;
                          errorTextValues = null;
                          if (_controllerForExpans.text.isNotEmpty &&
                              _controllerForCategory.text.isNotEmpty) {
                            expensesBloc.add(
                              AddExpenses(
                                categpry: _controllerForCategory.text,
                                cost: int.parse(_controllerForExpans.text),
                              ),
                            );
                            expensesBloc.add(GetExpenses());
                            Navigator.pop(context);
                          } else {
                            setState(() {
                              if (_controllerForCategory.text.isEmpty &&
                                  _controllerForExpans.text.isNotEmpty) {
                                errorTextCategory = 'Напишите категорию';
                              } else if (_controllerForExpans.text.isEmpty &&
                                  _controllerForCategory.text.isNotEmpty) {
                                errorTextValues = 'Напишите сумму';
                              } else {
                                errorTextCategory = 'Напишите категорию';
                                errorTextValues = 'Напишите сумму';
                              }
                            });
                          }
                        },
                        child: const Text('ok'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class _InputForm extends StatefulWidget {
  final String? error;
  final TextInputType keyboardType;
  final bool isCategory;
  final String title;
  final TextEditingController controller;
  final List<String> listOfCommonValues;

  const _InputForm({
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
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(widget.title),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(errorText: widget.error),
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
                onPressed: () {
                  setState(() {
                    widget.controller.text = widget.listOfCommonValues[index];
                  });
                },
                child: Text(
                  '${widget.listOfCommonValues[index]} ${widget.isCategory ? '' : 'СОМ'} ',
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
