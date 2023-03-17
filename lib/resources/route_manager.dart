import '../presentation/presentation_export.dart';
import '../presentation/screens/main/bottom_navigation.dart';
import '../presentation/screens/plant/edit.dart';
import '../presentation/screens/tasks/edit.dart';

class RouteManager {
  // Entry and Main
  static const String entryScreen = "/entry_screen";
  static const String homeScreen = '/home_screen';

  // Splash
  static const String splashScreen = '/splash_screen';

  // Auth
  static const String authEntry = '/auth_entry';
  static const String authScreen = '/auth_screen';
  static const String forgotPasswordScreen = '/forgot_password_screen';
  static const String retrievePasswordScreen = '/retrieve_password_screen';

  // Plant
  static const String createPlantScreen = '/create_plant_screen';
  static const String editPlantScreen = '/edit_plant_screen';
  static const String filterPlantScreen = '/filter_plant_screen';
  static const String singlePlantViewScreen = '/single_plant_view_screen';
  static const String viewAllPlantsScreen = '/view_all_plants_screen';

  // Preferences
  static const String aboutScreen = '/about_screen';
  static const String helpScreen = '/help_screen';
  static const String languageScreen = '/language_screen';
  static const String notificationScreen = '/notification_screen';

  // Profile
  static const String profileScreen = '/profile_screen';
  static const String editProfileScreen = '/edit_profile_screen';

  // Scan
  static const String scanScreen = '/scan_screen';
  static const String scanEntryScreen = '/scan_entry_screen';
  static const String scanResultScreen = '/scan_result_screen';

  // Settings
  static const String settingsScreen = '/settings_screen';
  static const String editSettingsScreen = '/edit_settings_screen';

  // Task
  static const String createTaskScreen = '/create_task_screen';
  static const String editTaskScreen = '/edit_task_screen';
  static const String taskSingleViewScreen = '/task_single_view_screen';
  static const String viewAllTasks = '/view_all_tasks_screen';
}

final routes = {
  RouteManager.entryScreen: (context) => const EntryScreen(),
  RouteManager.homeScreen: (context) => const BottomNavigationScreen(),

  // Splash
  RouteManager.splashScreen: (context) => const SplashScreen(),

  // Auth
  RouteManager.authEntry: (context) => const AuthEntry(),
  RouteManager.authScreen: (context) => const AuthScreen(),
  RouteManager.forgotPasswordScreen: (context) => const ForgotPasswordScreen(),
  RouteManager.retrievePasswordScreen: (context) =>
      const RetrievePasswordScreen(),

  // Plant
  RouteManager.viewAllPlantsScreen: (context) => const ViewAllPlants(),
  RouteManager.singlePlantViewScreen: (context) => const SinglePlantScreen(),
  RouteManager.filterPlantScreen: (context) => const FilterPlant(),
  RouteManager.createPlantScreen: (context) => const CreatePlantScreen(),
  // RouteManager.editPlantScreen: (context) => const EditPlantScreen(),

  // Preferences
  RouteManager.aboutScreen: (context) => const AboutScreen(),
  RouteManager.helpScreen: (context) => const HelpScreen(),
  RouteManager.languageScreen: (context) => const LanguageScreen(),
  RouteManager.notificationScreen: (context) => const NotificationScreen(),

  // Profile
  RouteManager.editProfileScreen: (context) => const EditProfileScreen(),
  RouteManager.profileScreen: (context) => const ProfileScreen(),

  // Scan
  RouteManager.scanEntryScreen: (context) => const ScanEntry(),
  RouteManager.scanScreen: (context) => const ScanScreen(),
  RouteManager.scanResultScreen: (context) => const ScanResultScreen(),

  // Settings
  RouteManager.settingsScreen: (context) => const SettingsScreen(),
  RouteManager.editSettingsScreen: (context) => const EditSettingsScreen(),

  // Task
  RouteManager.viewAllTasks: (context) => const ViewAllTasks(),
  RouteManager.taskSingleViewScreen: (context) => const TaskSingleView(),
  RouteManager.createTaskScreen: (context) => const CreateTask(),
  // RouteManager.editTaskScreen: (context) => const EditTask(),
};
