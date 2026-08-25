// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/driver_home_screen.dart';
import 'screens/student_transportation_screen.dart';
import 'screens/parent_dashboard_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enforce status bar styling and orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ThemeControllerWrapper(child: MyApp()));
}

/// InheritedWidget for global ThemeMode state management
class ThemeControllerWrapper extends StatefulWidget {
  final Widget child;

  const ThemeControllerWrapper({super.key, required this.child});

  static _ThemeControllerWrapperState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_ThemeControllerScope>()!
        .data;
  }

  @override
  State<ThemeControllerWrapper> createState() => _ThemeControllerWrapperState();
}

class _ThemeControllerWrapperState extends State<ThemeControllerWrapper> {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      setState(() {
        _themeMode = mode;
      });
    }
  }

  void toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _ThemeControllerScope(
      data: this,
      child: widget.child,
    );
  }
}

class _ThemeControllerScope extends InheritedWidget {
  final _ThemeControllerWrapperState data;

  const _ThemeControllerScope({
    required this.data,
    required super.child,
  });

  @override
  bool updateShouldNotify(_ThemeControllerScope oldWidget) => true;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeControllerWrapper.of(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NC Shuttle Transport',

      // Theme Setup
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.themeMode,

      // Navigation & Routes
      home: const NavigationWrapper(),
      onGenerateRoute: (settings) {
        // Reserved for sub-routes like QR Scanner, Student Details, or Settings
        return MaterialPageRoute(
          builder: (context) => const NavigationWrapper(),
        );
      },
    );
  }
}

class NavigationWrapper extends StatefulWidget {
  const NavigationWrapper({super.key});

  @override
  State<NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DriverHomeScreen(),
    StudentTransportationScreen(),
    ParentDashboardScreen(),
    ReportsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black38 : Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          height: 65,
          elevation: 0,
          backgroundColor: Colors.transparent,
          indicatorColor: theme.colorScheme.primary.withOpacity(0.12),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.directions_bus_outlined),
              selectedIcon: Icon(Icons.directions_bus_rounded),
              label: 'Transport',
            ),
            NavigationDestination(
              icon: Icon(Icons.family_restroom_outlined),
              selectedIcon: Icon(Icons.family_restroom_rounded),
              label: 'Parent',
            ),
            NavigationDestination(
              icon: Badge(
                label: Text('2'),
                child: Icon(Icons.insert_chart_outlined),
              ),
              selectedIcon: Badge(
                label: Text('2'),
                child: Icon(Icons.insert_chart_rounded),
              ),
              label: 'Reports',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}