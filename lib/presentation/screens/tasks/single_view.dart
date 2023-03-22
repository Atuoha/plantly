import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantly/presentation/screens/tasks/edit.dart';
import 'package:plantly/resources/route_manager.dart';
import '../../../business_logic/plant/plant_cubit.dart';
import '../../../business_logic/task/task_cubit.dart';
import '../../../constants/color.dart';
import '../../../constants/enums/process_status.dart';
import '../../../models/plant.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../widgets/are_you_sure_dialog.dart';
import '../../widgets/loading.dart';

class TaskSingleView extends StatefulWidget {
  const TaskSingleView({
    Key? key,
    required this.task,
    required this.taskDocId,
  }) : super(key: key);
  final DocumentSnapshot task;
  final String taskDocId;

  @override
  State<TaskSingleView> createState() => _TaskSingleViewState();
}

class _TaskSingleViewState extends State<TaskSingleView>
    with SingleTickerProviderStateMixin {
  Plant plant = Plant.initial();
  bool isLoading = true;

  deleteTaskAction(String taskId) {
    context.read<TaskCubit>().deleteTask(id: taskId);
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  void removeTaskDialog(String taskName, String taskId) {
    areYouSureDialog(
      title: 'Delete $taskName',
      content: 'Are you sure you want to delete $taskName?',
      context: context,
      action: deleteTaskAction,
      id: taskId,
      isIdInvolved: true,
    );
  }

  Animation<double>? _animation;
  AnimationController? _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController!);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // retrievePlant();
    setState(() {
      plant = context.read<PlantCubit>().state.plant;
    });

    Timer(const Duration(seconds: 5), () {
      setState(() {
        if (context.read<PlantCubit>().state.status == ProcessStatus.success) {
          isLoading = false;
        }
      });
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionBubble(
        items: [
          Bubble(
            title: "Edit Task",
            iconColor: Colors.white,
            bubbleColor: primaryColor,
            icon: Icons.edit_note,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditTask(
                  task: widget.task,
                ),
              ),
            ),
          ),
          Bubble(
            title: "Delete Task",
            iconColor: Colors.white,
            bubbleColor: Colors.red,
            icon: Icons.delete_forever,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () => removeTaskDialog(
              widget.task['title'],
              widget.taskDocId,
            ),
          ),
        ],
        animation: _animation!,
        onPress: () => _animationController!.isCompleted
            ? _animationController!.reverse()
            : _animationController!.forward(),
        iconColor: Colors.white,
        iconData: Icons.chevron_right,
        backGroundColor: primaryColor,
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
        ),
        title: Text(
          'For: ${plant.title}',
          style: getRegularStyle(
            color: fontColor,
            fontSize: FontSize.s25,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 10.0,
        ),
        child: isLoading
            ? const Center(
                child: LoadingWidget(size: 50),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushNamed(RouteManager.singlePlantViewScreen),
                    child: SizedBox(
                      height: size.height / 4,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          plant.imgUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushNamed(RouteManager.singlePlantViewScreen),
                    child: FittedBox(
                      child: Text(
                        widget.task['title'],
                        style: getMediumStyle(
                          color: fontColor,
                          fontSize: FontSize.s25,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Repeat: ${widget.task['repeat']}',
                    style: getRegularStyle(
                      color: Colors.grey,
                      fontSize: FontSize.s16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.task['description'],
                    textAlign: TextAlign.justify,
                    style: getRegularStyle(
                      color: Colors.black,
                      fontSize: FontSize.s16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TableCalendar(
                    calendarFormat: CalendarFormat.twoWeeks,
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      leftChevronIcon: Icon(Icons.calendar_month),
                      rightChevronVisible: false,
                    ),
                    firstDay: widget.task['date'].toDate(),
                    lastDay: widget.task['date'].toDate(),
                    focusedDay: widget.task['date'].toDate(),
                  ),
                ],
              ),
      ),
    );
  }
}
