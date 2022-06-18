import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/DoneTasks/done_task_Screen.dart';
import 'package:todo/modules/archivedtask/archived_task_screen.dart';
import 'package:todo/modules/newTasks/new_task_screen.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/components/constants.dart';

class HomeLayout extends StatefulWidget {
  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  bool isBottomSheetOpen = false;
  int currebtindex = 0;
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var statusController = TextEditingController();
  List<Widget> screens = [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen(),
  ];
  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];
  @override
  void initState() {
    super.initState();
    createDataBase();
  }

  IconData fabIcon = Icons.edit;
  late Database database;
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text(titles[currebtindex]),
      ),
      body: tasks.length > 0
          ? screens[currebtindex]
          : Center(child: CircularProgressIndicator()),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 50.0,
        currentIndex: currebtindex,
        onTap: (index) => {
          setState(() => {currebtindex = index})
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline), label: 'Done'),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined), label: 'Archived'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (isBottomSheetOpen) {
              if (formKey.currentState!.validate()) {
                insertTodoDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text)
                    .then((value) => {
                          getDataFromDataBase(database).then((value) => {
                                Navigator.pop(context),
                                setState(() {
                                  isBottomSheetOpen = false;
                                  fabIcon = Icons.edit;

                                  tasks = value;
                                }),
                                print(tasks)
                              }),
                        });
              }
            } else {
              scaffoldkey.currentState
                  ?.showBottomSheet(
                      elevation: 20.0,
                      (context) => Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defultTextField(
                                      controller: titleController,
                                      type: TextInputType.text,
                                      text: 'task title',
                                      onTap: () {
                                        print('Title');
                                      },
                                      prefixIcon: Icons.title,
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return 'title must not ben empty';
                                        }
                                        return null;
                                      }),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  defultTextField(
                                      onTap: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((value) {
                                          timeController.text =
                                              value!.format(context).toString();
                                          // print(value?.format(context));
                                        });

                                        print('Timeing');
                                      },
                                      controller: timeController,
                                      type: TextInputType.datetime,
                                      text: 'task Time',
                                      prefixIcon: Icons.watch_later_outlined,
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return 'Time must not ben empty';
                                        }
                                        return null;
                                      }),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  defultTextField(
                                      onTap: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.parse(
                                                    '2022-07-03'))
                                            .then((value) => {
                                                  dateController.text =
                                                      DateFormat.yMMMd()
                                                          .format(value!),
                                                });
                                      },
                                      // isClickable: false,
                                      controller: dateController,
                                      type: TextInputType.datetime,
                                      text: 'task Date',
                                      prefixIcon: Icons.calendar_month,
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return 'Date must not ben empty';
                                        }
                                        return null;
                                      }),
                                ],
                              ),
                            ),
                          ))
                  .closed
                  .then((value) => {
                        isBottomSheetOpen = false,
                        setState(() {
                          fabIcon = Icons.edit;
                        }),
                      });
              isBottomSheetOpen = true;

              setState(() {
                fabIcon = Icons.add;
              });
            }

            // try {

            //   // insertTodoDatabase();
            //   var name = await getname();
            //   print(name);
            //   throw ('some error');
            // } catch (error) {
            //   print('erorr ${error.toString()}');
            // }
            // getname()
            //     .then((value) => {print(value)})
            //     .catchError((error) => print(error));
          },
          child: Icon(fabIcon)),
    );
  }

  Future<String> getname() async {
    return 'Ahmad Ali';
  }

  void createDataBase() async {
    database = await openDatabase('todo.db', version: 1,
        onCreate: (database, version) {
      //ID INTEGER
      //TITLE STRING
      //DATE STRING
      //TIME STRING
      //STATUS string
      print('DataBase created');
// await database.execute( 'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
      database
          .execute(
              'CREATE TABLE task (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
          .then((value) => {print('create table')})
          .catchError((error) => {print(error)});
    }, onOpen: (database) {
      getDataFromDataBase(database).then((value) => {
            setState(() {
              tasks = value;
            }),
            print(tasks)
          });
      print('DataBase opened');
    });
  }

  Future insertTodoDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    return await database.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO task(title,time,date,status) VALUES("$title", "$time", "$date","new")')
          .then((value) {
        print('${value}insert done');
      }).catchError((error) {
        print('error when insert ${error}');
      });
      return null;
    });
  }

  Future<List<Map>> getDataFromDataBase(database) async {
    return await database.rawQuery('select * FROM task');
  }
}
