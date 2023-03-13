import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantly/resources/styles_manager.dart';
import '../../../business_logic/auth_bloc/auth_bloc.dart';
import '../../../business_logic/profile/profile_cubit.dart';
import '../../../constants/color.dart';
import '../../../constants/enums/process_status.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/route_manager.dart';
import '../../../resources/values_manager.dart';
import '../../widgets/loading.dart';
import '../../widgets/searchbox.dart';

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
            SearchBox(),
            const SizedBox(height: 10),
            Expanded(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                children: List.generate(
                  10,
                  (index) => Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSize.s20),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/f1.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                            child: Container(
                              height: size.height / 13,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(AppSize.s20),
                                  bottomLeft: Radius.circular(AppSize.s20),
                                ),
                                // color: Colors.grey.withOpacity(0.5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0,
                                  vertical: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        'Crown Imperia',
                                        style: getMediumStyle(
                                          color: darkColor,
                                          fontSize: FontSize.s18,
                                        ),
                                      ),
                                    ),
                                    // const SizedBox(height: 5),
                                    Text(
                                      'unsolicited gaps',
                                      style: getItalicsRegularStyle(
                                        color: Colors.grey.shade500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
