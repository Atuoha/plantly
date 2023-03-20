import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plantly/resources/route_manager.dart';

import '../../../constants/color.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../../resources/values_manager.dart';
import 'package:table_calendar/table_calendar.dart';

class TaskSingleView extends StatelessWidget {
  const TaskSingleView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final data =  ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    final task  = data['task'];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
        ),
        title: Text(
          'For: Your Task',
          style: getRegularStyle(
            color: fontColor,
            fontSize: FontSize.s25,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context)
                  .pushNamed(RouteManager.singlePlantViewScreen),
              child: SizedBox(
                height: size.height / 4,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'assets/images/f1.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => Navigator.of(context)
                  .pushNamed(RouteManager.singlePlantViewScreen),
              child: FittedBox(
                child: Text(
                 task['title'],
                  style: getMediumStyle(
                    color: fontColor,
                    fontSize: FontSize.s25,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Repeat: Once a week',
              style: getRegularStyle(
                color: Colors.grey,
                fontSize: FontSize.s16,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Then I want to show you how you could turn your passion for helping and empowering others… Then I want to show you how you could turn your passion for helping and empowering others…',
              textAlign: TextAlign.justify,
              style: getRegularStyle(
                color: Colors.black,
                fontSize: FontSize.s16,
              ),
            ),
            const SizedBox(height: 20),
            TableCalendar(
              calendarFormat: CalendarFormat.twoWeeks,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                leftChevronIcon: Icon(Icons.calendar_month),
                rightChevronVisible: false,
              ),
              firstDay: task,
              lastDay: DateTime.now(),
              focusedDay: DateTime.now(),
            ),
          ],
        ),
      ),
    );
  }
}
