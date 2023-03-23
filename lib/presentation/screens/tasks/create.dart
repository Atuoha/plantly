import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantly/models/task.dart';
import '../../../business_logic/plant/plant_cubit.dart';
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
import 'package:uuid/uuid.dart';

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
  final GlobalKey<State<StatefulWidget>> _dialogKey = GlobalKey();
  var uuid = const Uuid();

  var currentPlant = '';
  List<Plant> plants = const [];
  bool isProcessing = false;
  bool isSubmitBtnPressed = false;

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
      plants = context.read<PlantCubit>().state.plants;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      currentRepeat = repeats[0];
      currentPlant = plants[0].title;
    });
    super.didChangeDependencies();
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
        dateController.text =
            DateTime(pickedDate.year, pickedDate.month, pickedDate.day)
                .toString();
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

  // reset from
  void resetForm() {
    setState(() {
      titleController.clear();
      descriptionController.clear();
      dateController.clear();
      isProcessing = false;
      isSubmitBtnPressed = false;
    });
    Navigator.of(context).pop();
  }

  void submitTask() {
    final model = context.read<TaskCubit>();
    FocusScope.of(context).unfocus();
    var valid = formKey.currentState!.validate();

    if (!valid) {
      return;
    }

    setState(() {
      isSubmitBtnPressed = true;
    });

    var userId = FirebaseAuth.instance.currentUser!.uid;

    final Task task = Task(
      id: uuid.v4(),
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      plantId: plants.firstWhere((plant) => plant.title == currentPlant).id,
      date: date,
      repeat: currentRepeat,
      userId: userId,
    );
    model.addTask(task: task);
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
        child: SingleChildScrollView(
          child: BlocListener<TaskCubit, TaskState>(
            listener: (context, state) {
              if (state.status == ProcessStatus.loading) {
                setState(() {
                  isProcessing = true;
                });
              } else if (state.status == ProcessStatus.success) {
                kCoolAlert(
                  message: '${titleController.text} successfully added!',
                  context: context,
                  alert: CoolAlertType.success,
                  action: resetForm,
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
            child: !isProcessing
                ? Form(
                    key: formKey,
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
                                    borderRadius:
                                        BorderRadius.circular(AppSize.s20),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: primaryColor, width: 1.5),
                                    borderRadius:
                                        BorderRadius.circular(AppSize.s20),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: primaryColor, width: 1.5),
                                    borderRadius:
                                        BorderRadius.circular(AppSize.s20),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 1.5),
                                    borderRadius:
                                        BorderRadius.circular(AppSize.s20),
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
                          onPressed: () =>
                              !isSubmitBtnPressed ? submitTask() : null,
                          child: Text(
                            isSubmitBtnPressed ? 'Loading...' : 'Add a Task',
                          ),
                        )
                      ],
                    ),
                  )
                : const Center(child: LoadingWidget(size: 50)),
          ),
        ),
      ),
    );
  }
}
