import 'package:expense_tracker_app_jhonny_mustafa/components/expense_summary.dart';
import 'package:expense_tracker_app_jhonny_mustafa/helpers/utils.dart';
import 'package:expense_tracker_app_jhonny_mustafa/models/expense_model.dart';
import 'package:expense_tracker_app_jhonny_mustafa/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  final editExpenseNameController = TextEditingController();
  final editExpenseAmountController = TextEditingController();

  final inputDecorName = InputDecoration(
    hintText: 'Name',
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.4),
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.blue,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.red,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.red,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.4),
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
  );

  final inputDecorAmount = InputDecoration(
    hintText: 'Amount',
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.4),
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.blue,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.red,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.red,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.4),
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
  );

  void addNewExpenseDialog() {
    //print('Open dialog');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add new expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newExpenseNameController,
              decoration: inputDecorName,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newExpenseAmountController,
              decoration: inputDecorAmount,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (newExpenseAmountController.text.isNotEmpty &&
                  newExpenseNameController.text.isNotEmpty) {
                //save();
                ExpenseModel newExpenseItem = ExpenseModel(
                  name: newExpenseNameController.text,
                  amount: newExpenseAmountController.text,
                  dateTime: DateTime.now(),
                );
                Provider.of<ExpenseProvider>(context, listen: false)
                    .addNewExpanse(newExpenseItem);
                //tutup dialog
                Navigator.pop(context);

                //bersihkan inputan
                newExpenseNameController.clear();
                newExpenseAmountController.clear();
              }
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () {
              //cancel();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void editExpenseDialog(String name, String amount) {
    print('Edit Dialog');

    editExpenseNameController.text = name;
    editExpenseAmountController.text = amount;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: editExpenseNameController,
              decoration: inputDecorName,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: editExpenseAmountController,
              decoration: inputDecorAmount,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (editExpenseAmountController.text.isNotEmpty &&
                  editExpenseAmountController.text.isNotEmpty) {
                //save();

                ExpenseModel newExpenseItem = ExpenseModel(
                  name: editExpenseNameController.text,
                  amount: editExpenseAmountController.text,
                  dateTime: DateTime.now(),
                );
                Provider.of<ExpenseProvider>(context, listen: false)
                    .updateExpanse(newExpenseItem, 0);

                //tutup dialog
                Navigator.pop(context);

                //bersihkan inputan
                editExpenseNameController.clear();
                editExpenseAmountController.clear();
              }
            },
            child: const Text('Update'),
          ),
          TextButton(
            onPressed: () {
              //cancel();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    Provider.of<ExpenseProvider>(context, listen: false).preparedata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(title: const Text('Expense Tracker')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Utils.idCurrencyFormatter(
                      Provider.of<ExpenseProvider>(context)
                          .getTotalAmountThisWeek()
                          .toDouble(),
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    Utils.getFormattedWeekRange(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ExpenseSummary(
              startOfWeek: value.startOfWeekDate(),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: SizedBox(
                child: ListView.builder(
                  itemCount: value.getallExpenseList().length,
                  itemBuilder: (context, index) {
                    return Slidable(
                      key: ValueKey(index),
                      endActionPane: ActionPane(
                        extentRatio: 0.4,
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            onPressed: (context) {
                              // delete expense list
                              Provider.of<ExpenseProvider>(context,
                                      listen: false)
                                  .removeNewExpanse(
                                value.overallExpenseList[index],
                              );
                            },
                          ),
                          SlidableAction(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            onPressed: //(context) {
                                // edit expense list
                                //Provider.of<ExpenseProvider>(context)
                                // Provider.of<ExpenseProvider>(context,
                                //         listen: false)
                                //     .updateExpanse(
                                //   value.overallExpenseList[index].name,
                                // );

                                //},

                                (context) {
                              editExpenseDialog(
                                //int.parse(
                                //    value.overallExpenseList[index].toString()),
                                value.overallExpenseList[index].name,
                                value.overallExpenseList[index].amount,
                              );
                            },
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(value.getallExpenseList()[index].name),
                        subtitle: Text(
                            '${value.getallExpenseList()[index].dateTime.day}/${value.getallExpenseList()[index].dateTime.month}/${value.getallExpenseList()[index].dateTime.year}'),
                        trailing: Text(
                          Utils.idCurrencyFormatter(
                            double.parse(
                                value.getallExpenseList()[index].amount),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          //value.getallExpenseList()[index].amount,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
          onPressed: addNewExpenseDialog,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      );
    });
  }
}
