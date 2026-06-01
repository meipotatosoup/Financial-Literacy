import 'dart:math';

import 'package:flutter/material.dart';

import '../app_state.dart';
import '../widgets/shared_widgets.dart';

class ProfilePage extends StatelessWidget {
  final AppState appState;
  const ProfilePage({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _ProfileHeader(appState: appState)),
          SliverToBoxAdapter(child: _StatsGrid(appState: appState)),
          SliverToBoxAdapter(child: _StreakCalendar(appState: appState)),
          SliverToBoxAdapter(child: _LeaderboardPreview(appState: appState)),
          SliverToBoxAdapter(child: _BadgesSection()),
          SliverToBoxAdapter(child: _AchievementsSection()),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final AppState appState;
  const _ProfileHeader({required this.appState});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 16, 20, 20),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your Progress', style: TextStyle(color: Colors.white54, fontSize: 14)),
                  const Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Icon(Icons.settings_rounded, color: Colors.white38, size: 24),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00D4AA), Color(0xFF0099FF)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('👤', style: TextStyle(fontSize: 32)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'FinQuest User',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text('Level ${appState.level} Investor', style: const TextStyle(color: Color(0xFF00D4AA), fontSize: 13)),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: appState.xpProgress,
                        backgroundColor: Colors.white12,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00D4AA)),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('${appState.xp} XP total', style: TextStyle(color: Colors.white38, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final AppState appState;
  const _StatsGrid({required this.appState});

  @override
  Widget build(BuildContext context) {
    final stats = [
      _Stat('🔥', '${appState.streak}', 'Day Streak'),
      _Stat('⭐', '${appState.xp}', 'Total XP'),
      _Stat('📚', '${appState.lessons.where((l) => l.progress == 100).length}', 'Completed'),
      _Stat('🏆', '#${appState.leaderboardRank}', 'Rank'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        childAspectRatio: 0.85,
        children: stats.map((s) => _StatCard(stat: s)).toList(),
      ),
    );
  }
}

class _Stat {
  final String icon;
  final String value;
  final String label;
  const _Stat(this.icon, this.value, this.label);
}

class _StatCard extends StatelessWidget {
  final _Stat stat;
  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(stat.icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 6),
          Text(
            stat.value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            stat.label,
            style: TextStyle(color: Colors.white38, fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StreakCalendar extends StatelessWidget {
  final AppState appState;
  const _StreakCalendar({required this.appState});

  @override
  Widget build(BuildContext context) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final today = DateTime.now().weekday - 1;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SectionTitle('🔥 This Week'),
              const Spacer(),
              Text(
                '${appState.streak} day streak!',
                style: const TextStyle(color: Color(0xFFFF6B35), fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (i) {
              final isActive = i <= today;
              final isToday = i == today;
              return Column(
                children: [
                  Text(
                    days[i],
                    style: TextStyle(
                      color: isToday ? const Color(0xFFFF6B35) : Colors.white38,
                      fontSize: 12,
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isActive
                          ? (isToday ? const Color(0xFFFF6B35) : const Color(0xFFFF6B35).withAlpha(77))
                          : const Color(0xFF1A2535),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        isActive ? '🔥' : '○',
                        style: TextStyle(
                          fontSize: isActive ? 16 : 12,
                          color: Colors.white38,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardPreview extends StatelessWidget {
  final AppState appState;
  const _LeaderboardPreview({required this.appState});

  @override
  Widget build(BuildContext context) {
    final leaders = [
      _Leader('🥇', 'CryptoKing', 4580, 1),
      _Leader('🥈', 'StockNinja', 3910, 2),
      _Leader('🥉', 'BullRunner', 3240, 3),
      _Leader('👤', 'You', appState.xp, appState.leaderboardRank),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('🏆 Leaderboard'),
          const SizedBox(height: 14),
          ...leaders.map((l) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Text(l.medal, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Text(
                      '#${l.rank}',
                      style: TextStyle(color: Colors.white38, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l.name,
                        style: TextStyle(
                          color: l.name == 'You' ? const Color(0xFF00D4AA) : Colors.white,
                          fontWeight: l.name == 'You' ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      '${l.xp} XP',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _Leader {
  final String medal;
  final String name;
  final int xp;
  final int rank;
  const _Leader(this.medal, this.name, this.xp, this.rank);
}

class _BadgesSection extends StatelessWidget {
  const _BadgesSection();

  static const badges = [
    ['🎯', 'First Trade'],
    ['📚', 'Scholar'],
    ['🔥', 'On Fire'],
    ['💰', 'Profit'],
    ['⚡', 'Speed Run'],
    ['🌟', 'Star'],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('🏅 Badges Earned'),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(badges.length, (i) {
              final isEarned = i < 4;
              return Column(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: isEarned
                          ? const Color(0xFFFFB800).withAlpha(38)
                          : const Color(0xFF1A2535),
                      shape: BoxShape.circle,
                      border: isEarned
                          ? Border.all(color: const Color(0xFFFFB800).withAlpha(102))
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        isEarned ? badges[i][0] : '🔒',
                        style: TextStyle(fontSize: isEarned ? 24 : 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    badges[i][1],
                    style: TextStyle(
                      color: isEarned ? Colors.white60 : Colors.white24,
                      fontSize: 9,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _AchievementsSection extends StatelessWidget {
  const _AchievementsSection();

  @override
  Widget build(BuildContext context) {
    final achievements = [
      _Achievement('Complete 5 lessons', 5, 5, '📚'),
      _Achievement('Make first trade', 1, 1, '📈'),
      _Achievement('7-day streak', 7, 14, '🔥'),
      _Achievement('Earn 1000 XP', 1000, 1240, '⭐'),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('🎖️ Achievements'),
          const SizedBox(height: 14),
          ...achievements.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(a.emoji, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(a.title, style: const TextStyle(color: Colors.white, fontSize: 13)),
                                  Text(
                                    '${min(a.current, a.goal)}/${a.goal}',
                                    style: TextStyle(color: Colors.white38, fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: min(1.0, a.current / a.goal),
                                  backgroundColor: Colors.white12,
                                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFB800)),
                                  minHeight: 5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _Achievement {
  final String title;
  final int goal;
  final int current;
  final String emoji;
  const _Achievement(this.title, this.goal, this.current, this.emoji);
}
