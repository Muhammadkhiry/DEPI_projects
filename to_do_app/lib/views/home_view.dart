import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/cubits/task_cubit/tasks_cubit.dart';
import 'package:to_do_app/cubits/task_cubit/tasks_states.dart';
import 'package:to_do_app/cubits/user_cubit/user_cubit.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/widgets/add_task_widget.dart';
import 'package:to_do_app/widgets/no_tasks_widget.dart';
import 'package:to_do_app/widgets/task_builder.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final DateTime now = DateTime.now();
  late final DateTime date = DateTime(now.year, now.month, now.day);
  late final String shortMonthName = DateFormat('MMM').format(now);

  @override
  Widget build(BuildContext context) {
    final String userName = BlocProvider.of<UserCubit>(context).userName;

    return BlocBuilder<TasksCubit, TasksStates>(
      builder: (context, state) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xFF00B4D8),
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                showModalBottomSheet(
                  showDragHandle: true,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        left: 20,
                        right: 20,
                        top: 16,
                      ),
                      child: AddTaskWidget(),
                    );
                  },
                );
              },
            ),
            backgroundColor: const Color(0xFFF8FAFC),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: const Icon(Icons.menu, color: Colors.black),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, $userName",
                    style: const TextStyle(
                      fontSize: 28,
                      color: Color(0xFF0F172A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Today: $shortMonthName ${date.day}, ${date.year}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    height: 133,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF0F2027),
                          Color(0xFF203A43),
                          Color(0xFF2C5364),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Your Daily Focus",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Focus on progress, not perfection.",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 91,
                          height: 91,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CircularProgressIndicator(
                                value:
                                    BlocProvider.of<TasksCubit>(
                                      context,
                                    ).completedTasks.length.toDouble() /
                                    (BlocProvider.of<TasksCubit>(
                                          context,
                                        ).completedTasks.length.toDouble() +
                                        BlocProvider.of<TasksCubit>(
                                          context,
                                        ).tasks.length.toDouble()),
                                strokeWidth: 11,
                                backgroundColor: Colors.white.withOpacity(0.1),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.tealAccent,
                                ),
                              ),
                              Center(
                                child: Text(
                                  "${BlocProvider.of<TasksCubit>(context).completedTasks.length} / ${BlocProvider.of<TasksCubit>(context).completedTasks.length + BlocProvider.of<TasksCubit>(context).tasks.length}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const TabBar(
                    indicatorColor: Color(0xFF00B4D8),
                    labelColor: Color(0xFF0F172A),
                    unselectedLabelColor: Colors.grey,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    tabs: [
                      Tab(text: "All Tasks"),
                      Tab(text: "Completed"),
                    ],
                  ),
                  const SizedBox(height: 10),

                  if (state is TasksLoading)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state is TasksSuccess)
                    Expanded(
                      child: TabBarView(
                        children: [
                          buildTaskList(
                            state.tasks,
                          ), // Tab 1: All / Active Tasks
                          buildTaskList(
                            state.completedTasks,
                          ), // Tab 2: Completed Tasks
                        ],
                      ),
                    )
                  else
                    const Expanded(child: NoTasksWidget()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget buildTaskList(List<TaskModel> taskList) {
  if (taskList.isEmpty) {
    return const NoTasksWidget();
  }
  return ListView.builder(
    padding: const EdgeInsets.symmetric(vertical: 8),
    itemCount: taskList.length,
    itemBuilder: (context, index) {
      return TaskBuilder(taskModel: taskList[index]);
    },
  );
}
