import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/home_page.dart';
import 'services/local_storage.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent)
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final savedTheme = await LocalStorage.loadTheme();
    if (savedTheme != null) {
      setState(() {
        themeMode = ThemeMode.values.firstWhere((e) => e.name == savedTheme);
      });
    }
  }

  void toggleTheme() {
    setState(() {
      themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
    LocalStorage.saveTheme(themeMode.name);
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1E88E5); // Blue Professional

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Counter One',
      themeMode: themeMode,
      
      // --- LIGHT THEME ---
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF2F5F8),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFF2F5F8)),
        // cardTheme dihapus agar kompatibel
      ),

      // --- DARK THEME ---
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
          surface: const Color(0xFF1A1C1E),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF121212)),
      ),
      
      home: CounterPage(
        toggleTheme: toggleTheme,
        isDarkMode: themeMode == ThemeMode.dark,
      ),
    );
  }
}