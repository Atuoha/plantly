import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantly/presentation/screens/tasks/edit.dart';
import 'package:plantly/resources/route_manager.dart';

import '../../../business_logic/plant/plant_cubit.dart';
import '../../../constants/color.dart';
import '../../../constants/enums/process_status.dart';
import '../../../models/plant.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../../resources/values_manager.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../widgets/loading.dart';

class TaskSingleView extends StatefulWidget {
  const TaskSingleView({
    Key? key,
    required this.task,
    required this.plantId,
  }) : super(key: key);
  final DocumentSnapshot task;
  final String plantId;

  @override
  State<TaskSingleView> createState() => _TaskSingleViewState();
}

class _TaskSingleViewState extends State<TaskSingleView> {
  Plant plant = Plant.initial();

  bool isLoading = true;

  @override
  void initState() {
    // retrievePlant();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // retrievePlant();
    setState(() {
      plant = context.read<PlantCubit>().state.plant;
    });

    Timer(const Duration(seconds: 5), () {
      setState(() {
        if (context.read<PlantCubit>().state.status == ProcessStatus.success) {
          isLoading = false;
        }
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
          'For: ${plant.title}',
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
        child: isLoading
            ? const Center(
                child: LoadingWidget(size: 50),
              )
            : Column(
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
                        child: Image.network(
                          plant.imgUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushNamed(RouteManager.singlePlantViewScreen),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FittedBox(
                          child: Text(
                            widget.task['title'],
                            style: getMediumStyle(
                              color: fontColor,
                              fontSize: FontSize.s25,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditTask(
                                task: widget.task,
                              ),
                            ),
                          ),
                          icon: const Icon(
                            Icons.edit_note,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Repeat: ${widget.task['repeat']}',
                    style: getRegularStyle(
                      color: Colors.grey,
                      fontSize: FontSize.s16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.task['description'],
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
                    firstDay: widget.task['date'].toDate(),
                    lastDay: widget.task['date'].toDate(),
                    focusedDay: widget.task['date'].toDate(),
                  ),
                ],
              ),
      ),
    );
  }
}
