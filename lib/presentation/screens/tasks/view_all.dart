import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plantly/business_logic/exports.dart';
import 'package:plantly/presentation/presentation_export.dart';
import 'package:plantly/repositories/plant_repository.dart';

import '../../../constants/color.dart';
import '../../../models/plant.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/route_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../../resources/values_manager.dart';
import '../../../constants/firestore_refs.dart';
import '../../components/task_single_listview.dart';
import '../../widgets/loading.dart';

class ViewAllTasks extends StatefulWidget {
  const ViewAllTasks({Key? key}) : super(key: key);

  @override
  State<ViewAllTasks> createState() => _ViewAllTasksState();
}

class _ViewAllTasksState extends State<ViewAllTasks> {
  final now = DateTime.now();
  var date = DateTime.now();

  void removeFromList(String id) {}

  @override
  void initState() {
    setState(() {
      date = DateTime(now.year, now.month, now.day);
    });
    super.initState();
  }

  Plant plant = Plant.initial();

  retrievePlant(String plantId) async {
    var plantData = await context.read<PlantCubit>().fetchPlant(id: plantId);
    setState(() {
      plant = plantData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    Stream<QuerySnapshot> taskStreams = FirestoreRef.taskRef
        .where('userId', isEqualTo: userId)
        // .orderBy('date', descending: true)
        .snapshots();

    Stream<QuerySnapshot> todayTaskStreams = FirestoreRef.taskRef
        .where('userId', isEqualTo: userId)
        .where('date', isEqualTo: date)
        .snapshots();

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: primaryColor,
              child: GestureDetector(
                onTap: () => Navigator.of(context)
                    .pushNamed(RouteManager.createTaskScreen),
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
              child: StreamBuilder<QuerySnapshot>(
                stream: todayTaskStreams,
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
                          // Image.asset(AssetManager.empty),
                          Text(
                            'Today\'s Tasks are empty!',
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

                      return GestureDetector(
                        onTap: () async {
                          var model = Navigator.of(context);
                          await context
                              .read<PlantCubit>()
                              .fetchPlant(id: plantId);

                          model.push(
                            MaterialPageRoute(
                              builder: (context) => TaskSingleView(task: task),
                            ),
                          );
                        },
                        child: SingleTaskListView(
                          id: task['id'],
                          title: task['title'],
                          description: task['description'],
                          imgUrl: plant.imgUrl,
                          removeFromList: removeFromList,
                        ),
                      );
                    },
                  );
                },
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
              child: StreamBuilder<QuerySnapshot>(
                stream: taskStreams,
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
                          // Image.asset(AssetManager.empty),
                          Text(
                            'Tasks are empty!',
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

                      return GestureDetector(
                        onTap: () async {
                          var model = Navigator.of(context);
                          await context
                              .read<PlantCubit>()
                              .fetchPlant(id: plantId);

                          model.push(
                            MaterialPageRoute(
                              builder: (context) => TaskSingleView(task: task),
                            ),
                          );
                        },
                        child: SingleTaskListView(
                          id: task['id'],
                          title: task['title'],
                          description: task['description'],
                          imgUrl: plant.imgUrl,
                          removeFromList: removeFromList,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
