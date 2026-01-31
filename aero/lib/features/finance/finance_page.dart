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
                
                const SizedBox(height: 24),
                
                // Takvim (günlük harcama detayları) - Yukarı taşındı
                _buildCalendar(context),
                
                const SizedBox(height: 24),
                
                // Daily Summary (gelir + harcamalar)
                _buildDailySummary(context, totalIncome, expensesByCategory),
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
  
  /// Günlük kar/zarar ve haftalık kar/zarar göstergesi
  Widget _buildPercentageChange(double currentExpenses) {
    final financeProvider = context.watch<FinanceProvider>();
    final dailyProfit = financeProvider.getDailyProfit();
    final weeklyProfit = financeProvider.getWeeklyProfit();
    
    return Column(
      children: [
        // Günlük kar/zarar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: dailyProfit >= 0 
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: dailyProfit >= 0 ? Colors.green : Colors.red,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                dailyProfit >= 0 ? Icons.trending_up : Icons.trending_down,
                color: dailyProfit >= 0 ? Colors.green : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bugün',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '₺${dailyProfit.abs().toStringAsFixed(0)}',
                    style: TextStyle(
                      color: dailyProfit >= 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Text(
                dailyProfit >= 0 ? 'KAR' : 'ZARAR',
                style: TextStyle(
                  color: dailyProfit >= 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Haftalık kar/zarar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Bu Hafta: ',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '₺${weeklyProfit.abs().toStringAsFixed(0)}',
                style: TextStyle(
                  color: weeklyProfit >= 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                weeklyProfit >= 0 ? 'KAR' : 'ZARAR',
                style: TextStyle(
                  color: weeklyProfit >= 0 ? Colors.green : Colors.red,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  /// Haftalık takvim widget'ı (Pazartesi-Pazar) - Kompakt versiyon
  Widget _buildCalendar(BuildContext context) {
    final financeProvider = context.watch<FinanceProvider>();
    final now = DateTime.now();
    
    // Bu haftanın Pazartesi'sini bul
    final weekday = now.weekday; // 1=Pazartesi, 7=Pazar
    final monday = now.subtract(Duration(days: weekday - 1));
    
    // Haftanın 7 gününü oluştur
    final weekDays = List.generate(7, (index) => monday.add(Duration(days: index)));
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BU HAFTA',
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AeroColors.cardBorder
                  : Colors.grey.shade300,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays.map((date) {
              final isToday = date.year == now.year && 
                              date.month == now.month && 
                              date.day == now.day;
              final isPast = date.isBefore(now) && !isToday;
              final isFuture = date.isAfter(now);
              
              // Geçmiş günler için kar/zarar hesapla
              final profit = isPast ? financeProvider.getProfitForDate(date) : 0.0;
              
              // Renk belirleme
              Color? bgColor;
              if (isPast) {
                bgColor = profit >= 0 
                    ? Colors.green.withValues(alpha: 0.3)
                    : Colors.red.withValues(alpha: 0.3);
              } else if (isFuture) {
                bgColor = Colors.transparent;
              }
              
              // Gün adı (Pzt, Sal, vb.)
              const dayNames = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
              final dayName = dayNames[date.weekday - 1];
              
              return GestureDetector(
                onTap: isPast ? () => _showAddExpenseForDateDialog(context, date) : null,
                child: Container(
                  width: 38,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isToday 
                          ? AeroColors.electricBlue 
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        dayName,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: isToday 
                              ? AeroColors.electricBlue
                              : (isFuture ? Colors.grey : null),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isFuture ? Colors.grey : null,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
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
    final profit = totalIncome - totalExpenses; // Kar/Zarar = Gelir - Gider
    
    // Veri yoksa gri grafik göster
    if (totalIncome == 0 && totalExpenses == 0) {
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
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade700
                        : Colors.grey.shade400,
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
                  '₺${profit.abs().toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: profit >= 0 ? Colors.green : Colors.red,
                  ),
                ),
                Text(
                  profit >= 0 ? 'KAR' : 'ZARAR',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: profit >= 0 ? Colors.green : Colors.red,
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
  
  /// Günlük özet (gelir + kategori bazlı harcamalar) - detaylı liste
  Widget _buildDailySummary(
    BuildContext context,
    double totalIncome,
    Map<String, double> expensesByCategory,
  ) {
    final financeProvider = context.watch<FinanceProvider>();
    final incomes = financeProvider.getTodayIncome();
    final expenses = financeProvider.getTodayExpenses();
    
    if (incomes.isEmpty && expenses.isEmpty) {
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
        
        // Gelir listesi
        ...incomes.map((income) => Padding(
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Gelir'),
                    if (income.note != null && income.note!.isNotEmpty)
                      Text(
                        income.note!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              Text(
                '₺${income.amount.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AeroColors.incomeGreen,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 18),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Theme.of(context).brightness == Brightness.dark
                          ? AeroColors.obsidianCard
                          : Colors.white,
                      title: const Text('Geliri Sil'),
                      content: const Text('Bu gelir kaydını silmek istediğinize emin misiniz?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('İptal'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                          child: const Text('Sil'),
                        ),
                      ],
                    ),
                  );
                  
                  if (confirm == true) {
                    await financeProvider.deleteIncome(income.id);
                  }
                },
              ),
            ],
          ),
        )),
        
        // Harcama listesi
        ...expenses.map((expense) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: ExpenseCategories.getColor(expense.category),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(expense.category),
                    if (expense.note != null && expense.note!.isNotEmpty)
                      Text(
                        expense.note!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              Text(
                '₺${expense.amount.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 18),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Theme.of(context).brightness == Brightness.dark
                          ? AeroColors.obsidianCard
                          : Colors.white,
                      title: const Text('Harcamayı Sil'),
                      content: const Text('Bu harcama kaydını silmek istediğinize emin misiniz?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('İptal'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                          child: const Text('Sil'),
                        ),
                      ],
                    ),
                  );
                  
                  if (confirm == true) {
                    await financeProvider.deleteExpense(expense.id);
                  }
                },
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
  
  /// Belirli bir tarih için harcama ekleme dialog'u
  void _showAddExpenseForDateDialog(BuildContext context, DateTime selectedDate) {
    showDialog(
      context: context,
      builder: (_) => AddExpenseDialog(selectedDate: selectedDate),
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
