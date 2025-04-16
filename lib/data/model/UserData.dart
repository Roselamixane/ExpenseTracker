import 'package:hive/hive.dart';

part 'UserData.g.dart';

@HiveType(typeId: 3)
class Userdata {
  @HiveField(0)
  final String userName;
  @HiveField(1)
  final String password;
  @HiveField(2)
  double balance;
  @HiveField(3)
  final bool deviceAuth;
  @HiveField(4)
  final bool notifications;
  @HiveField(5)
  final bool defaultTheme;

  Userdata(this.userName, this.balance, this.deviceAuth, this.notifications,
      this.password, this.defaultTheme);
}
