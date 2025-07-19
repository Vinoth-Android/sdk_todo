import 'package:get/get.dart';
import '../views/add_todo_screen.dart';
import '../views/edit_todo_screen.dart';
import '../views/onboarding_screen.dart';
import '../views/home_screen.dart';
import '../views/splash_screen.dart';

class XRoutes {
  XRoutes._();
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String addTodo = '/add-todo';
  static const String editTodo = '/edit-todo';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: onboarding, page: () => OnboardingScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: addTodo, page: () => const AddTodoScreen()),
    GetPage(name: editTodo, page: () => EditTodoScreen(todo: Get.arguments)),
  ];
}
