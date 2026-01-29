import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/aero_theme.dart';
import '../../widgets/theme_toggle_button.dart';

/// Fitness / Spor sayfası - Haftalık antreman programı
class FitnessPage extends StatefulWidget {
  const FitnessPage({super.key});

  @override
  State<FitnessPage> createState() => _FitnessPageState();
}

class _FitnessPageState extends State<FitnessPage> {
  final _exerciseController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  String _selectedDay = 'Pazartesi';
  
  // Mock data - gerçek implementasyonda Hive kullanılacak
  final Map<String, List<WorkoutEntry>> _weeklyWorkouts = {
    'Pazartesi': [],
    'Salı': [],
    'Çarşamba': [],
    'Perşembe': [],
    'Cuma': [],
    'Cumartesi': [],
    'Pazar': [],
  };

  @override
  void dispose() {
    _exerciseController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SPOR'),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hareket giriş formu
            _buildWorkoutForm(),
            
            const SizedBox(height: 32),
            
            // Haftalık Antreman Programı başlığı
            Text(
              'HAFTALIK ANTREMAN PROGRAMI',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            
            const SizedBox(height: 16),
            
            // Haftalık takvim (7 gün)
            _buildWeeklyCalendar(),
          ],
        ),
      ),
    );
  }
  
  /// Hareket giriş formu
  Widget _buildWorkoutForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? AeroColors.cardBorder
              : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'YENİ HAREKET EKLE',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 16),
          
          // Hareket adı
          TextField(
            controller: _exerciseController,
            decoration: const InputDecoration(
              labelText: 'Hareket',
              hintText: 'Örn: Bench Press',
              border: OutlineInputBorder(),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Set ve Tekrar (yan yana)
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _setsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Set',
                    hintText: '3',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _repsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Tekrar',
                    hintText: '10',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Gün seçimi
          DropdownButtonFormField<String>(
            initialValue: _selectedDay,
            decoration: const InputDecoration(
              labelText: 'Gün',
              border: OutlineInputBorder(),
            ),
            items: _weeklyWorkouts.keys.map((day) {
              return DropdownMenuItem(value: day, child: Text(day));
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedDay = value);
              }
            },
          ),
          
          const SizedBox(height: 16),
          
          // Ekle butonu
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _addWorkout,
              child: const Text('EKLE'),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Haftalık takvim (yatay - soldan sağa)
  Widget _buildWeeklyCalendar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? AeroColors.cardBorder
              : Colors.grey.shade300,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _weeklyWorkouts.entries.map((entry) {
            final day = entry.key;
            final workouts = entry.value;
            final isLastDay = day == 'Pazar';
            
            return Row(
              children: [
                _buildDayColumn(day, workouts),
                if (!isLastDay)
                  Container(
                    width: 1,
                    height: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: AeroColors.cardBorder,
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
  
  /// Günlük kolon (dikey)
  Widget _buildDayColumn(String day, List<WorkoutEntry> workouts) {
    return SizedBox(
      width: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gün adı
          Text(
            day,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // Hareketler
          if (workouts.isEmpty)
            Text(
              'Boş',
              style: Theme.of(context).textTheme.bodySmall,
            )
          else
            ...workouts.map((workout) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildWorkoutChip(workout),
            )),
        ],
      ),
    );
  }
  
  /// Hareket chip'i (tıklanabilir, yorumlu ise yeşil)
  Widget _buildWorkoutChip(WorkoutEntry workout) {
    final hasComment = workout.comment != null;
    
    return GestureDetector(
      onTap: () => _showCommentDialog(workout),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: hasComment ? Colors.green.shade700 : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              workout.exercise,
              style: TextStyle(
                color: hasComment ? Colors.white : Colors.grey.shade400,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Text(
              '${workout.sets} × ${workout.reps}',
              style: TextStyle(
                color: hasComment ? Colors.white : Colors.grey.shade500,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Hareket ekleme
  void _addWorkout() {
    final exercise = _exerciseController.text.trim();
    final sets = int.tryParse(_setsController.text.trim());
    final reps = int.tryParse(_repsController.text.trim());
    
    if (exercise.isEmpty || sets == null || reps == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun')),
      );
      return;
    }
    
    setState(() {
      _weeklyWorkouts[_selectedDay]!.add(
        WorkoutEntry(
          exercise: exercise,
          sets: sets,
          reps: reps,
          day: _selectedDay,
        ),
      );
    });
    
    // Formu temizle
    _exerciseController.clear();
    _setsController.clear();
    _repsController.clear();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$exercise eklendi')),
    );
  }
  
  /// Yorum yazma dialog'u
  void _showCommentDialog(WorkoutEntry workout) {
    final commentController = TextEditingController(text: workout.comment ?? '');
    final now = DateTime.now();
    final dateStr = DateFormat('dd/MM/yyyy HH:mm').format(now);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AeroColors.obsidianCard
            : Colors.white,
        title: Text(workout.exercise),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarih/saat (sol üst, küçük, opak)
            Text(
              dateStr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 12),
            
            // Yorum alanı
            TextField(
              controller: commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Yorum Yaz',
                hintText: 'Bugün nasıl geçti? Kaç tekrar çıkardın?',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                workout.comment = commentController.text.trim();
                workout.commentDate = now;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Yorum kaydedildi')),
              );
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}

/// Workout entry model
class WorkoutEntry {
  final String exercise;
  final int sets;
  final int reps;
  final String day;
  String? comment;
  DateTime? commentDate;
  
  WorkoutEntry({
    required this.exercise,
    required this.sets,
    required this.reps,
    required this.day,
    this.comment,
    this.commentDate,
  });
}
