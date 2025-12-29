import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/course.dart';
import '../widgets/custom_button.dart';
import '../widgets/lesson_tile.dart';

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        bool isInCart = appState.cart.contains(course);
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            // Course Image Header
            Stack(
              children: [
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(course.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 48,
                  left: 16,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    course.title,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Rating and Hours
                  Row(
                    children: [
                      const Icon(Icons.star, color: Color(0xFFF2B705), size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '⭐ ${course.rating}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time, color: Colors.black54, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${course.totalHours} Hours',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Price
                  Text(
                    'Rp. ${course.price.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFA8C686),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Description
                  Text(
                    'Course Description',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    course.description,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Instructor
                  Text(
                    'Instructor',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage('assets/images/instructor.jpg'),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        course.instructor,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Lessons
                  Text(
                    'Course Content',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: course.lessons.length,
                    itemBuilder: (context, index) {
                      return LessonTile(
                        lesson: course.lessons[index],
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/lesson',
                            arguments: course.lessons[index],
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: isInCart ? 'Remove from Chart' : 'Add to Chart',
                          onPressed: () {
                            if (isInCart) {
                              appState.removeFromCart(course);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Removed from chart')),
                              );
                            } else {
                              appState.addToCart(course);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Added to chart')),
                              );
                            }
                          },
                          backgroundColor: Colors.white,
                          textColor: const Color(0xFF3E5C6E),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          if (appState.wishlist.contains(course)) {
                            appState.removeFromWishlist(course);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Removed from wishlist')),
                            );
                          } else {
                            appState.addToWishlist(course);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Added to wishlist')),
                            );
                          }
                        },
                        icon: Icon(
                          appState.wishlist.contains(course)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: appState.wishlist.contains(course)
                              ? Colors.red
                              : Colors.grey,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.all(12),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomButton(
                          text: 'Pay',
                          onPressed: () {
                            Navigator.pushNamed(context, '/payment');
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
      },
    );
  }
}