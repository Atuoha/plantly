import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plantly/business_logic/exports.dart';
import '../../../constants/color.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/route_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../../constants/firestore_refs.dart';
import '../../utils/task_stream_builder.dart';

class ViewAllTasks extends StatefulWidget {
  const ViewAllTasks({Key? key}) : super(key: key);

  @override
  State<ViewAllTasks> createState() => _ViewAllTasksState();
}

class _ViewAllTasksState extends State<ViewAllTasks> {
  final now = DateTime.now();
  var date = DateTime.now();

  // logged in User id
  final userId = FirebaseAuth.instance.currentUser!.uid;

  // stream controller for all tasks
  final StreamController<QuerySnapshot> _controller =
      StreamController<QuerySnapshot>();

  // stream controller for today's task
  final StreamController<QuerySnapshot> _controller2 =
      StreamController<QuerySnapshot>();

  @override
  void initState() {
    setState(() {
      date = DateTime(now.year, now.month, now.day);
    });

    // listening to all task's streams
    FirestoreRef.taskRef
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((event) {
      _controller.add(event);
    });

    // listening to today's task's stream
    FirestoreRef.taskRef
        .where('userId', isEqualTo: userId)
        .where('date', isEqualTo: date)
        .snapshots()
        .listen((event) {
      _controller2.add(event);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.close();
    _controller2.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: primaryColor,
              child: GestureDetector(
                onTap: () async {
                  var model = Navigator.of(context);
                  await context.read<PlantCubit>().fetchPlants();

                  model.pushNamed(RouteManager.createTaskScreen);
                },
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          )
        ],
        title: Text(
          'Task list',
          style: getRegularStyle(
            color: fontColor,
            fontSize: FontSize.s25,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 15.0,
          left: 8.0,
          right: 8.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODAY TODOS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today',
                  style: getMediumStyle(
                    color: fontColor,
                    fontSize: FontSize.s18,
                  ),
                ),
                Text(
                  DateFormat.yMEd().format(DateTime.now()),
                  style: getRegularStyle(
                    color: fontColor,
                    fontSize: FontSize.s14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TaskStreamBuilder(
                stream: _controller2.stream,
                errorMessage: 'Today\'s tasks are empty!',
              ),
            ),
            const SizedBox(height: 10),

            // OTHER TODOS
            Text(
              'Others',
              style: getMediumStyle(
                color: fontColor,
                fontSize: FontSize.s18,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TaskStreamBuilder(
                stream: _controller.stream,
                errorMessage: 'Tasks are empty!',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
