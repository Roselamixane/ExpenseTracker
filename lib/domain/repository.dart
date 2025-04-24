// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings

import 'dart:io';

import 'package:app/data/model/Finance.dart';
import 'package:app/data/repository/dbRepository.dart' as dbrepository;
import 'package:app/utils/collections.dart' as collections;
import 'package:app/view/provider/summaryProvider.dart';
import 'package:app/view/provider/transactionProvider.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

List<String> formatDate(DateTime datetime) {
  String date = DateFormat.d().format(datetime);
  String monthName = DateFormat.MMMM().format(datetime);
  String year = DateFormat.y().format(datetime);
  List<String> datemonth = [date, monthName, year];
  return datemonth;
}

String formatAmount(double amount) {
  final formatter = NumberFormat.currency(locale: 'hi_IN', symbol: '₹');
  String value = formatter.format(amount);
  return value;
}

IconData iconForCategory(String Transcategory) {
  int idx = 0;
  idx = collections.Categories.indexOf(Transcategory);
  if (idx == -1) {
    idx = 0;
  }
  return collections.Icon[idx];
}

String findCategory(String desc) {
  String category = "Others";
  for (int i = 0; i < collections.categoriesAndKeywords.length; i++) {
    for (int j = 1; j < collections.categoriesAndKeywords[i].length; j++) {
      if (desc.toLowerCase().contains(
          collections.categoriesAndKeywords[i][j].toString().toLowerCase())) {
        category = collections.categoriesAndKeywords[i][0];
        break;
      }
    }
  }
  return category;
}

List<double> getAmount(List<Finance> Records) {
  double income = 0;
  double expense = 0;
  for (int i = 0; i < Records.length; i++) {
    if (Records[i].amount >= 0) {
      income = income + Records[i].amount;
    } else {
      expense = expense + Records[i].amount;
    }
  }
  List<double> val = [];
  val.add(income);
  val.add(expense);

  return val;
}

double getAmountByCategory(List<Finance> Records, String Catergory) {
  double amount = 0;
  List<Finance> CategoryRecords =
  Records.where((element) => element.trancCategory == Catergory).toList();
  for (int i = 0; i < CategoryRecords.length; i++) {
    amount = amount + CategoryRecords[i].amount;
  }
  return amount;
}

double getamtforBudget(DateTime date, String category, String duration) {
  double amount = 0;
  if (duration == "Yearly") {
    amount = getAmountByCategory(
        dbrepository
            .getRecords()
            .where(
                (element) => formatDate(element.date)[2] == formatDate(date)[2])
            .toList(),
        category);
  }
  if (duration == "Monthly") {
    amount = getAmountByCategory(
        dbrepository
            .getRecords()
            .where((element) =>
        formatDate(element.date)[1] == formatDate(date)[1] &&
            formatDate(element.date)[2] == formatDate(date)[2])
            .toList(),
        category);
  }
  return amount;
}

Map<int, List<double>> getAmountByDate(List<Finance> records) {
  Map<int, double> dailySumsPos = {};
  Map<int, double> dailySumsNeg = {};
  for (var finance in records) {
    int day = finance.date.day;
    if (!dailySumsPos.containsKey(day)) {
      dailySumsPos[day] = 0;
    }
    if (!dailySumsNeg.containsKey(day)) {
      dailySumsNeg[day] = 0;
    }
    finance.amount > 0
        ? dailySumsPos[day] = dailySumsPos[day]! + finance.amount
        : dailySumsNeg[day] = dailySumsNeg[day]! + finance.amount;
  }
  List<double> amountPos = List<double>.filled(31, 0);
  List<double> amountNeg = List<double>.filled(31, 0);

  dailySumsPos.forEach((day, sum) {
    amountPos[day - 1] = sum;
  });
  dailySumsNeg.forEach((day, sum) {
    amountNeg[day - 1] = sum;
  });

  Map<int, List<double>> amount = {0: amountPos, 1: amountNeg};

  return amount;
}

Map<int, List<double>> getAmountByMonth(List<Finance> records) {
  Map<int, double> monthlySumsPos = {};
  Map<int, double> monthlySumsNeg = {};
  for (var finance in records) {
    int month = finance.date.month;
    if (!monthlySumsPos.containsKey(month)) {
      monthlySumsPos[month] = 0;
    }
    if (!monthlySumsNeg.containsKey(month)) {
      monthlySumsNeg[month] = 0;
    }
    finance.amount > 0
        ? monthlySumsPos[month] = monthlySumsPos[month]! + finance.amount
        : monthlySumsNeg[month] = monthlySumsNeg[month]! + finance.amount;
  }
  List<double> amountPos = List<double>.filled(12, 0);
  List<double> amountNeg = List<double>.filled(12, 0);

  monthlySumsPos.forEach((month, sum) {
    amountPos[month - 1] = sum;
  });
  monthlySumsNeg.forEach((month, sum) {
    amountNeg[month - 1] = sum;
  });

  Map<int, List<double>> amount = {0: amountPos, 1: amountNeg};

  return amount;
}

List<String> getYearList(List<Finance> records) {
  List<String> yearList = [];
  if (records.isNotEmpty) {
    records.sort((a, b) => a.date.compareTo(b.date));
    int startYear = int.parse(formatDate(records.first.date)[2]);
    int endYear = int.parse(formatDate(records.last.date)[2]);
    for (int i = startYear; i <= endYear; i++) {
      yearList.add(i.toString());
    }
  }
  return yearList.reversed.toList();
}

bool checkIfExist(Finance rec) {
  if (dbrepository.getRecord(rec.desc).amount == 0.00) {
    return false;
  }
  return true;
}

void action(summaryProvider provider, transactionProvider tprovider) {
  provider.updateValues(0, 0);
  provider.updateRecords();
  tprovider.updateRecords(0, 0);
}

String getCategoryFromDesc(String desc) {
  if (desc.contains("/") && desc.split("/").length > 3) {
    desc = desc.split("/")[3];
    List<Finance> Records = dbrepository
        .getRecords()
        .where((rec) => rec.desc.contains(desc))
        .toList();
    var categories = <String, int>{};
    Records.forEach((element) {
      String category = element.trancCategory;
      categories[category] = (categories[category] ?? 0) + 1;
    });
    String maxcategory = "Others";
    int count = 0;
    categories.forEach((element, cnt) {
      if (cnt > count) {
        maxcategory = element;
        count = cnt;
      }
    });

    return maxcategory;
  } else {
    return "Others";
  }
}

//////////==========>>>>>>>>>> Message Reading <<<<<<<<<<==========//////////

Future addRecordFromMsg(
    summaryProvider provider, transactionProvider tprovider) async {
  try {
    const smsChannel = MethodChannel("smsPlatform");
    final List<Object?> result = await smsChannel.invokeMethod('readAllSms');

    for (int i = 0; i < result.length; i++) {
      if (result[i].toString().toLowerCase().contains("axisbk")) {
        if (result[i].toString().contains("Debit") &&
            result[i].toString().contains("INR")) {
          String str = result[i].toString().split("Message: ")[1];

          List<String> ls = str.split("\n");

          double amt = double.parse(ls[1].split(" ")[1]) * -1;

          DateFormat format = DateFormat("dd-MM-yy");

          String dt = ls[3].toString();
          DateTime date = format.parse(dt);

          String desc = ls[4];

          String trancCategory = findCategory(desc);

          var finance =
          Finance(" ", " ", date, desc, "Expense", trancCategory, amt);

          if (!checkIfExist(finance)) {
            dbrepository.addRecord(finance);
          }
        } else if (result[i].toString().contains("debited") &&
            result[i].toString().contains("INR") &&
            !result[i].toString().contains("requested") &&
            !result[i].toString().contains("debited from Axis")) {
          String str = result[i].toString().split("Message: ")[1];

          List<String> ls = str.split("\n");

          double amt = double.parse(ls[0].split(" ")[1]) * -1;

          DateFormat format = DateFormat("dd-MM-yy");

          String dt = ls[2].toString();
          dt = dt.split(",")[0];
          DateTime date = format.parse(dt);

          String desc = ls[3];

          String trancCategory = findCategory(desc);

          var finance =
          Finance(" ", " ", date, desc, "Expense", trancCategory, amt);

          if (!checkIfExist(finance)) {
            dbrepository.addRecord(finance);
          }
        } else if (result[i].toString().contains("debited") &&
            result[i].toString().contains("INR") &&
            !result[i].toString().contains("requested") &&
            result[i].toString().contains("debited from Axis")) {
          String str = result[i].toString().split("Message: ")[1];
          List<String> ls = str.split(" ");

          String dt = ls[10] + " " + ls[11];
          DateFormat format = DateFormat("dd-MM-yy");
          DateTime date = format.parse(dt);

          double amount = double.parse(ls[1]) * -1;
          String desc =
          ls.sublist(10).toString().replaceAll("[", "").replaceAll("]", "");

          String trancCategory = findCategory(desc);

          var finance =
          Finance(" ", " ", date, desc, "Income", trancCategory, amount);
          if (!checkIfExist(finance)) {
            dbrepository.addRecord(finance);
          }
        } else if (result[i].toString().contains("credited") &&
            result[i].toString().contains("INR") &&
            !result[i].toString().contains("to A/c no.")) {
          String str = result[i].toString().split("Message: ")[1];

          List<String> ls = str.split("\n");

          double amt = double.parse(ls[0].split(" ")[1]);

          DateFormat format = DateFormat("dd-MM-yy");

          String dt = ls[2].toString();
          dt = dt.split(",")[0];
          DateTime date = format.parse(dt);

          String desc = ls[3];

          String trancCategory = findCategory(desc);

          var finance =
          Finance(" ", " ", date, desc, "Expense", trancCategory, amt);

          if (!checkIfExist(finance)) {
            dbrepository.addRecord(finance);
          }
        } else if (result[i].toString().contains("credited") &&
            result[i].toString().contains("INR") &&
            result[i].toString().contains("to A/c no.")) {
          String str = result[i].toString().split("Message: ")[1];
          List<String> ls = str.split(" ");

          String dt = ls[8] + " " + ls[10];
          DateFormat format = DateFormat("dd-MM-yy");
          DateTime date = format.parse(dt);

          double amount = double.parse(ls[1]);
          String desc = ls[13];

          String trancCategory = findCategory(desc);

          var finance =
          Finance(" ", " ", date, desc, "Income", trancCategory, amount);
          if (!checkIfExist(finance)) {
            dbrepository.addRecord(finance);
          }
        }
        action(provider, tprovider);
      }
    }
  } on PlatformException catch (e) {
    print(
        "----------------->Internal Error<----------------------: $e.message");
  }
}

//////////==========>>>>>>>>>> File Selection <<<<<<<<<<==========//////////

Future<String?> pickXLSXFile() async {
  final result = await FilePicker.platform
      .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
  if (result != null) {
    return result.files.single.path;
  }
  return null;
}

List<List<dynamic>> parseXLSXFile(String filePath) {
  final bytes = File(filePath).readAsBytesSync();
  final excel = Excel.decodeBytes(bytes);

  final sheet = excel.sheets['Sheet 1'];
  final rows = sheet!.rows;

  return rows
      .map((row) => row.map((cell) => cell?.value.toString()).toList())
      .toList();
}