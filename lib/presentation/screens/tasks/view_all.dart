import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/color.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/route_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../../resources/values_manager.dart';

class ViewAllTasks extends StatelessWidget {
  const ViewAllTasks({Key? key}) : super(key: key);

  void removeFromList() {}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: primaryColor,
              child: GestureDetector(
                onTap: () => Navigator.of(context)
                    .pushNamed(RouteManager.createTaskScreen),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          )
        ],
        title: Text(
          'Task list',
          style: getRegularStyle(
            color: fontColor,
            fontSize: FontSize.s25,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 8.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODAY TODOS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today',
                  style: getMediumStyle(
                    color: fontColor,
                    fontSize: FontSize.s18,
                  ),
                ),
                Text(
                  DateFormat.yMEd().format(DateTime.now()),
                  style: getRegularStyle(
                    color: fontColor,
                    fontSize: FontSize.s14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: List.generate(
                  10,
                  (index) =>  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushNamed(RouteManager.taskSingleViewScreen),
                    child: Padding(
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
            ),
            const SizedBox(height: 10),

            // OTHER TODOS
            Text(
              'Others',
              style: getMediumStyle(
                color: fontColor,
                fontSize: FontSize.s18,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: List.generate(
                  10,
                  (index) => GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushNamed(RouteManager.taskSingleViewScreen),
                    child: Padding(
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
            ),
          ],
        ),
      ),
    );
  }
}
