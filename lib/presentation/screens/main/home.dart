import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantly/resources/styles_manager.dart';
import '../../../business_logic/auth_bloc/auth_bloc.dart';
import '../../../business_logic/profile/profile_cubit.dart';
import '../../../constants/color.dart';
import '../../../constants/enums/process_status.dart';
import '../../../constants/firestore_refs.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/route_manager.dart';
import '../../../resources/values_manager.dart';
import '../../components/single_plant_listview.dart';
import '../../widgets/loading.dart';
import '../../widgets/searchbox.dart';
import '../plant/single_view.dart';

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final userId = FirebaseAuth.instance.currentUser!.uid;
    Stream<QuerySnapshot> plantStream = FirestoreRef.plantRef
        .where('userId', isEqualTo: userId)
        .snapshots();

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
              child: ListView(
                padding: EdgeInsets.zero,
                children: List.generate(
                  10,
                  (index) => Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Dismissible(
                      background: Container(
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: litePlantColor,
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.delete_forever_outlined,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (DismissDirection direction) =>
                          removeFromList(),
                      key: const ValueKey('dissimible1'),
                      confirmDismiss: (DismissDirection direction) =>
                          showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Do you want to delete?'),
                          content: const Text(
                            'Delete this plant. Are you sure you want to continue',
                          ),
                          actions: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(10),
                              ),
                              onPressed: () {},
                              child: const Text('Yes'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(10),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: plantBgColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        height: 90,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset('assets/images/f1.jpg'),
                            ),
                            const SizedBox(width: AppSize.s10),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    child: Text(
                                      'Plaintain Wuve',
                                      style: getMediumStyle(
                                        color: fontColor,
                                        fontSize: FontSize.s18,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  FittedBox(
                                    child: Text(
                                      'lorem ipsum and lo nota',
                                      style: getRegularStyle(
                                        color: fontColor,
                                        fontSize: FontSize.s16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
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
                            builder: (context) =>
                                SinglePlantScreen(plant: plant),
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
