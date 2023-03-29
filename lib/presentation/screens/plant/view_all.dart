import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantly/presentation/presentation_export.dart';
import 'package:plantly/resources/styles_manager.dart';
import '../../../business_logic/auth_bloc/auth_bloc.dart';
import '../../../business_logic/profile/profile_cubit.dart';
import '../../../constants/color.dart';
import '../../../constants/enums/process_status.dart';
import '../../../constants/firestore_refs.dart';
import '../../../resources/assets_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/route_manager.dart';
import '../../components/plant_single_gridview.dart';
import '../../widgets/loading.dart';
import '../../widgets/searchbox.dart';

import 'package:plantly/business_logic/exports.dart';

class ViewAllPlants extends StatefulWidget {
  const ViewAllPlants({Key? key}) : super(key: key);

  @override
  State<ViewAllPlants> createState() => _ViewAllPlantsState();
}

class _ViewAllPlantsState extends State<ViewAllPlants> {
  @override
  void initState() {
    getProfile();
    super.initState();
  }

  String userId = "";

  void getProfile() {
    userId = context.read<AuthBloc>().state.user!.uid;
    context.read<ProfileCubit>().fetchProfile(userId: userId);
  }

  @override
  Widget build(BuildContext context) {
    // plant stream
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: primaryColor,
              child: GestureDetector(
                onTap: () => Navigator.of(context)
                    .pushNamed(RouteManager.createPlantScreen),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          )
        ],
        title: Text(
          'Your Plants',
          style: getRegularStyle(
            color: fontColor,
            fontSize: FontSize.s25,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SearchBox(),
            const SizedBox(height: 10),
            MultiBlocListener(
              listeners: [
                //
                BlocListener<SearchCubit, SearchState>(
                    listener: (context, state) {
                  context
                      .read<FilteredPlantsCubit>()
                      .setSearchedPlants(keyword: state.keyword);
                }),

                BlocListener<FilterCubit, FilterState>(
                    listener: (context, state) {
                  context
                      .read<FilteredPlantsCubit>()
                      .setFilteredPlants(plantFilter: state.plantFilter);
                })
              ],
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

                  return Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var plant = snapshot.data!.docs[index];

                        // split this later
                        return GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SinglePlantScreen(
                                plant: plant,
                                plantDocId: plant.id,
                              ),
                            ),
                          ),
                          child: SinglePlantGridView(
                            title: plant['title'],
                            description: plant['description'],
                            imgUrl: plant['imgUrl'],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
