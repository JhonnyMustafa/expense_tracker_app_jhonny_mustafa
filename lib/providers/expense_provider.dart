import 'package:expense_tracker_app_jhonny_mustafa/helpers/utils.dart';
import 'package:expense_tracker_app_jhonny_mustafa/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app_jhonny_mustafa/database/hive_database.dart';

class ExpenseProvider extends ChangeNotifier {
  List<ExpenseModel> overallExpenseList = [];
  List<ExpenseModel> getallExpenseList() {
    return overallExpenseList;
  }

  final db = HiveDatabase();
  void preparedata() {
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

  //add expense
  void addNewExpanse(ExpenseModel newExpenseItem) {
    overallExpenseList.add(newExpenseItem);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //update expense
  void updateExpanse(ExpenseModel newExpenseItem, int index) {
    print('Update expanse');
    overallExpenseList.indexOf(newExpenseItem, index);

    overallExpenseList[index] = newExpenseItem;

    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //delete expense
  void removeNewExpanse(ExpenseModel expenseItem) {
    overallExpenseList.remove(expenseItem);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //get weekday
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thr';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return 'Invalid day';
    }
  }

  //get start of week
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    //get today date
    DateTime today = DateTime.now();

    // go backwards from today to find sunday
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }

    return startOfWeek!;
  }

  //calculate get total amount this week
  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {
      // date (yyyymmdd) : amountTotalForDay
    };

    for (var expense in overallExpenseList) {
      String date = Utils.convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }

    return dailyExpenseSummary;
  }

  double getTotalAmountThisWeek() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    double totalAmount = 0.0;
    for (ExpenseModel expense in overallExpenseList) {
      if (expense.dateTime.isAfter(startOfWeek) &&
          expense.dateTime.isBefore(endOfWeek)) {
        totalAmount += double.parse(expense.amount);
      }
    }

    return totalAmount;
  }
}
