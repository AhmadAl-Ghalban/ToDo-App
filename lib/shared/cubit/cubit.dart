import 'dart:ffi';

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
  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> arcivetasks = [];

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
      getDataFromDataBase(database);
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
        getDataFromDataBase(database);
      }).catchError((error) {
        print('error when insert ${error}');
      });
      return null;
    });
  }

  void updataData({required String status, required int id}) async {
// Update some record
    return await database.rawUpdate(
      'UPDATE task SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value) {
      print('Updata $value');
      getDataFromDataBase(database);

      emit(AppUpdataDataState());
    });
  }

  void getDataFromDataBase(database) {
    emit(AppGetDataBaseLoadingState());
    newtasks = [];
    donetasks = [];
    arcivetasks = [];
    database.rawQuery('select * FROM task').then((value) => {
          // tasks = value,
          // print(tasks),
          print('value === $value'),
          value.forEach((element) {
            if (element['status'] == 'new') {
              newtasks.add(element);
            } else if (element['status'] == 'done') {
              print('Done');

              donetasks.add(element);
            } else {
              arcivetasks.add(element);
            }
          }),
          emit(AppGetDataBaseState()),
        });
  }
void deleteData({required int id})async{
database.rawDelete('DELETE FROM task WHERE id= ?',[id]).then((value) => {
getDataFromDataBase(database),
emit(AppDeleteDataState()),

});
}
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangebottomSheetState());
  }
}


/*

.then((value) =>
            {tasks = value, print(tasks), emit(AppGetDataBaseState())});
*/