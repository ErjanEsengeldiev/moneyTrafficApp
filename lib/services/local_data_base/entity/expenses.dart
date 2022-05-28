import 'package:hive/hive.dart';

part 'expenses.g.dart';

@HiveType(typeId: 1)
class Expenses extends HiveObject {
  @HiveField(0)
  String category;
  @HiveField(1)
  int cost;
  @HiveField(2)
  DateTime date;
  Expenses({
    required this.date,
    required this.category,
    required this.cost,
  });
}
