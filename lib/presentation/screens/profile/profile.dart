import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plantly/business_logic/exports.dart';
import '../../../business_logic/profile/profile_cubit.dart';
import '../../../constants/color.dart';
import '../../../models/user.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/route_manager.dart';
import '../../../resources/styles_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User user = User.initial();
  var plants = 0;
  var tasks = 0;

  @override
  void initState() {
    setState(() {
      user = context.read<ProfileCubit>().state.user;
      plants = context.read<PlantCubit>().state.plants.length;
      tasks = context.read<TaskCubit>().state.tasks.length;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(
          RouteManager.editProfileScreen,
        ),
        backgroundColor: primaryColor,
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
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
          'Profile',
          style: getMediumStyle(
            color: fontColor,
            fontSize: FontSize.s20,
          ),
        ),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, litePlantColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.13, 0.1],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.profileImg),
                      radius: 85,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.fullname,
                      style: getMediumStyle(
                        color: fontColor,
                        fontSize: FontSize.s18,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      user.email,
                      style: getRegularStyle(
                        color: Colors.grey,
                        fontSize: FontSize.s16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Stats/Records',
                style: getMediumStyle(
                  color: fontColor,
                  fontSize: FontSize.s18,
                ),
              ),
              DataTable(
                columns: const [
                  DataColumn(
                    label: Text('Plants'),
                  ),
                  DataColumn(
                    label: Text('Tasks'),
                  ),
                  DataColumn(
                    label: Text('Last Sync'),
                  )
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(Text(plants.toString())),
                      DataCell(Text(tasks.toString())),
                      DataCell(
                        Text(
                          DateFormat.yMEd().format(DateTime.now()).toString(),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
