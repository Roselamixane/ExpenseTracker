// ignore_for_file: file_names, non_constant_identifier_names
import 'package:hive/hive.dart';
part 'Budget.g.dart';

@HiveType(typeId: 2)
class Budget {
  @HiveField(0)
  final String user;
  @HiveField(1)
  final String trancCategory;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final double Budget_amount;
  @HiveField(4)
  final String duration;

  Budget(this.user, this.date, this.trancCategory, this.duration,
      this.Budget_amount);
}
