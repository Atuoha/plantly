import 'package:flutter/material.dart';
import '../../constants/color.dart';
import '../../resources/styles_manager.dart';

class ActionWrap extends StatelessWidget {
  const ActionWrap({
    Key? key,
    required this.title,
    required this.actionTitle,
    required this.action,
  }) : super(key: key);

  final String title;
  final String actionTitle;
  final Function action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            title,
            style: getRegularStyle(color: accentColor),
          ),
          const SizedBox(width: 2),
          Container(
            padding: const EdgeInsets.only(bottom: 2),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: primaryColor),
              ),
            ),
            child: GestureDetector(
              onTap: () => action(),
              child: Text(
                actionTitle,
                style: const TextStyle(
                  color: primaryColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
