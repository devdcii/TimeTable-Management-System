import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'providers/auth_provider.dart';
import 'providers/schedule_provider.dart';
import './providers/task_provider.dart';
import 'screens/splash_screen.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Open Hive boxes
  await Hive.openBox(HiveBoxNames.userBox);
  await Hive.openBox(HiveBoxNames.scheduleBox);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()), // Add this
      ],
      child: const CupertinoApp(
        title: 'Timetable Manager',
        theme: CupertinoThemeData(
          primaryColor: CupertinoColors.activeBlue,
          brightness: Brightness.light,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}