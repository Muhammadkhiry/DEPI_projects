import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubit/task_cubit/tasks_cubit.dart';
import '../cubit/task_cubit/tasks_states.dart';
import '../cubit/user_cubit/user_cubit.dart';
import '../cubit/user_cubit/user_states.dart';
import '../widgets/add_task_widget.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/no_tasks_widget.dart';
import '../widgets/task_builder.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedTab = 0; // 0: All Tasks, 1: Completed

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TasksCubit>(context).getTasks();
  }

  void _showTodayReminders(BuildContext context) {
    final pending = context.read<TasksCubit>().todayPending;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today's Reminders",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (pending.isEmpty)
              const Text(
                "You're all caught up for today!",
                style: TextStyle(color: Colors.grey),
              )
            else
              ...pending.map(
                (t) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.radio_button_unchecked,
                      color: Color(0xff00A896)),
                  title: Text(t.title),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todayDate = DateFormat('MMM dd, yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xffF8F9FA),
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () => _showTodayReminders(context),
          ),
        ],
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Hello Header
            BlocBuilder<UserCubit, UserStates>(
              builder: (context, state) {
                final userName = context.watch<UserCubit>().userName;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, ${userName.isEmpty ? 'User' : userName}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Today: $todayDate",
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // Daily Focus Card
            BlocBuilder<TasksCubit, TasksStates>(
              builder: (context, state) {
                final tasksCubit = context.watch<TasksCubit>();
                final todayTasks = tasksCubit.todayTasks;
                final total = todayTasks.length;
                final completed =
                    todayTasks.where((t) => t.isCompleted).length;
                final double progress = total == 0 ? 0 : completed / total;

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xff1C313A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Your Daily Focus",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Focus on progress, not perfection.",
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 6,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xff26A69A),
                              ),
                            ),
                          ),
                          Text(
                            "$completed / $total",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 25),

            // Tabs Header
            Align(
              alignment: Alignment.center,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _selectedTab = 0),
                    child: Column(
                      children: [
                        Text(
                          "All Tasks",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _selectedTab == 0
                                ? const Color(0xff00A896)
                                : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (_selectedTab == 0)
                          Container(
                            width: 40,
                            height: 3,
                            decoration: BoxDecoration(
                              color: const Color(0xff00A896),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                  GestureDetector(
                    onTap: () => setState(() => _selectedTab = 1),
                    child: Column(
                      children: [
                        Text(
                          "Completed",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _selectedTab == 1
                                ? const Color(0xff00A896)
                                : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (_selectedTab == 1)
                          Container(
                            width: 40,
                            height: 3,
                            decoration: BoxDecoration(
                              color: const Color(0xff00A896),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Tasks List View
            Expanded(
              child: BlocBuilder<TasksCubit, TasksStates>(
                builder: (context, state) {
                  final tasksCubit = context.watch<TasksCubit>();
                  final currentList = _selectedTab == 0
                      ? tasksCubit.tasks
                      : tasksCubit.completedTasks;

                  if (currentList.isEmpty) {
                    return const NoTasksWidget();
                  }

                  return TaskBuilder(tasks: currentList);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff00A896),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const AddTaskWidget(),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}