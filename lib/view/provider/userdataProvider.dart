import 'package:app/data/model/UserData.dart';
import 'package:app/data/repository/dbRepository.dart' as dbrepository;
import 'package:flutter/material.dart';

class Userdataprovider extends ChangeNotifier {
  Userdata user = dbrepository.getUser();

  void defaultUser() {
    user = dbrepository.getUser();
    notifyListeners();
  }

  void updateUserAmount(double amount) {
    user.balance = amount;
    notifyListeners();
  }
}