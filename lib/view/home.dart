import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/conroller/cubit.dart';
import 'package:to_do_app/conroller/cubit_states.dart';
import 'package:to_do_app/view/archieved_tasks.dart';
import 'package:to_do_app/view/done_tasks.dart';
import 'package:to_do_app/view/new_tasks.dart';

import 'constant.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var scafoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, AppStates state) {
          if (state is AppinsertDatabase) {
            Navigator.pop(context);
          }
        },
        builder: (context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 225, 226, 226),
            key: scafoldKey,
            floatingActionButton: FloatingActionButton(
              child: cubit.fabIcon,
              onPressed: () {
                if (cubit.bottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                    // insertToDatabase(
                    //   date: dateController.text,
                    //   time: timeController.text,
                    //   title: titleController.text,
                    // ).then((value) {
                    //   getData(database).then((value) {
                    //     Navigator.pop(context);
                    //     // setState(() {
                    //     //   bottomSheetShown = false;

                    //     //   fabIcon = const Icon(Icons.edit);

                    //     //   tasks = value;
                    //     // });
                    //   });
                    // });
                  }
                } else {
                  scafoldKey.currentState!
                      .showBottomSheet(
                        elevation: 8,
                        (context) => Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 1, vertical: 10),
                                  child: TextFormField(
                                    controller: titleController,
                                    keyboardType: TextInputType.text,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Empty Field';
                                      } else {
                                        print("Empty Field");
                                        return null;
                                      }
                                    },
                                    onSaved: (String? value) {
                                      // This optional block of code can be used to run
                                      // code when the user saves the form.
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.only(right: 6),
                                        child: Icon(Icons.title),
                                      ),
                                      hintText: 'What do people call you?',
                                      labelText: 'Name',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 1, vertical: 10),
                                  child: TextFormField(
                                    controller: timeController,
                                    keyboardType: TextInputType.datetime,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Empty field';
                                      } else {
                                        print("Empty Field");
                                        return null;
                                      }
                                    },
                                    onSaved: (String? value) {
                                      // This optional block of code can be used to run
                                      // code when the user saves the form.
                                    },
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      prefixIcon:
                                          Icon(Icons.watch_later_outlined),
                                      hintText: 'What do people call you?',
                                      labelText: 'Time',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 1, vertical: 10),
                                  child: TextFormField(
                                    controller: dateController,
                                    keyboardType: TextInputType.datetime,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Empty field';
                                      } else {
                                        print("Empty Field");
                                        return null;
                                      }
                                    },
                                    onSaved: (String? value) {
                                      // This optional block of code can be used to run
                                      // code when the user saves the form.
                                    },
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2023-05-03'),
                                      ).then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      prefixIcon:
                                          Icon(Icons.calendar_today_outlined),
                                      hintText: 'What do people call you?',
                                      labelText: 'Date',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icon(Icons.edit));
                    // setState(() {
                    //   fabIcon = const Icon(Icons.edit);
                    // });
                  });
                  cubit.changeBottomSheetState(
                      isShow: true, icon: Icon(Icons.add));
                  // setState(() {
                  //   fabIcon = const Icon(Icons.add);
                  // });
                }
              },
            ),
            appBar: AppBar(
              backgroundColor: Colors.blueAccent,
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
                BottomNavigationBarItem(icon: Icon(Icons.done), label: "done"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: "arch"),
              ],
            ),
            // body: tasks.length == 0
            //     ? Center(child: CircularProgressIndicator())
            //     : cubit.screens[cubit.currentIndex],
            body: cubit.screens[cubit.currentIndex],
          );
        },
      ),
    );
  }
}
