import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/aero_theme.dart';
import 'core/services/storage_service.dart';
import 'core/services/notification_service.dart';
import 'core/providers/finance_provider.dart';
import 'core/providers/category_provider.dart';
import 'core/providers/theme_provider.dart';
import 'features/home/home_page.dart';

/// Ana giriş noktası - Hive servisini başlatır
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Hive storage'ı başlat
  await StorageService.init();
  
  // Initialize notifications
  await NotificationService().initialize();
  
  runApp(const AeroApp());
}

/// Ana uygulama widget'ı - Provider'ları ve tema'yı yapılandırır
class AeroApp extends StatelessWidget {
  const AeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FinanceProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Forge',
            themeMode: themeProvider.themeMode,
            theme: AeroTheme.lightTheme,
            darkTheme: AeroTheme.darkTheme,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
