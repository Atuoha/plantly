import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../business_logic/plant/plant_cubit.dart';
import '../../../business_logic/task/task_cubit.dart';
import '../../../constants/color.dart';
import '../../../constants/enums/drop_down.dart';
import '../../../constants/enums/fields.dart';
import '../../../constants/enums/process_status.dart';
import '../../../models/plant.dart';
import '../../../models/success.dart';
import '../../../models/task.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../../resources/values_manager.dart';
import '../../widgets/cool_alert.dart';
import '../../widgets/loading.dart';
import '../../widgets/plant_task_text_field.dart';
import '../../widgets/success_dialog.dart';

class EditTask extends StatefulWidget {
  const EditTask({Key? key, required this.task}) : super(key: key);
  final DocumentSnapshot task;

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController plantController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController repeatController = TextEditingController();
  DateTime date = DateTime.now();

  var currentPlant = '';
  List<Plant> plants = const [];

  var currentRepeat = '';
  final repeats = [
    'Once a day',
    'Every week',
    'Once a month',
    'Others',
  ];

  retrievePlants() async {
    await context.read<PlantCubit>().fetchPlants();
  }

  void setDetails() {
    setState(() {
      titleController.text = widget.task['title'];
      descriptionController.text = widget.task['description'];
      currentPlant = widget.task['plantId'];
      currentRepeat = widget.task['repeat'];
      date = widget.task['date'].toDate();
    });
  }

  @override
  void initState() {
    retrievePlants();
    setDetails();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      currentRepeat = repeats[0];
      plants = context.read<PlantCubit>().state.plants;
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

    var userId = FirebaseAuth.instance.currentUser!.uid;

    final Task task = Task(
      id: DateTime.now().toString(),
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      plantId: plants.firstWhere((plant) => plant.title == currentPlant).title,
      date: date,
      repeat: currentRepeat,
      userId: userId,
    );
    model.editTask(task: task, id: widget.task.id);
  }

  // reset from
  void resetForm() {
    setState(() {
      titleController.clear();
      descriptionController.clear();
      dateController.clear();
    });
    Navigator.of(context).pop();
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
                  showDialog(
                    context: context,
                    builder: (context) => const LoadingWidget(),
                  );
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
