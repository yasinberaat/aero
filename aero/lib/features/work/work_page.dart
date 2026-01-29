import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/aero_theme.dart';
import '../../core/services/notification_service.dart';
import '../../widgets/theme_toggle_button.dart';

enum TaskPriority { veryImportant, important, moderate, unimportant }

/// İş / Emlak sayfası - Günlük/Haftalık/Aylık görevler
class WorkPage extends StatefulWidget {
  const WorkPage({super.key});

  @override
  State<WorkPage> createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  final List<DailyTask> _dailyTasks = [];
  final List<PeriodicTask> _weeklyMonthlyTasks = [];
  
  final Map<String, List<DailyTask>> _weeklyCalendar = {
    'Pazartesi': [],
    'Salı': [],
    'Çarşamba': [],
    'Perşembe': [],
    'Cuma': [],
    'Cumartesi': [],
    'Pazar': [],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İŞ / EMLAK'),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Günlük görevler bölümü
            Text(
              'GÜNLÜK GÖREVLER',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 16),
            
            // To-do listesi (max 10)
            _buildDailyTasksList(),
            
            const SizedBox(height: 24),
            
            // Haftalık takvim
            _buildWeeklyCalendar(),
            
            const SizedBox(height: 32),
            
            // Haftalık/Aylık görevler
            Text(
              'HAFTALIK / AYLIK GÖREVLER',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 16),
            
            _buildPeriodicTasksList(),
          ],
        ),
      ),
    );
  }
  
  /// Günlük görevler listesi (max 10 + ekle butonu)
  Widget _buildDailyTasksList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AeroColors.obsidianCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AeroColors.cardBorder),
      ),
      child: Column(
        children: [
          // Mevcut görevler
          ..._dailyTasks.take(10).map((task) => _buildDailyTaskItem(task)),
          
          // Boş görev slotları (5'e kadar göster)
          if (_dailyTasks.length < 5)
            ...List.generate(
              5 - _dailyTasks.length,
              (index) => _buildEmptyTaskSlot(),
            ),
          
          // Ekle butonu
          if (_dailyTasks.length < 10)
            InkWell(
              onTap: _showAddDailyTaskDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: AeroColors.electricBlue),
                    const SizedBox(width: 8),
                    Text(
                      'Görev Ekle',
                      style: TextStyle(color: AeroColors.electricBlue),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  /// Günlük görev item
  Widget _buildDailyTaskItem(DailyTask task) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Checkbox(
            value: task.isCompleted,
            onChanged: (value) {
              setState(() {
                task.isCompleted = value ?? false;
              });
            },
          ),
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(
                decoration: task.isCompleted 
                    ? TextDecoration.lineThrough 
                    : null,
                color: task.isCompleted 
                    ? Colors.grey 
                    : Colors.white,
              ),
            ),
          ),
          Text(
            task.day,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 20),
            onPressed: () {
              setState(() {
                _dailyTasks.remove(task);
                _weeklyCalendar[task.day]?.remove(task);
              });
            },
          ),
        ],
      ),
    );
  }
  
  /// Boş görev slotu
  Widget _buildEmptyTaskSlot() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Checkbox(value: false, onChanged: null),
          Expanded(
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Haftalık takvim (yatay)
  Widget _buildWeeklyCalendar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AeroColors.obsidianCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AeroColors.cardBorder),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _weeklyCalendar.entries.map((entry) {
            final day = entry.key;
            final tasks = entry.value;
            final isLastDay = day == 'Pazar';
            
            return Row(
              children: [
                _buildDayColumn(day, tasks),
                if (!isLastDay)
                  Container(
                    width: 1,
                    height: 150,
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
  
  /// Günlük kolon
  Widget _buildDayColumn(String day, List<DailyTask> tasks) {
    return SizedBox(
      width: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          if (tasks.isEmpty)
            Text(
              'Boş',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            )
          else
            ...tasks.map((task) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: task.isCompleted 
                      ? Colors.green.shade700 
                      : Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: task.isCompleted 
                        ? Colors.green 
                        : Colors.transparent,
                  ),
                ),
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 11,
                    color: task.isCompleted ? Colors.white : Colors.grey.shade400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )),
        ],
      ),
    );
  }
  
  /// Haftalık/Aylık görevler listesi
  Widget _buildPeriodicTasksList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AeroColors.obsidianCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AeroColors.cardBorder),
      ),
      child: Column(
        children: [
          ..._weeklyMonthlyTasks.map((task) => _buildPeriodicTaskItem(task)),
          
          // Ekle butonu
          InkWell(
            onTap: _showAddPeriodicTaskDialog,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: AeroColors.electricBlue),
                  const SizedBox(width: 8),
                  Text(
                    'Görev Ekle',
                    style: TextStyle(color: AeroColors.electricBlue),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Haftalık/Aylık görev item
  Widget _buildPeriodicTaskItem(PeriodicTask task) {
    final priorityColor = _getPriorityColor(task.priority);
    final priorityText = _getPriorityText(task.priority);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: priorityColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: priorityColor),
        ),
        child: Row(
          children: [
            Checkbox(
              value: task.isCompleted,
              onChanged: (value) {
                setState(() {
                  task.isCompleted = value ?? false;
                });
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: task.isCompleted 
                          ? TextDecoration.lineThrough 
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: priorityColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          priorityText,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${task.type} • ${DateFormat('dd/MM/yyyy HH:mm').format(task.deadline)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: () {
                setState(() {
                  _weeklyMonthlyTasks.remove(task);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
  
  /// Günlük görev ekleme dialog'u
  void _showAddDailyTaskDialog() {
    final titleController = TextEditingController();
    String selectedDay = _getCurrentDayName();
    DateTime? deadline;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AeroColors.obsidianCard,
          title: const Text('Günlük Görev Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Görev',
                  hintText: 'Örn: 5 FSBO',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              
              DropdownButtonFormField<String>(
                initialValue: selectedDay,
                decoration: const InputDecoration(
                  labelText: 'Gün',
                  border: OutlineInputBorder(),
                ),
                items: _weeklyCalendar.keys.map((day) {
                  return DropdownMenuItem(value: day, child: Text(day));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() => selectedDay = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.access_time),
                title: Text(
                  deadline == null
                      ? 'Deadline Seç'
                      : DateFormat('dd/MM/yyyy HH:mm').format(deadline!),
                  style: const TextStyle(fontSize: 14),
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  
                  if (date != null && context.mounted) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    
                    if (time != null) {
                      setDialogState(() {
                        deadline = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  }
                },
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
                final title = titleController.text.trim();
                if (title.isEmpty || deadline == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lütfen tüm alanları doldurun')),
                  );
                  return;
                }
                
                final task = DailyTask(
                  title: title,
                  day: selectedDay,
                  deadline: deadline!,
                );
                
                setState(() {
                  _dailyTasks.add(task);
                  _weeklyCalendar[selectedDay]!.add(task);
                });
                
                // Bildirim planla
                NotificationService().scheduleTaskReminder(
                  id: task.hashCode,
                  taskName: task.title,
                  deadline: task.deadline,
                );
                
                Navigator.pop(context);
              },
              child: const Text('Ekle'),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Haftalık/Aylık görev ekleme dialog'u
  void _showAddPeriodicTaskDialog() {
    final titleController = TextEditingController();
    String selectedType = 'Haftalık';
    TaskPriority selectedPriority = TaskPriority.moderate;
    DateTime? deadline;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AeroColors.obsidianCard,
          title: const Text('Haftalık/Aylık Görev Ekle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Görev',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                
                DropdownButtonFormField<String>(
                  initialValue: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Tür',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Haftalık', 'Aylık'].map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => selectedType = value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                
                DropdownButtonFormField<TaskPriority>(
                  initialValue: selectedPriority,
                  decoration: const InputDecoration(
                    labelText: 'Önem Derecesi',
                    border: OutlineInputBorder(),
                  ),
                  items: TaskPriority.values.map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Text(_getPriorityText(priority)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => selectedPriority = value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.access_time),
                  title: Text(
                    deadline == null
                        ? 'Deadline Seç'
                        : DateFormat('dd/MM/yyyy HH:mm').format(deadline!),
                    style: const TextStyle(fontSize: 14),
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    
                    if (date != null && context.mounted) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      
                      if (time != null) {
                        setDialogState(() {
                          deadline = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                if (title.isEmpty || deadline == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lütfen tüm alanları doldurun')),
                  );
                  return;
                }
                
                final task = PeriodicTask(
                  title: title,
                  type: selectedType,
                  priority: selectedPriority,
                  deadline: deadline!,
                );
                
                setState(() {
                  _weeklyMonthlyTasks.add(task);
                });
                
                // Bildirim planla
                NotificationService().scheduleTaskReminder(
                  id: task.hashCode,
                  taskName: task.title,
                  deadline: task.deadline,
                );
                
                Navigator.pop(context);
              },
              child: const Text('Ekle'),
            ),
          ],
        ),
      ),
    );
  }
  
  String _getCurrentDayName() {
    final weekday = DateTime.now().weekday;
    const days = [
      'Pazartesi',
      'Salı',
      'Çarşamba',
      'Perşembe',
      'Cuma',
      'Cumartesi',
      'Pazar',
    ];
    return days[weekday - 1];
  }
  
  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.veryImportant:
        return Colors.red;
      case TaskPriority.important:
        return Colors.orange;
      case TaskPriority.moderate:
        return Colors.yellow.shade700;
      case TaskPriority.unimportant:
        return Colors.grey;
    }
  }
  
  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.veryImportant:
        return 'Çok Önemli';
      case TaskPriority.important:
        return 'Önemli';
      case TaskPriority.moderate:
        return 'Eh İşte';
      case TaskPriority.unimportant:
        return 'Önemsiz';
    }
  }
}

/// Günlük görev modeli
class DailyTask {
  final String title;
  final String day;
  final DateTime deadline;
  bool isCompleted;
  
  DailyTask({
    required this.title,
    required this.day,
    required this.deadline,
    this.isCompleted = false,
  });
}

/// Haftalık/Aylık görev modeli
class PeriodicTask {
  final String title;
  final String type; // Haftalık veya Aylık
  final TaskPriority priority;
  final DateTime deadline;
  bool isCompleted;
  
  PeriodicTask({
    required this.title,
    required this.type,
    required this.priority,
    required this.deadline,
    this.isCompleted = false,
  });
}
