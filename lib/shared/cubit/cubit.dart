import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/DoneTasks/done_task_Screen.dart';
import 'package:todo/modules/archivedtask/archived_task_screen.dart';
import 'package:todo/modules/newTasks/new_task_screen.dart';

import 'package:todo/shared/cubit/status.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  int currebtindex = 0;
  List<Map> tasks = [];

  List<Widget> screens = [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen(),
  ];
  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  void changeIndex(int index) {
    currebtindex = index;
    emit(AppChangebottomNavbarState());
  }

  Future<String> getname() async {
    return 'Ahmad Ali';
  }

  late Database database;

  void createDataBase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      print('DataBase created');
      database
          .execute(
              'CREATE TABLE task (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
          .then((value) => {print('create table')})
          .catchError((error) => {print(error)});
    }, onOpen: (database) {
      getDataFromDataBase(database).then((value) =>
          {tasks = value, print(tasks), emit(AppGetDataBaseState())});
      print('DataBase opened');
    }).then((value) => {database = value, emit(AppCreateDataBaseState())});
  }

  insertTodoDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO task(title,time,date,status) VALUES("$title", "$time", "$date","new")')
          .then((value) {
        print('${value}insert done');
        emit(AppInsertDataBaseState());
        getDataFromDataBase(database).then((value) =>
            {tasks = value, print(tasks), emit(AppGetDataBaseState())});
      }).catchError((error) {
        print('error when insert ${error}');
      });
      return null;
    });
  }

  Future<List<Map>> getDataFromDataBase(database) async {
    emit(AppGetDataBaseLoadingState());
    return await database.rawQuery('select * FROM task');
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangebottomSheetState());
  }
}
