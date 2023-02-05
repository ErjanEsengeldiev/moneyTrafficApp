import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_traffic_app/constans/app_constans.dart';
import 'package:money_traffic_app/init/lang/locale_keys.g.dart';
import 'package:money_traffic_app/services/local_data_base/entity/expenses.dart';
import 'package:money_traffic_app/ui/alert_dialog/alert_dialogs_body/add_expenses_body.dart';
import 'package:money_traffic_app/ui/pages/main_page/bloc/expenses_bloc.dart';

class CustomAlertDialog {
  static expensesAlertDialog({
    required ExpensesBloc expensesBloc,
    required BuildContext context,
  }) async {
    showDialog(
      context: context,
      builder: (context) {
        return AddExpenesBody(expensesBloc: expensesBloc);
      },
    );
  }

  static deleteExpensesDialog(
    BuildContext context, {
    required int index,
    required ExpensesBloc expensesBloc,
  }) {
    showModalBottomSheet(
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final _box =
                  await Hive.openBox<Expenses>(AppConst.expensesHiveBox);
              await _box.deleteAt(index);
              expensesBloc.add(GetExpenses(date: DateTime(2023, 2, 4)));
              Navigator.pop(context);
            },
            child: Text(LocaleKeys.delete.tr()),
          ),
          const SizedBox(height: 100, width: 40),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            child: Text(LocaleKeys.close.tr()),
          ),
        ],
      ),
      backgroundColor: Colors.grey,
    );
  }
}
