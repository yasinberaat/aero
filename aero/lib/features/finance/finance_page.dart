import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/aero_theme.dart';
import '../../core/providers/finance_provider.dart';
import '../../core/constants/expense_categories.dart';
import '../../widgets/theme_toggle_button.dart';
import 'widgets/add_expense_dialog.dart';
import 'widgets/add_income_dialog.dart';

enum TimeRange { day, week, month, threeMonths, sixMonths }

/// Finans sayfası - Donut chart + harcama/gelir giriş + günlük özet + takvim
class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  TimeRange _selectedRange = TimeRange.day;
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FİNANS'),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: Consumer<FinanceProvider>(
        builder: (context, financeProvider, child) {
          final totalIncome = financeProvider.getTotalIncome();
          final totalExpenses = financeProvider.getTotalExpenses();
          final expensesByCategory = financeProvider.getExpensesByCategory();
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Zaman aralığı sekmeleri
                _buildTimeRangeTabs(),
                
                const SizedBox(height: 24),
                
                // Donut Chart
                _buildDonutChart(totalIncome, totalExpenses, expensesByCategory),
                
                const SizedBox(height: 24),
                
                // Yüzdelik değişim göstergesi
                _buildPercentageChange(totalExpenses),
                
                const SizedBox(height: 32),
                
                // Harcama Gir Button (Büyük)
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: () => _showAddExpenseDialog(context),
                    child: const Text('HARCAMA GİR'),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Gelir Gir Button (1.5x küçük)
                SizedBox(
                  width: double.infinity * 0.67,
                  height: 42,
                  child: OutlinedButton(
                    onPressed: () => _showAddIncomeDialog(context),
                    child: const Text('GELİR GİR'),
                  ),
                ),
                
                const SizedBox(height: 50),
                
                // Daily Summary (gelir + harcamalar)
                _buildDailySummary(context, totalIncome, expensesByCategory),
                
                const SizedBox(height: 32),
                
                // Takvim (günlük harcama detayları)
                _buildCalendar(context),
              ],
            ),
          );
        },
      ),
    );
  }
  
  /// Zaman aralığı sekmeleri (1g/1h/1a/3a/6a)
  Widget _buildTimeRangeTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTimeRangeTab('1g', TimeRange.day),
        _buildTimeRangeTab('1h', TimeRange.week),
        _buildTimeRangeTab('1a', TimeRange.month),
        _buildTimeRangeTab('3a', TimeRange.threeMonths),
        _buildTimeRangeTab('6a', TimeRange.sixMonths),
      ],
    );
  }
  
  Widget _buildTimeRangeTab(String label, TimeRange range) {
    final isSelected = _selectedRange == range;
    return GestureDetector(
      onTap: () => setState(() => _selectedRange = range),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AeroColors.electricBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AeroColors.electricBlue : Colors.grey,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
  
  /// Yüzdelik değişim göstergesi (yeşil yukarı ok / kırmızı aşağı ok)
  Widget _buildPercentageChange(double currentExpenses) {
    // Veri yoksa sadece %0 göster, sembol yok
    if (currentExpenses == 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '%0',
          style: TextStyle(
            color: Colors.grey.shade400,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      );
    }
    
    // Mock data - gerçek implementasyonda önceki dönem verileriyle karşılaştır
    final double previousExpenses = 2000; // Örnek önceki dönem
    final double change = ((currentExpenses - previousExpenses) / previousExpenses) * 100;
    final bool isIncrease = change > 0;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
            color: isIncrease ? Colors.red : Colors.green,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '${change.abs().toStringAsFixed(1)}%',
            style: TextStyle(
              color: isIncrease ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isIncrease ? 'artış' : 'azalış',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Takvim widget'ı (günlük harcama detayları)
  Widget _buildCalendar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AYLIK ÖZET',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AeroColors.obsidianCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AeroColors.cardBorder),
          ),
          child: Column(
            children: [
              // Takvim başlığı (ay/yıl)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {},
                  ),
                  Text(
                    'Ocak 2026',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Takvim grid (7x5) - Kar/Zarar renklendirmesi
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: 35,
                itemBuilder: (context, index) {
                  final day = index + 1;
                  if (day > 31) {
                    return const SizedBox.shrink();
                  }
                  
                  // Mock data - gerçek implementasyonda o gün için gelir/harcama hesapla
                  // Şimdilik örnek: çift günler kar (gelir > harcama), tek günler zarar
                  final dayIncome = day % 2 == 0 ? 500.0 : 100.0;
                  final dayExpense = day % 2 == 0 ? 300.0 : 400.0;
                  final isProfit = dayIncome > dayExpense;
                  final hasTransaction = day % 3 != 0; // Her 3 günde bir işlem yok
                  
                  Color? bgColor;
                  if (hasTransaction) {
                    bgColor = isProfit 
                        ? Colors.green.withValues(alpha: 0.3)
                        : Colors.red.withValues(alpha: 0.3);
                  }
                  
                  final isToday = day == 29; // Mock bugün
                  
                  return Container(
                    decoration: BoxDecoration(
                      color: bgColor ?? Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isToday 
                            ? AeroColors.electricBlue 
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 12,
                          color: hasTransaction ? Colors.white : Colors.grey.shade600,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  /// Donut chart widget'ı (gelir yeşil + harcama kategorileri)
  Widget _buildDonutChart(
    double totalIncome,
    double totalExpenses,
    Map<String, double> expensesByCategory,
  ) {
    final total = totalIncome + totalExpenses;
    
    // Veri yoksa gri grafik göster
    if (total == 0) {
      return Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 220,
            height: 220,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: 1,
                    color: Colors.grey.shade700,
                    radius: 50,
                    showTitle: false,
                  ),
                ],
                sectionsSpace: 0,
                centerSpaceRadius: 70,
                startDegreeOffset: -90,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'BUGÜN',
                style: TextStyle(
                  color: AeroColors.textTertiary,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '₺0',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      );
    }
    
    final List<PieChartSectionData> sections = [];
    
    // Gelir (yeşil)
    if (totalIncome > 0) {
      sections.add(
        PieChartSectionData(
          value: totalIncome,
          color: AeroColors.incomeGreen,
          radius: 50,
          showTitle: false,
        ),
      );
    }
    
    // Harcama kategorileri
    expensesByCategory.forEach((category, amount) {
      sections.add(
        PieChartSectionData(
          value: amount,
          color: ExpenseCategories.getColor(category),
          radius: 50,
          showTitle: false,
        ),
      );
    });
    
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 220,
              height: 220,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  sectionsSpace: 2,
                  centerSpaceRadius: 70,
                  startDegreeOffset: -90,
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          _touchedIndex = -1;
                          return;
                        }
                        _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'BUGÜN',
                  style: TextStyle(
                    color: AeroColors.textTertiary,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₺${total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        // Tıklanan dilim detayı
        if (_touchedIndex >= 0 && _touchedIndex < sections.length)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: _buildTouchedSectionDetail(
              _touchedIndex,
              totalIncome,
              expensesByCategory,
            ),
          ),
      ],
    );
  }
  
  /// Günlük özet (gelir + kategori bazlı harcamalar)
  Widget _buildDailySummary(
    BuildContext context,
    double totalIncome,
    Map<String, double> expensesByCategory,
  ) {
    if (totalIncome == 0 && expensesByCategory.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GÜNLÜK ÖZET',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 16),
        
        // Gelir satırı
        if (totalIncome > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: AeroColors.incomeGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Gelir'),
                ),
                Text(
                  '₺${totalIncome.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AeroColors.incomeGreen,
                  ),
                ),
              ],
            ),
          ),
        
        // Harcama kategorileri
        ...expensesByCategory.entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: ExpenseCategories.getColor(entry.key),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entry.key,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Text(
                  '₺${entry.value.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )),
      ],
    );
  }
  
  void _showAddExpenseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const AddExpenseDialog(),
    );
  }
  
  void _showAddIncomeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const AddIncomeDialog(),
    );
  }

  /// Tıklanan dilim detayı
  Widget _buildTouchedSectionDetail(
    int index,
    double totalIncome,
    Map<String, double> expensesByCategory,
  ) {
    String categoryName;
    double amount;
    Color color;

    if (index == 0 && totalIncome > 0) {
      // İlk dilim gelir
      categoryName = 'Gelir';
      amount = totalIncome;
      color = AeroColors.incomeGreen;
    } else {
      // Harcama kategorisi
      final adjustedIndex = totalIncome > 0 ? index - 1 : index;
      final entries = expensesByCategory.entries.toList();
      if (adjustedIndex >= 0 && adjustedIndex < entries.length) {
        final entry = entries[adjustedIndex];
        categoryName = entry.key;
        amount = entry.value;
        color = ExpenseCategories.getColor(categoryName);
      } else {
        return const SizedBox.shrink();
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            categoryName,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '₺${amount.toStringAsFixed(0)}',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
