import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/home_screen.dart';
import 'screens/course_detail_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/lesson_screen.dart';
import 'screens/profile_screen.dart';
import 'models/course.dart';
import 'models/lesson.dart';
import 'models/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: MaterialApp(
        title: 'SpaceLearn',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF1E3A8A),
          scaffoldBackgroundColor: const Color(0xFFF8F9FA),
          fontFamily: GoogleFonts.poppins().fontFamily,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A8A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
            ),
          ),
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/signin': (context) => const SignInScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/home': (context) => const HomeScreen(),
          '/course-detail': (context) => CourseDetailScreen(
                course: ModalRoute.of(context)!.settings.arguments as Course,
              ),
          '/payment': (context) => const PaymentScreen(),
          '/lesson': (context) => LessonScreen(
                lesson: ModalRoute.of(context)!.settings.arguments as Lesson,
              ),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  User? _currentUser;
  List<Course> _courses = [];

  User? get currentUser => _currentUser;
  List<Course> get courses => _courses;

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void setCourses(List<Course> courses) {
    _courses = courses;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
