import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:money_traffic_app/init/lang/locale_keys.g.dart';

class AppConst {
  static const String commonValuesHiveBox = 'commonValues';
  static const String commonCategoryHiveBox = 'commonCategory';
  static const String expensesHiveBox = 'expenses';

  static List<String> commonValues = [
    '15',
    '10',
    '5',
  ];
  static List<String> commonCategory = [
    LocaleKeys.food.tr(),
    LocaleKeys.transport.tr(),
  ];
}
