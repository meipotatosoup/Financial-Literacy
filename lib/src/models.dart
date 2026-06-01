class Position {
  String symbol;
  int quantity;
  double avgCost;
  double currentPrice;

  Position(this.symbol, this.quantity, this.avgCost, this.currentPrice);

  double get currentValue => quantity * currentPrice;
  double get gainLoss => (currentPrice - avgCost) * quantity;
  double get gainLossPct => ((currentPrice - avgCost) / avgCost) * 100;
}

class StockData {
  final String symbol;
  final String name;
  final double price;
  final double changePercent;
  final bool isUp;

  StockData(this.symbol, this.name, this.price, this.changePercent, this.isUp);
}

class LessonProgress {
  final String title;
  final String category;
  final int progress;
  final int xpReward;
  final String emoji;

  LessonProgress(this.title, this.category, this.progress, this.xpReward, this.emoji);
}
