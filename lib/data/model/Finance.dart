// ignore_for_file: file_names
import 'package:hive/hive.dart';
part 'Finance.g.dart';

@HiveType(typeId: 1)
class Finance {
  @HiveField(0)
  final String account;
  @HiveField(1)
  final String user;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final String desc;
  @HiveField(4)
  final String trancType;
  @HiveField(5)
  final String trancCategory;
  @HiveField(6)
  final double amount;

  Finance(this.account, this.user, this.date, this.desc, this.trancType,
      this.trancCategory, this.amount);
}