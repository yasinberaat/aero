import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/aero_theme.dart';
import '../../core/models/category_model.dart';
import '../../widgets/theme_toggle_button.dart';

/// Özel kategori sayfası - Basit to-do sistemi
class CategoryPage extends StatefulWidget {
  final CategoryModel category;
  
  const CategoryPage({super.key, required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final List<TodoTask> _tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name.toUpperCase()),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GÖREVLER',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 16),
            
            _buildTasksList(),
          ],
        ),
      ),
    );
  }
  
  /// Görevler listesi
  Widget _buildTasksList() {
    final activeTasks = _tasks.where((t) => !t.isCompleted).toList();
    final completedTasks = _tasks.where((t) => t.isCompleted).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Aktif görevler
        Container(
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
              ...activeTasks.map((task) => _buildTaskItem(task)),
              
              // Ekle butonu
              InkWell(
                onTap: _showAddTaskDialog,
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
        ),
        
        // Tamamlanan görevler (varsa)
        if (completedTasks.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'TAMAMLANANLAR',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 16),
          Container(
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
              children: completedTasks.map((task) => _buildTaskItem(task)).toList(),
            ),
          ),
        ],
      ],
    );
  }
  
  /// Görev item
  Widget _buildTaskItem(TodoTask task) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
                if (task.deadline != null)
                  Text(
                    'Deadline: ${DateFormat('dd/MM/yyyy HH:mm').format(task.deadline!)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 20),
            onPressed: () {
              setState(() {
                _tasks.remove(task);
              });
            },
          ),
        ],
      ),
    );
  }
  
  /// Görev ekleme dialog'u
  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    DateTime? deadline;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AeroColors.obsidianCard
              : Colors.white,
          title: const Text('Görev Ekle'),
          content: Column(
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
              
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.access_time),
                title: Text(
                  deadline == null
                      ? 'Deadline Seç (Opsiyonel)'
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
                if (title.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lütfen görev adı girin')),
                  );
                  return;
                }
                
                setState(() {
                  _tasks.add(
                    TodoTask(
                      title: title,
                      deadline: deadline,
                    ),
                  );
                });
                
                Navigator.pop(context);
              },
              child: const Text('Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Basit to-do task modeli
class TodoTask {
  final String title;
  final DateTime? deadline;
  bool isCompleted;
  
  TodoTask({
    required this.title,
    this.deadline,
    this.isCompleted = false,
  });
}
