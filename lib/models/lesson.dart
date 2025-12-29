enum LessonStatus { notStarted, inProgress, completed }

class Lesson {
  final String id;
  final String title;
  final String description;
  final int duration; // in minutes
  final String videoUrl; // dummy
  final LessonStatus status;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.videoUrl,
    this.status = LessonStatus.notStarted,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      duration: json['duration'],
      videoUrl: json['videoUrl'],
      status: LessonStatus.values[json['status'] ?? 0],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'duration': duration,
      'videoUrl': videoUrl,
      'status': status.index,
    };
  }
}