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
  bool deviceAuth;

  @HiveField(4)
  bool notifications;

  @HiveField(5)
  bool defaultTheme;

  @HiveField(6)
  String? profileImagePath;

  Userdata(
      this.userName,
      this.password,
      this.balance,
      this.deviceAuth,
      this.notifications,
      this.defaultTheme, {
        this.profileImagePath,
      });
}
