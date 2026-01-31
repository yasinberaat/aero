import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/aero_theme.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/models/work_task_model.dart';
import '../../widgets/theme_toggle_button.dart';

/// İş sayfası - Günlük/Haftalık/Aylık görevler
class WorkPage extends StatefulWidget {
  const WorkPage({super.key});

  @override
  State<WorkPage> createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  List<WorkTaskModel> _dailyTasks = [];
  List<WorkTaskModel> _weeklyTasks = [];
  List<WorkTaskModel> _monthlyTasks = [];
  
  final Map<String, List<WorkTaskModel>> _weeklyCalendar = {
    'Pazartesi': [],
    'Salı': [],
    'Çarşamba': [],
    'Perşembe': [],
    'Cuma': [],
    'Cumartesi': [],
    'Pazar': [],
  };

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }
  
  void _loadTasks() {
    final allTasks = StorageService.getAllWorkTasks();
    setState(() {
      _dailyTasks = allTasks.where((t) => t.type == TaskType.daily).toList();
      _weeklyTasks = allTasks.where((t) => t.type == TaskType.weekly).toList();
      _monthlyTasks = allTasks.where((t) => t.type == TaskType.monthly).toList();
      
      // Haftalık takvimi güncelle
      _weeklyCalendar.forEach((key, value) {
        value.clear();
      });
      
      for (var task in _dailyTasks) {
        if (task.day != null && _weeklyCalendar.containsKey(task.day)) {
          _weeklyCalendar[task.day]!.add(task);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İŞ'),
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
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? AeroColors.cardBorder
              : Colors.grey.shade300,
        ),
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
  Widget _buildDailyTaskItem(WorkTaskModel task) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Checkbox(
            value: task.isCompleted,
            onChanged: (value) async {
              final updatedTask = WorkTaskModel(
                id: task.id,
                title: task.title,
                type: task.type,
                isCompleted: value ?? false,
                deadline: task.deadline,
                day: task.day,
                priority: task.priority,
              );
              await StorageService.updateWorkTask(updatedTask);
              _loadTasks();
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
                    : null,
              ),
            ),
          ),
          if (task.day != null)
            Text(
              task.day!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          IconButton(
            icon: const Icon(Icons.delete, size: 20),
            onPressed: () async {
              await StorageService.deleteWorkTask(task.id);
              _loadTasks();
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
              height: 1,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade700
                        : Colors.grey.shade400,
                    width: 1,
                  ),
                ),
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
  Widget _buildDayColumn(String day, List<WorkTaskModel> tasks) {
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
              style: Theme.of(context).textTheme.bodySmall,
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
  
  /// Haftalık görevler listesi
  Widget _buildWeeklyTasksList() {
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
      child: Column(
        children: [
          ..._weeklyTasks.map((task) => _buildTaskItem(task)),
          
          InkWell(
            onTap: () {},
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
  
  /// Aylık görevler listesi
  Widget _buildMonthlyTasksList() {
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
      child: Column(
        children: [
          ..._monthlyTasks.map((task) => _buildTaskItem(task)),
          
          InkWell(
            onTap: () {},
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
  
  /// Genel görev item
  Widget _buildTaskItem(WorkTaskModel task) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Checkbox(
            value: task.isCompleted,
            onChanged: (value) async {
              final updatedTask = WorkTaskModel(
                id: task.id,
                title: task.title,
                type: task.type,
                isCompleted: value ?? false,
                deadline: task.deadline,
                day: task.day,
                priority: task.priority,
              );
              await StorageService.updateWorkTask(updatedTask);
              _loadTasks();
            },
          ),
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(
                decoration: task.isCompleted 
                    ? TextDecoration.lineThrough 
                    : null,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 20),
            onPressed: () async {
              await StorageService.deleteWorkTask(task.id);
              _loadTasks();
            },
          ),
        ],
      ),
    );
  }
  
  /// Eski periodic tasks listesi (kullanılmıyor)
  Widget _buildPeriodicTasksList() {
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
      child: Column(
        children: [
          // Eski kod - kullanılmıyor
          
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
  
  /// Haftalık görevler takvimi
  Widget _buildWeeklyTasksCalendar() {
    final weeklyTasks = _weeklyTasks;
    
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
      child: Column(
        children: [
          // Hafta günleri
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _weeklyCalendar.keys.map((day) {
              final dayTasks = weeklyTasks.where((t) => 
                t.deadline.weekday == _getDayNumber(day)
              ).toList();
              
              return Expanded(
                child: Column(
                  children: [
                    Text(
                      day.substring(0, 3),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...dayTasks.map((task) => Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(task.priority),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 8,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  
  /// Aylık görevler takvimi
  Widget _buildMonthlyTasksCalendar() {
    final monthlyTasks = _monthlyTasks;
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AeroColors.obsidianCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AeroColors.cardBorder),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: daysInMonth,
        itemBuilder: (context, index) {
          final day = index + 1;
          final dayTasks = monthlyTasks.where((t) => 
            t.deadline.day == day && 
            t.deadline.month == now.month
          ).toList();
          
          return Container(
            decoration: BoxDecoration(
              color: dayTasks.isNotEmpty 
                  ? _getPriorityColor(dayTasks.first.priority).withValues(alpha: 0.3)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: day == now.day 
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
                  fontWeight: day == now.day ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
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
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 11,
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
                // Eski kod - kullanılmıyor
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
    final selectedRepeatDays = <int>[];
    var repeatForever = false;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AeroColors.obsidianCard
              : Colors.white,
          title: const Text('Günlük Görev Ekle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  value: selectedDay,
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
                
                // Deadline ve Sürekli Tekrarla
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.access_time, size: 20),
                        title: Text(
                          deadline == null
                              ? 'Deadline Seç'
                              : DateFormat('HH:mm').format(deadline!),
                          style: const TextStyle(fontSize: 13),
                        ),
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          
                          if (time != null) {
                            setDialogState(() {
                              final now = DateTime.now();
                              deadline = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          }
                        },
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: repeatForever,
                          onChanged: (value) {
                            if (deadline == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Öncelikle deadline seçiniz'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              return;
                            }
                            setDialogState(() {
                              repeatForever = value ?? false;
                            });
                          },
                        ),
                        const Text(
                          'Sürekli\nTekrarla',
                          style: TextStyle(fontSize: 9),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Tekrarlama başlığı
                const Text(
                  'Tekrarlama',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                
                // Gün seçim chip'leri
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _buildDayChip('Pzt', 1, selectedRepeatDays, setDialogState),
                    _buildDayChip('Sal', 2, selectedRepeatDays, setDialogState),
                    _buildDayChip('Çar', 3, selectedRepeatDays, setDialogState),
                    _buildDayChip('Per', 4, selectedRepeatDays, setDialogState),
                    _buildDayChip('Cum', 5, selectedRepeatDays, setDialogState),
                    _buildDayChip('Cmt', 6, selectedRepeatDays, setDialogState),
                    _buildDayChip('Paz', 7, selectedRepeatDays, setDialogState),
                  ],
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
              onPressed: () async {
                final title = titleController.text.trim();
                if (title.isEmpty || deadline == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lütfen tüm alanları doldurun')),
                  );
                  return;
                }
                
                final task = WorkTaskModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: title,
                  type: TaskType.daily,
                  day: selectedDay,
                  deadline: deadline!,
                  repeatDays: selectedRepeatDays.isEmpty ? null : selectedRepeatDays,
                  repeatForever: repeatForever,
                );
                
                await StorageService.addWorkTask(task);
                _loadTasks();
                
                // Bildirim planla
                NotificationService().scheduleTaskReminder(
                  id: task.id.hashCode,
                  taskName: task.title,
                  deadline: task.deadline,
                );
                
                if (context.mounted) {
                  Navigator.pop(context);
                }
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
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AeroColors.obsidianCard
              : Colors.white,
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
                    final color = _getPriorityColor(priority);
                    return DropdownMenuItem(
                      value: priority,
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(_getPriorityText(priority)),
                        ],
                      ),
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
                
                // Eski kod - kullanılmıyor
                setState(() {
                  // _weeklyMonthlyTasks.add(task);
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
  
  int _getDayNumber(String dayName) {
    final days = _weeklyCalendar.keys.toList();
    return days.indexOf(dayName) + 1;
  }
  
  Color _getPriorityColor(TaskPriority? priority) {
    if (priority == null) return Colors.grey;
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
  
  String _getPriorityText(TaskPriority? priority) {
    if (priority == null) return 'Bilinmiyor';
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
  
  /// Gün seçim chip'i
  Widget _buildDayChip(
    String label,
    int dayNumber,
    List<int> selectedDays,
    StateSetter setDialogState,
  ) {
    final isSelected = selectedDays.contains(dayNumber);
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setDialogState(() {
          if (selected) {
            selectedDays.add(dayNumber);
          } else {
            selectedDays.remove(dayNumber);
          }
        });
      },
      selectedColor: AeroColors.electricBlue,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : null,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
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
