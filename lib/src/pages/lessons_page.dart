import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models.dart';
import '../widgets/shared_widgets.dart';

class LessonsPage extends StatefulWidget {
  final AppState appState;
  const LessonsPage({super.key, required this.appState});

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final appState = widget.appState;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Learn & Earn', style: TextStyle(color: Colors.white54, fontSize: 14)),
                  const Text(
                    'Lessons',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A0A2E), Color(0xFF0E1A35)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF7B61FF).withAlpha(102)),
              ),
              child: Row(
                children: [
                  const Text('⚡', style: TextStyle(fontSize: 36)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Daily Challenge',
                          style: TextStyle(
                            color: Color(0xFF7B61FF),
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text('What is a P/E Ratio?', style: TextStyle(color: Colors.white, fontSize: 14)),
                        Text('+50 XP bonus today', style: TextStyle(color: Colors.white54, fontSize: 12)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B61FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Start',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle('📋 All Lessons'),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: ['All', 'Basics', 'Technical', 'Fundamentals', 'Advanced']
                          .map((cat) => GestureDetector(
                                onTap: () => setState(() => _selectedCategory = cat),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: _selectedCategory == cat
                                        ? const Color(0xFF00D4AA)
                                        : const Color(0xFF1A2535),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Center(
                                    child: Text(
                                      cat,
                                      style: TextStyle(
                                        color: _selectedCategory == cat ? Colors.black : Colors.white60,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) {
                final lesson = appState.lessons[i];
                if (_selectedCategory != 'All' && lesson.category != _selectedCategory) {
                  return const SizedBox.shrink();
                }
                return _FullLessonCard(lesson: lesson, index: i);
              },
              childCount: appState.lessons.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _FullLessonCard extends StatelessWidget {
  final LessonProgress lesson;
  final int index;
  const _FullLessonCard({required this.lesson, required this.index});

  @override
  Widget build(BuildContext context) {
    final isComplete = lesson.progress == 100;
    final isLocked = index > 0 && lesson.progress == 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
        border: isComplete ? Border.all(color: const Color(0xFF00D4AA).withAlpha(77)) : null,
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isLocked ? const Color(0xFF1A2535) : const Color(0xFF00D4AA).withAlpha(26),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    isLocked ? '🔒' : lesson.emoji,
                    style: const TextStyle(fontSize: 26),
                  ),
                ),
              ),
              if (isComplete)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00D4AA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, size: 12, color: Colors.black),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        lesson.title,
                        style: TextStyle(
                          color: isLocked ? Colors.white38 : Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A2535),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '+${lesson.xpReward * 100} XP',
                        style: const TextStyle(
                          color: Color(0xFF00D4AA),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(lesson.category, style: TextStyle(color: Colors.white38, fontSize: 12)),
                if (lesson.progress > 0 && lesson.progress < 100) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: lesson.progress / 100,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00D4AA)),
                      minHeight: 4,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          Icon(
            isComplete
                ? Icons.check_circle_rounded
                : isLocked
                    ? Icons.lock_rounded
                    : Icons.play_circle_rounded,
            color: isComplete
                ? const Color(0xFF00D4AA)
                : isLocked
                    ? Colors.white12
                    : const Color(0xFF0099FF),
            size: 28,
          ),
        ],
      ),
    );
  }
}
