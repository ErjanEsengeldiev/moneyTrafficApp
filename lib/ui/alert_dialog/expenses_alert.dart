import 'package:flutter/material.dart';
import 'package:money_traffic_app/ui/pages/main_page/bloc/expenses_bloc.dart';
import 'package:provider/src/provider.dart';

class CustomAlertDialog {
  static expensesAlertDialog({
    required ExpensesBloc expensesBloc,
    required BuildContext context,
    required TextEditingController controllerForExpans,
    required TextEditingController controllerForCategory,
  }) {
    List<String> _listOfCommonValues = ['15', '11', '50'];

    List<String> _listOfCommonCategory = ['Транспорт', 'Еда', 'Личный быт'];

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
                      keyboardType: const TextInputType.numberWithOptions(),
                      title: 'Введите затраты',
                      controller: controllerForExpans,
                      listOfCommonValues: _listOfCommonValues,
                    ),
                    const SizedBox(height: 30),
                    _InputForm(
                      keyboardType: TextInputType.text,
                      isCategory: true,
                      title: 'Укажите категорию',
                      controller: controllerForCategory,
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
                          
                          expensesBloc.add(
                            AddExpenses(
                              categpry: controllerForCategory.text,
                              cost: int.parse(controllerForExpans.text),
                            ),
                          );
                          expensesBloc.add(GetExpenses());
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
  final TextInputType keyboardType;
  final bool isCategory;
  final String title;
  final TextEditingController controller;
  final List<String> listOfCommonValues;

  const _InputForm({
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
            child: TextField(
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
