
# 💰 FinQuest — Gamified Finance Learning App

A full Flutter app with 4 animated tab pages for learning how financial markets work.

## 🚀 Quick Start

```bash
# 1. Create a new Flutter project
flutter create finquest
cd finquest

# 2. Replace lib/main.dart with the provided main.dart
# 3. Replace pubspec.yaml with the provided pubspec.yaml

# 4. Run it
flutter pub get
run without debugging
```

## 📱 Pages & Features

### 🏠 Home
- XP level progress bar with gradient card
- Daily streak fire banner with call-to-action
- Horizontal market overview ticker (live sparklines)
- Continue Learning section for in-progress lessons
- Quick action buttons (Trade, Quiz, Leaderboard, News)
- Coins & streak count in top bar

### 📊 Sandbox (Paper Trading)
- Portfolio value card showing total, gain/loss & rank
- Buy / Sell toggle with animated selection
- Stock picker carousel
- Quantity adjuster (+/−)
- Real-time cost calculation
- Portfolio tab showing open positions with P&L
- +XP reward on every trade (gamified!)
- SnackBar confirmation with XP gain

### 📚 Lessons
- Daily Challenge banner with bonus XP
- Category filter chips (All / Basics / Technical / etc.)
- Lesson cards with:
  - Progress bar for in-progress
  - Lock icon for locked
  - Check icon for completed
  - XP reward display

### 👤 Profile
- Avatar, level, XP bar
- 4-stat grid: streak, total XP, completed lessons, rank
- Weekly streak calendar (fire emojis per day)
- Leaderboard preview with your position highlighted
- Badges section (earned vs locked)
- Achievements with progress bars

## 🎨 Design System
- Background: `#0A0E1A` (deep navy)
- Cards: `#111827`
- Accent: `#00D4AA` (teal-green)
- Danger: `#FF4D6D` (red)
- Fire: `#FF6B35` (orange)
- Purple: `#7B61FF`
- All animations use `AnimatedContainer` + `AnimatedSwitcher`

## 💡 Next Steps to Extend
- Add `Provider` or `Riverpod` for real state management
- Connect to a real stock API (e.g. Polygon.io)
- Add a quiz/flashcard engine in Lessons
- Implement real user auth + cloud sync
- Add push notifications for streak reminders
- Add charting with `fl_chart` package
- Add real news feed with RSS parsing
