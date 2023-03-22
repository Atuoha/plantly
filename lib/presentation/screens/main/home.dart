import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantly/resources/styles_manager.dart';
import '../../../business_logic/auth_bloc/auth_bloc.dart';
import '../../../business_logic/plant/plant_cubit.dart';
import '../../../business_logic/profile/profile_cubit.dart';
import '../../../constants/color.dart';
import '../../../constants/enums/process_status.dart';
import '../../../constants/firestore_refs.dart';
import '../../../models/plant.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/route_manager.dart';
import '../../../resources/values_manager.dart';
import '../../components/single_plant_listview.dart';
import '../../components/task_single_listview.dart';
import '../../widgets/loading.dart';
import '../../widgets/searchbox.dart';
import '../plant/single_view.dart';
import '../tasks/single_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    getProfile();
    super.initState();
  }

  void getProfile() {
    final userId = context.read<AuthBloc>().state.user!.uid;
    context.read<ProfileCubit>().fetchProfile(userId: userId);
  }

  void removeFromList() {}

  Plant plant = Plant.initial();

  retrievePlant(String plantId) async {
    var plantData = await context.read<PlantCubit>().fetchPlant(id: plantId);
    setState(() {
      plant = plantData;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Stream for plants
    Stream<QuerySnapshot> plantStream =
        FirestoreRef.plantRef.where('userId', isEqualTo: userId).snapshots();

    // Streams for tasks
    Stream<QuerySnapshot> taskStreams =
        FirestoreRef.taskRef.where('userId', isEqualTo: userId).snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state.processStatus == ProcessStatus.loading) {
              const LoadingWidget(size: 20);
            } else if (state.processStatus == ProcessStatus.error) {
              const Text('Error!');
            }
          },
          builder: (context, state) {
            if (state.processStatus != ProcessStatus.success) {
              return const LoadingWidget(size: 20);
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(state.user.profileImg),
              ),
            );
          },
        ),
        title: Text(
          'Hi, ${context.read<ProfileCubit>().state.user.fullname}',
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
            Text(
              'To-do list',
              style: getMediumStyle(
                color: fontColor,
                fontSize: FontSize.s18,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: size.height / 2.3,
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
                      retrievePlant(plantId);

                      return GestureDetector(
                        onTap: () async {
                          var model = Navigator.of(context);
                          await context
                              .read<PlantCubit>()
                              .fetchPlant(id: plantId);

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
            Text(
              'Recently added',
              style: getMediumStyle(
                color: fontColor,
                fontSize: FontSize.s18,
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: size.height / 4.5,
              child: StreamBuilder<QuerySnapshot>(
                stream: plantStream,
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
                            'Plants are empty!',
                            style: getRegularStyle(
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var plant = snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SinglePlantScreen(
                              plant: plant,
                              plantDocId: plant.id,
                            ),
                          ),
                        ),
                        child: SinglePlantListView(size: size, plant: plant),
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
