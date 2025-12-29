import 'lesson.dart';

class Course {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final double rating;
  final int totalHours;
  final int totalLessons;
  final double price;
  final String imageUrl;
  final List<String> categories;
  final List<Lesson> lessons;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.rating,
    required this.totalHours,
    required this.totalLessons,
    required this.price,
    required this.imageUrl,
    required this.categories,
    required this.lessons,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      instructor: json['instructor'],
      rating: json['rating'].toDouble(),
      totalHours: json['totalHours'],
      totalLessons: json['totalLessons'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      categories: List<String>.from(json['categories']),
      lessons: (json['lessons'] as List).map((l) => Lesson.fromJson(l)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructor': instructor,
      'rating': rating,
      'totalHours': totalHours,
      'totalLessons': totalLessons,
      'price': price,
      'imageUrl': imageUrl,
      'categories': categories,
      'lessons': lessons.map((l) => l.toJson()).toList(),
    };
  }
}