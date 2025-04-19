import 'package:hive/hive.dart';

part 'UserData.g.dart';

@HiveType(typeId: 3)
class Userdata {
  @HiveField(0)
  String userName;
  @HiveField(1)
  String password;
  @HiveField(2)
  double balance;
  @HiveField(3)
  final bool deviceAuth;
  @HiveField(4)
  final bool notifications;
  @HiveField(5)
  final bool defaultTheme;
  @HiveField(6)
  String? profileImagePath;

  Userdata(
      this.userName,
      this.balance,
      this.deviceAuth,
      this.notifications,
      this.password,
      this.defaultTheme, {
        this.profileImagePath,
      });
}
