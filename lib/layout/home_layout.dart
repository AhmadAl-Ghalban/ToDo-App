import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/DoneTasks/done_task_Screen.dart';
import 'package:todo/modules/archivedtask/archived_task_screen.dart';
import 'package:todo/modules/newTasks/new_task_screen.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/components/constants.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/status.dart';

class HomeLayout extends StatelessWidget {
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var statusController = TextEditingController();
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppInsertDataBaseState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currebtindex]),
            ),
            body: state is! AppGetDataBaseLoadingState
                ? cubit.screens[cubit.currebtindex]
                : Center(child: CircularProgressIndicator()),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 50.0,
              currentIndex: cubit.currebtindex,
              onTap: (index) => {
                // setState(() => {currebtindex = index})

                cubit.changeIndex(index)
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archived'),
              ],
            ),
            floatingActionButton: FloatingActionButton(
                child: Icon(
                  cubit.fabIcon,
                ),
                onPressed: () {
                  print('object');

                  if (cubit.isBottomSheetShown) {
                    if (formKey.currentState!.validate()) {
                      cubit.insertTodoDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                      );
                    }
                  } else {
                    print('object1');

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
                                                timeController.text = value!
                                                    .format(context)
                                                    .toString();
                                                // print(value?.format(context));
                                              });

                                              print('Timeing');
                                            },
                                            controller: timeController,
                                            type: TextInputType.datetime,
                                            text: 'task Time',
                                            prefixIcon:
                                                Icons.watch_later_outlined,
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
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate:
                                                          DateTime.now(),
                                                      lastDate:
                                                          DateTime.parse(
                                                              '2022-07-03'))
                                                  .then((value) => {
                                                        dateController.text =
                                                            DateFormat.yMMMd()
                                                                .format(
                                                                    value!),
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
                              cubit.changeBottomSheetState(
                                isShow: false,
                                icon: Icons.edit,
                              )
                            });
                    cubit.changeBottomSheetState(
                      isShow: true,
                      icon: Icons.add,
                    );
                  }
                }));
      },
    );
  }
}
