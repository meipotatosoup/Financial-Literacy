import 'package:flutter/material.dart';

import 'models.dart';

class AppState extends ChangeNotifier {
  int xp = 1240;
  int level = 7;
  int streak = 14;
  int coins = 500;
  double cashBalance = 4250.0;
  int leaderboardRank = 23;
  List<Position> positions = [];
  List<StockData> watchlist = [];
  List<LessonProgress> lessons = [];

  AppState() {
    _initData();
  }

  void _initData() {
    positions = [
      Position('AAPL', 5, 178.50, 185.20),
      Position('TSLA', 2, 245.00, 238.75),
      Position('MSFT', 3, 380.00, 402.10),
    ];
    watchlist = [
      StockData('AAPL', 'Apple Inc.', 185.20, 2.3, true),
      StockData('TSLA', 'Tesla Inc.', 238.75, -1.8, false),
      StockData('MSFT', 'Microsoft', 402.10, 3.1, true),
      StockData('GOOGL', 'Alphabet', 141.50, 0.9, true),
      StockData('AMZN', 'Amazon', 178.25, -0.4, false),
      StockData('NVDA', 'NVIDIA', 875.40, 5.2, true),
    ];
    lessons = [
      LessonProgress('Stocks 101', 'Basics', 100, 5, '🏦'),
      LessonProgress('Reading Charts', 'Technical', 60, 4, '📈'),
      LessonProgress('P/E Ratios', 'Fundamentals', 30, 3, '🔢'),
      LessonProgress('ETFs & Funds', 'Diversification', 0, 4, '🌐'),
      LessonProgress('Options Basics', 'Advanced', 0, 5, '⚡'),
    ];
  }

  void buyStock(String symbol, int qty, double price) {
    final cost = qty * price;
    if (cashBalance >= cost) {
      cashBalance -= cost;
      final idx = positions.indexWhere((p) => p.symbol == symbol);
      if (idx >= 0) {
        positions[idx].quantity += qty;
      } else {
        final stock = watchlist.firstWhere((s) => s.symbol == symbol);
        positions.add(Position(symbol, qty, price, stock.price));
      }
      xp += 20;
      notifyListeners();
    }
  }

  void sellStock(String symbol, int qty, double price) {
    final idx = positions.indexWhere((p) => p.symbol == symbol);
    if (idx >= 0 && positions[idx].quantity >= qty) {
      positions[idx].quantity -= qty;
      cashBalance += qty * price;
      if (positions[idx].quantity == 0) {
        positions.removeAt(idx);
      }
      xp += 15;
      notifyListeners();
    }
  }

  int get xpToNextLevel => level * 300;
  double get xpProgress => (xp % xpToNextLevel) / xpToNextLevel;
  double get totalPortfolioValue => cashBalance + positions.fold(0.0, (sum, p) => sum + p.currentValue);
}
