import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantly/resources/route_manager.dart';
import 'package:plantly/resources/styles_manager.dart';
import '../../../business_logic/profile/profile_cubit.dart';
import '../../../constants/color.dart';
import '../../../constants/enums/process_status.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/values_manager.dart';
import '../../widgets/loading.dart';
import 'package:intl/intl.dart';

import '../../widgets/settings_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool syncValue = true;

  switchSync(bool value) {
    setState(() {
      syncValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Settings',
          style: getMediumStyle(
            color: fontColor,
            fontSize: FontSize.s20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account',
              style: getMediumStyle(
                color: fontColor,
                fontSize: FontSize.s18,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s30),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: [
                    Colors.white,
                    bgColor,
                  ],
                ),
              ),
              child: BlocConsumer<ProfileCubit, ProfileState>(
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
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(state.user.profileImg),
                    ),
                    title: Text(
                      state.user.fullname,
                      style: getRegularStyle(
                        color: fontColor,
                        fontSize: FontSize.s16,
                      ),
                    ),
                    subtitle: Text(
                      'Last sync. ${DateFormat.yMd().format(DateTime.now())}',
                      style: getLightStyle(
                        color: Colors.grey,
                        fontSize: FontSize.s14,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () => Navigator.of(context)
                          .pushNamed(RouteManager.editSettingsScreen),
                      icon: const Icon(
                        Icons.arrow_forward_rounded,
                        color: accentColor,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Preferences',
              style: getMediumStyle(
                color: fontColor,
                fontSize: FontSize.s18,
              ),
            ),
            const SizedBox(height: 10),
            const SettingsTile(
              title: 'Language',
              icon: Icons.language,
              routeName: RouteManager.languageScreen,
            ),
            const SizedBox(height: 10),
            const SettingsTile(
              title: 'Notification',
              icon: Icons.notifications,
              routeName: RouteManager.notificationScreen,
            ),
            const SizedBox(height: 10),
            SettingsTile(
              title: 'Synchronization',
              icon: Icons.cloud_sync,
              checkFnc: switchSync,
              checkValue: syncValue,
              isCheckBoxAvailable: true,
            ),
            const SizedBox(height: 10),
            const SettingsTile(
              title: 'Help',
              icon: Icons.help,
              routeName: RouteManager.helpScreen,
            ),
            const SizedBox(height: 10),
            const SettingsTile(
              title: 'About',
              icon: Icons.info,
              routeName: RouteManager.aboutScreen,
            ),
          ],
        ),
      ),
    );
  }
}
