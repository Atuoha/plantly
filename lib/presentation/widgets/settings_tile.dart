import 'package:flutter/material.dart';
import '../../constants/color.dart';
import '../../resources/font_manager.dart';
import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    Key? key,
    required this.title,
    required this.icon,
    this.routeName,
    this.isCheckBoxAvailable = false,
    this.checkValue = false,
    this.checkFnc,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final String? routeName;
  final bool isCheckBoxAvailable;
  final bool checkValue;
  final Function? checkFnc;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s30),
        color: settingsBg,
      ),
      child: ListTile(
        leading: Icon(icon, color: fontColor),
        title: Text(
          title,
          style: getRegularStyle(
            color: fontColor,
            fontSize: FontSize.s18,
          ),
        ),
        trailing: !isCheckBoxAvailable
            ? IconButton(
                onPressed: () => Navigator.of(context).pushNamed(routeName!),
                icon: const Icon(Icons.arrow_forward_rounded),
              )
            : Switch(
                activeColor: accentColor,
                value: checkValue,
                thumbColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (checkValue) {
                      return settingsBg;
                    }
                    return Colors.grey;
                  },
                ),
                onChanged: (value) => checkFnc!(value),
              ),
      ),
    );
  }
}
