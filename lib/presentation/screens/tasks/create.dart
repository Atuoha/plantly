import 'package:flutter/material.dart';
import '../../../constants/color.dart';
import '../../../constants/enums/drop_down.dart';
import '../../../constants/enums/fields.dart';
import '../../../models/plant.dart';
import '../../../models/success.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../../resources/values_manager.dart';
import '../../widgets/plant_task_text_field.dart';
import '../../widgets/success_dialog.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({Key? key}) : super(key: key);

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController plantController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController repeatController = TextEditingController();

  var currentPlant = '';
  final plants = [
    'Sun Flower',
    'Hibiscus',
    'Moon Flower',
    'Dove Flower',
  ];

  var currentRepeat = '';
  final repeats = [
    'Once a day',
    'Every week',
    'Once a month',
    'Others',
  ];

  @override
  void initState() {
    setState(() {
      currentPlant = plants[0];
      currentRepeat = repeats[0];
    });
    super.initState();
  }

  void submitTask() {
    FocusScope.of(context).unfocus();
  }

  // pick date
  Future pickDate() async {
    var pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text = pickedDate.toString();
      });
    }
  }

  // Drop down Widget
  Widget kDropDown({
    required DropDown dropdown,
    required String currentValue,
    required List<String> list,
  }) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
          borderRadius: BorderRadius.circular(AppSize.s20),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
          borderRadius: BorderRadius.circular(AppSize.s20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
          borderRadius: BorderRadius.circular(AppSize.s20),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
          borderRadius: BorderRadius.circular(AppSize.s20),
        ),
      ),
      value: currentValue,
      items: list
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
      onChanged: (value) {
        switch (dropdown) {
          case DropDown.plant:
            setState(() {
              currentPlant = value!;
            });
            break;

          case DropDown.repeat:
            setState(() {
              currentRepeat = value!;
            });
            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Add Task',
          style: getRegularStyle(
            color: fontColor,
            fontSize: FontSize.s25,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => successDialog(
              context: context,
              success: Success(
                title: 'Adding Task info',
                description:
                    'Add task by adding the image, title and description.',
              ),
            ),
            icon: const Icon(
              Icons.info,
              color: primaryColor,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 18.0,
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Name',
                  style: getRegularStyle(
                    color: fontColor,
                    fontSize: FontSize.s18,
                  ),
                ),
                const SizedBox(height: 5),
                kTextField(
                  controller: titleController,
                  title: 'Title',
                  maxLine: 1,
                  textField: Field.title,
                ),
                const SizedBox(height: 10),
                Text(
                  'Description',
                  style: getRegularStyle(
                    color: fontColor,
                    fontSize: FontSize.s18,
                  ),
                ),
                const SizedBox(height: 10),
                kTextField(
                  controller: descriptionController,
                  title: 'Description',
                  textField: Field.description,
                  maxLine: 8,
                ),
                const SizedBox(height: 10),
                Text(
                  'Plant',
                  style: getRegularStyle(
                    color: fontColor,
                    fontSize: FontSize.s18,
                  ),
                ),
                const SizedBox(height: 10),
                kDropDown(
                  dropdown: DropDown.plant,
                  currentValue: currentPlant,
                  list: plants,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date',
                      style: getRegularStyle(
                        color: fontColor,
                        fontSize: FontSize.s18,
                      ),
                    ),
                    Text(
                      'Repeat',
                      style: getRegularStyle(
                        color: fontColor,
                        fontSize: FontSize.s18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: dateController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Date can not be empty!';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () => pickDate(),
                            child: const Icon(
                              Icons.calendar_month,
                              color: Colors.black,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: primaryColor, width: 1.5),
                            borderRadius: BorderRadius.circular(AppSize.s20),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: primaryColor, width: 1.5),
                            borderRadius: BorderRadius.circular(AppSize.s20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: primaryColor, width: 1.5),
                            borderRadius: BorderRadius.circular(AppSize.s20),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red, width: 1.5),
                            borderRadius: BorderRadius.circular(AppSize.s20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: kDropDown(
                        dropdown: DropDown.repeat,
                        currentValue: currentRepeat,
                        list: repeats,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () => submitTask(),
                  child: const Text('Add a Task'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
