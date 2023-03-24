import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/plant/plant_cubit.dart';
import '../../business_logic/task/task_cubit.dart';
import '../../constants/color.dart';
import '../../constants/firestore_refs.dart';
import '../../models/plant.dart';
import '../../resources/assets_manager.dart';
import '../../resources/styles_manager.dart';
import '../components/task_single_listview.dart';
import '../screens/tasks/single_view.dart';
import '../widgets/loading.dart';

class TaskStreamBuilder extends StatefulWidget {
  const TaskStreamBuilder({
    super.key,
    required this.stream,
    required this.errorMessage,
  });

  final Stream<QuerySnapshot<Object?>> stream;
  final String errorMessage;

  @override
  State<TaskStreamBuilder> createState() => _TaskStreamBuilderState();
}

class _TaskStreamBuilderState extends State<TaskStreamBuilder> {
  // remove from taskList
  void removeFromList(String taskId) {
    context.read<TaskCubit>().deleteTask(id: taskId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.stream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'An error occurred!',
              style: getRegularStyle(
                color: primaryColor,
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingWidget(size: 50));
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AssetManager.angryEmoji),
                Text(
                  widget.errorMessage,
                  style: getRegularStyle(
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var task = snapshot.data!.docs[index];
            final plantId = task['plantId'];

            if (plantId == null) {
              return Container(); // Return an empty widget if plantId is null
            }

            return FutureBuilder<QuerySnapshot>(
                // pulling plant details
                future:
                    FirestoreRef.plantRef.where('id', isEqualTo: plantId).get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> plantSnapshot) {
                  if (plantSnapshot.hasError) {
                    return Center(
                      child: Text(
                        'An error occurred!',
                        style: getRegularStyle(
                          color: primaryColor,
                        ),
                      ),
                    );
                  }

                  var plantDoc = plantSnapshot.data?.docs.first;
                  String plantImg =
                      'https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png';
                  if (plantDoc != null) {
                    plantImg = Plant.fromJson(plantDoc).imgUrl;
                  }

                  return GestureDetector(
                    onTap: () async {
                      var model = Navigator.of(context);
                      await context.read<PlantCubit>().fetchPlant(id: plantId);

                      model.push(
                        MaterialPageRoute(
                          builder: (context) => TaskSingleView(
                            task: task,
                            taskDocId: task.id,
                          ),
                        ),
                      );
                    },
                    child: SingleTaskListView(
                      id: task.id,
                      title: task['title'],
                      description: task['description'],
                      imgUrl: plantImg,
                      removeFromList: removeFromList,
                    ),
                  );
                });
          },
        );
      },
    );
  }
}
