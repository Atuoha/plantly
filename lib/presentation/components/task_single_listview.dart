import 'package:flutter/material.dart';
import '../../constants/color.dart';
import '../../resources/font_manager.dart';
import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';

class SingleTaskListView extends StatelessWidget {
  const SingleTaskListView({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.imgUrl,
    required this.removeFromList,
  });

  final String title;
  final String description;
  final String imgUrl;
  final String id;
  final Function removeFromList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Dismissible(
        background: Container(
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: litePlantColor,
          ),
          child: const Icon(
            Icons.delete_forever_outlined,
            color: Colors.red,
          ),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (DismissDirection direction) => removeFromList(id),
        key: const ValueKey('dissimible1'),
        confirmDismiss: (DismissDirection direction) => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Do you want to delete?'),
            content: Text(
              'Delete this $title. Are you sure you want to continue',
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                ),
                onPressed: ()=>removeFromList(id),
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
              SizedBox(
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: AppSize.s10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Text(
                        title,
                        style: getMediumStyle(
                          color: fontColor,
                          fontSize: FontSize.s18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: MediaQuery.of(context).size.width /1.7,
                      child: Text(
                        description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
    );
  }
}
