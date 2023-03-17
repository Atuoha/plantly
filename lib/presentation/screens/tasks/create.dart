import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantly/models/task.dart';
import '../../../business_logic/task/task_cubit.dart';
import '../../../constants/color.dart';
import '../../../constants/enums/drop_down.dart';
import '../../../constants/enums/fields.dart';
import '../../../constants/enums/process_status.dart';
import '../../../models/plant.dart';
import '../../../models/success.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../../resources/values_manager.dart';
import '../../widgets/cool_alert.dart';
import '../../widgets/loading.dart';
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
  DateTime date = DateTime.now();

  var currentPlant = '';
  final List<Plant> plants = const [
    Plant(
      id: '1',
      title: 'Sun Flower',
      description: '',
      imgUrl: '',
      waterLevel: 0,
      sunLevel: 0,
    ),
    Plant(
      id: '1',
      title: 'Hibiscus',
      description: '',
      imgUrl: '',
      waterLevel: 0,
      sunLevel: 0,
    ),
    Plant(
      id: '1',
      title: 'Moon Flower',
      description: '',
      imgUrl: '',
      waterLevel: 0,
      sunLevel: 0,
    ),
    Plant(
      id: '1',
      title: 'Dove Flower',
      description: '',
      imgUrl: '',
      waterLevel: 0,
      sunLevel: 0,
    ),
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
      currentPlant = plants[0].title;
      currentRepeat = repeats[0];
    });
    super.initState();
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
        date = pickedDate;
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

  void submitTask() {
    final model = context.read<TaskCubit>();
    FocusScope.of(context).unfocus();
    var valid = formKey.currentState!.validate();

    if (!valid) {
      return;
    }
    final Task task = Task(
      id: DateTime.now().toString(),
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      plantId: plants.firstWhere((plant) => plant.title == currentPlant).title,
      date: date,
      repeat: currentRepeat,
    );
    model.addTask(task: task);

    print('Am herer');
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
            child: BlocListener<TaskCubit, TaskState>(
              listener: (context, state) {
                if (state.status == ProcessStatus.loading) {
                  const LoadingWidget();
                } else if (state.status == ProcessStatus.success) {
                  kCoolAlert(
                    message: '${titleController.text} successfully added!',
                    context: context,
                    alert: CoolAlertType.success,
                  );
                } else if (state.status == ProcessStatus.error) {
                  kCoolAlert(
                    message:
                        '${titleController.text} can not be added.\n ${state.error}!',
                    context: context,
                    alert: CoolAlertType.error,
                  );
                }
              },
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
                    list: plants.map((plant) => plant.title).toList(),
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
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 1.5),
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
      ),
    );
  }
}
