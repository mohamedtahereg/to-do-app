import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../view/archieved_tasks.dart';
import '../view/done_tasks.dart';
import '../view/new_tasks.dart';
import 'cubit_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  List<Map> tasks = [];
  bool bottomSheetShown = false;
  Widget fabIcon = Icon(Icons.edit);
  int currentIndex = 0;
  List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];
  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  late Database database;
  void createDatabase() {
    openDatabase(
      "todo.db",
      version: 1,
      onCreate: (database, version) async {
        print("database created");
        await database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TXT,date TEXT,time TEXT,status TEXT)')
            .then((value) => print("table crated"))
            .catchError((error) {
          print("error when creating table ${error.toString()}");
        });
      },
      onOpen: (database) {
        getData(database).then((value) {
          tasks = value;
          emit(AppGetDatabase());
        });
        print("database opened");
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabase());
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("$title","$date","$time","$date")')
          .then((value) {
        print("$value  inserted successfly");
        emit(AppinsertDatabase());
        getData(database).then((value) {
          tasks = value;
          emit(AppGetDatabase());
        });
      }).catchError((error) {
        print("Error while enserting new error ${error.toString()}");
      });
    });
    return null;
  }

  void changeBottomSheetState({
    required bool isShow,
    required Icon icon,
  }) {
    bottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  Future<List<Map>> getData(database) async {
    emit(AppGetDatabaseLoadingState());
    return await database.rawQuery('SELECT * FROM tasks');
  }
}
