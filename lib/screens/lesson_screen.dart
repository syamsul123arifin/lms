import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import '../models/lesson.dart';
import '../widgets/lesson_tile.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;

  const LessonScreen({super.key, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoUpdate);
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo() async {
    final videoUrl = widget.lesson.videoUrl.isNotEmpty ? widget.lesson.videoUrl : 'assets/images/video_placeholder.mp4';
    _controller = VideoPlayerController.asset(videoUrl);
    await _controller!.initialize();
    _controller!.addListener(_onVideoUpdate);
    setState(() {
      _isInitialized = true;
    });
  }

  void _onVideoUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          'Pelajaran', // Translated to Indonesian
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player
            _isInitialized && _controller != null
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        VideoPlayer(_controller!),
                        // Play button overlay
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_controller!.value.isPlaying) {
                                _controller!.pause();
                              } else {
                                _controller!.play();
                              }
                            });
                          },
                          icon: Icon(
                            _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                        // Progress bar
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: _controller!.value.position.inSeconds / (_controller!.value.duration.inSeconds == 0 ? 1 : _controller!.value.duration.inSeconds),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFA8C686),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(25),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
            const SizedBox(height: 24),
            // Lesson Title
            Text(
              widget.lesson.title,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            // Lesson Duration
            Text(
              '${widget.lesson.duration} minutes',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            // Lesson Description
            Text(
              'Deskripsi Pelajaran',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.lesson.description,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black54,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            // Progress Indicator
            Text(
              'Kemajuan Anda',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kemajuan Pelajaran',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '${(_controller != null ? (_controller!.value.position.inSeconds / (_controller!.value.duration.inSeconds == 0 ? 1 : _controller!.value.duration.inSeconds) * 100).toInt() : 0)}%',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFA8C686),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: _controller != null ? _controller!.value.position.inSeconds / (_controller!.value.duration.inSeconds == 0 ? 1 : _controller!.value.duration.inSeconds) : 0.0,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFA8C686),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Lesson List (simplified)
            Text(
              'Pelajaran Kursus',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            // Dummy lessons for demonstration
            LessonTile(
              lesson: widget.lesson,
              onTap: () {
                // Already on this lesson
              },
            ),
            LessonTile(
              lesson: Lesson(
                id: '2',
                title: 'Tools Web Developer',
                description: 'Essential tools for web development',
                duration: 15,
                videoUrl: 'assets/images/video_placeholder.mp4',
                status: LessonStatus.notStarted,
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LessonScreen(
                      lesson: Lesson(
                        id: '2',
                        title: 'Tools Web Developer',
                        description: 'Essential tools for web development',
                        duration: 15,
                        videoUrl: 'assets/images/video_placeholder.mp4',
                        status: LessonStatus.notStarted,
                      ),
                    ),
                  ),
                );
              },
            ),
            LessonTile(
              lesson: Lesson(
                id: '3',
                title: 'Installation',
                description: 'Installing development tools',
                duration: 20,
                videoUrl: 'assets/images/video_placeholder.mp4',
                status: LessonStatus.notStarted,
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LessonScreen(
                      lesson: Lesson(
                        id: '3',
                        title: 'Installation',
                        description: 'Installing development tools',
                        duration: 20,
                        videoUrl: 'assets/images/video_placeholder.mp4',
                        status: LessonStatus.notStarted,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}