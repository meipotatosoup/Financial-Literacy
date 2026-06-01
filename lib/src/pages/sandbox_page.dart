import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models.dart';
import '../widgets/shared_widgets.dart';

class SandboxPage extends StatefulWidget {
  final AppState appState;
  const SandboxPage({super.key, required this.appState});

  @override
  State<SandboxPage> createState() => _SandboxPageState();
}

class _SandboxPageState extends State<SandboxPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  StockData? _selectedStock;
  int _tradeQty = 1;
  bool _isBuying = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedStock = widget.appState.watchlist.first;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = widget.appState;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildPortfolioSummary(appState)),
          SliverToBoxAdapter(child: _buildTabBar()),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 600,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTradingPanel(appState),
                  _buildPortfolioPanel(appState),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 16, 20, 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Paper Trading', style: TextStyle(color: Colors.white54, fontSize: 14)),
              const Text(
                'Sandbox',
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF00D4AA).withAlpha(26),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF00D4AA).withAlpha(77)),
            ),
            child: const Text(
              'DEMO MODE',
              style: TextStyle(
                color: Color(0xFF00D4AA),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioSummary(AppState appState) {
    final totalValue = appState.totalPortfolioValue;
    final initialValue = 10000.0;
    final gain = totalValue - initialValue;
    final gainPct = (gain / initialValue) * 100;
    final isPositive = gain >= 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Portfolio', style: TextStyle(color: Colors.white38, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(
                    '\$${totalValue.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isPositive
                          ? const Color(0xFF00D4AA).withAlpha(26)
                          : const Color(0xFFFF4D6D).withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${isPositive ? '+' : ''}\$${gain.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: isPositive ? const Color(0xFF00D4AA) : const Color(0xFFFF4D6D),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${isPositive ? '+' : ''}${gainPct.toStringAsFixed(2)}% all time',
                    style: TextStyle(
                      color: isPositive ? const Color(0xFF00D4AA) : const Color(0xFFFF4D6D),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _SummaryChip('💵 Cash', '\$${appState.cashBalance.toStringAsFixed(0)}'),
              const SizedBox(width: 10),
              _SummaryChip('📦 Positions', '${appState.positions.length}'),
              const SizedBox(width: 10),
              _SummaryChip('🏆 Rank', '#${appState.leaderboardRank}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFF00D4AA),
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.white54,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Trade'),
          Tab(text: 'Portfolio'),
        ],
      ),
    );
  }

  Widget _buildTradingPanel(AppState appState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Select Stock'),
          const SizedBox(height: 10),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: appState.watchlist.length,
              itemBuilder: (ctx, i) {
                final s = appState.watchlist[i];
                final isSelected = _selectedStock?.symbol == s.symbol;
                return GestureDetector(
                  onTap: () => setState(() => _selectedStock = s),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF00D4AA) : const Color(0xFF1A2535),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        s.symbol,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white70,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_selectedStock != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedStock!.name,
                          style: TextStyle(color: Colors.white54, fontSize: 13),
                        ),
                        Text(
                          '\$${_selectedStock!.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _selectedStock!.isUp
                          ? const Color(0xFF00D4AA).withAlpha(26)
                          : const Color(0xFFFF4D6D).withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_selectedStock!.isUp ? '+' : ''}${_selectedStock!.changePercent.toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: _selectedStock!.isUp
                            ? const Color(0xFF00D4AA)
                            : const Color(0xFFFF4D6D),
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isBuying = true),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: _isBuying ? const Color(0xFF00D4AA) : const Color(0xFF1A2535),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'BUY',
                          style: TextStyle(
                            color: _isBuying ? Colors.black : Colors.white54,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isBuying = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: !_isBuying ? const Color(0xFFFF4D6D) : const Color(0xFF1A2535),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'SELL',
                          style: TextStyle(
                            color: !_isBuying ? Colors.white : Colors.white54,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quantity', style: TextStyle(color: Colors.white54, fontSize: 13)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _QtyButton(
                        icon: Icons.remove,
                        onTap: () {
                          if (_tradeQty > 1) setState(() => _tradeQty--);
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            '$_tradeQty',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      _QtyButton(
                        icon: Icons.add,
                        onTap: () => setState(() => _tradeQty++),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Cost', style: TextStyle(color: Colors.white38, fontSize: 13)),
                      Text(
                        '\$${(_tradeQty * _selectedStock!.price).toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                if (_isBuying) {
                  appState.buyStock(_selectedStock!.symbol, _tradeQty, _selectedStock!.price);
                } else {
                  appState.sellStock(_selectedStock!.symbol, _tradeQty, _selectedStock!.price);
                }
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${_isBuying ? 'Bought' : 'Sold'} $_tradeQty share(s) of ${_selectedStock!.symbol}! +${_isBuying ? 20 : 15} XP',
                    ),
                    backgroundColor: _isBuying ? const Color(0xFF00D4AA) : const Color(0xFFFF4D6D),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _isBuying ? const Color(0xFF00D4AA) : const Color(0xFFFF4D6D),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    '${_isBuying ? 'Buy' : 'Sell'} $_tradeQty Share${_tradeQty > 1 ? 's' : ''}',
                    style: TextStyle(
                      color: _isBuying ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPortfolioPanel(AppState appState) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (appState.positions.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  const Text('📭', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text(
                    'No positions yet',
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                  Text(
                    'Go trade something!',
                    style: TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                ],
              ),
            ),
          )
        else
          ...appState.positions.map((p) => _PositionCard(position: p)),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryChip(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2535),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: Colors.white38, fontSize: 11)),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF1A2535),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _PositionCard extends StatelessWidget {
  final Position position;
  const _PositionCard({required this.position});

  @override
  Widget build(BuildContext context) {
    final isGain = position.gainLoss >= 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: isGain ? const Color(0xFF00D4AA) : const Color(0xFFFF4D6D),
            width: 3,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  position.symbol,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${position.quantity} shares @ \$${position.avgCost.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${position.currentValue.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              Text(
                '${isGain ? '+' : ''}\$${position.gainLoss.toStringAsFixed(2)} (${position.gainLossPct.toStringAsFixed(1)}%)',
                style: TextStyle(
                  color: isGain ? const Color(0xFF00D4AA) : const Color(0xFFFF4D6D),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
