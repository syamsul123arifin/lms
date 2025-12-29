import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
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
          useMaterial3: true,
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFF3E5C6E),
            onPrimary: Colors.white,
            secondary: Color(0xFFA8C686),
            onSecondary: Colors.black,
            tertiary: Color(0xFFF2B705),
            onTertiary: Colors.black,
            error: Colors.red,
            onError: Colors.white,
            surface: Color(0xFFFFFFFF),
            onSurface: Colors.black,
          ),
          scaffoldBackgroundColor: const Color(0xFFFFFFFF),
          fontFamily: GoogleFonts.poppins().fontFamily,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFA8C686),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Color(0xFF3E5C6E), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
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
  final List<Course> _cart = [];
  final List<Course> _purchasedCourses = [];
  final List<Course> _wishlist = [];

  User? get currentUser => _currentUser;
  List<Course> get courses => _courses;
  List<Course> get cart => _cart;
  List<Course> get purchasedCourses => _purchasedCourses;
  List<Course> get wishlist => _wishlist;

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void setCourses(List<Course> courses) {
    _courses = courses;
    notifyListeners();
  }

  Future<void> loadCourses() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/courses.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      _courses = jsonList.map((json) => Course.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      // Handle error
      debugPrint('Error loading courses: $e');
    }
  }

  void addToCart(Course course) {
    if (!_cart.contains(course)) {
      _cart.add(course);
      notifyListeners();
    }
  }

  void removeFromCart(Course course) {
    _cart.remove(course);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void addToWishlist(Course course) {
    if (!_wishlist.contains(course)) {
      _wishlist.add(course);
      notifyListeners();
    }
  }

  void removeFromWishlist(Course course) {
    _wishlist.remove(course);
    notifyListeners();
  }

  void purchaseCourses() {
    _purchasedCourses.addAll(_cart);
    _cart.clear();
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _cart.clear();
    _purchasedCourses.clear();
    _wishlist.clear();
    notifyListeners();
  }
}
