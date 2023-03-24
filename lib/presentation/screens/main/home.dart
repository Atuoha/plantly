import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantly/resources/styles_manager.dart';
import '../../../business_logic/auth_bloc/auth_bloc.dart';
import '../../../business_logic/profile/profile_cubit.dart';
import '../../../business_logic/task/task_cubit.dart';
import '../../../constants/color.dart';
import '../../../constants/enums/process_status.dart';
import '../../../constants/firestore_refs.dart';
import '../../../resources/assets_manager.dart';
import '../../../resources/font_manager.dart';
import '../../components/single_plant_listview.dart';
import '../../utils/task_stream_builder.dart';
import '../../widgets/loading.dart';
import '../plant/single_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // stream controller
  final StreamController<QuerySnapshot> _controller =
      StreamController<QuerySnapshot>();

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  void initState() {
    getProfile();

    // task stream
    FirestoreRef.taskRef
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((event) {
      _controller.add(event);
    });
    super.initState();
  }

  // get profile details
  String userId = "";

  void getProfile() {
    userId = context.read<AuthBloc>().state.user!.uid;
    context.read<ProfileCubit>().fetchProfile(userId: userId);
  }

  // remove plant
  void removeFromList(String taskId) {
    context.read<TaskCubit>().deleteTask(id: taskId);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // Stream for plants
    Stream<QuerySnapshot> plantStream =
        FirestoreRef.plantRef.where('userId', isEqualTo: userId).snapshots();

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
              child: TaskStreamBuilder(
                stream: _controller.stream,
                errorMessage: 'Tasks are empty!',
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
                          Image.asset(AssetManager.angryEmoji),
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
