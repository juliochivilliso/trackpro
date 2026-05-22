import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/design_system/hud_theme.dart';
import 'data/providers/fleet_provider.dart';
import 'data/providers/auth_provider.dart';
import 'features/tracking/dashboard_screen.dart';
import 'features/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FleetProvider()),
      ],
      child: const AntiGravityApp(),
    ),
  );
}

class AntiGravityApp extends StatelessWidget {
  const AntiGravityApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AntiGravity GPS',
      theme: buildHudTheme(),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: context.read<AuthProvider>().init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Color(0xFF0A0A0F),
              body: Center(
                child: CircularProgressIndicator(color: Colors.blue),
              ),
            );
          }
          
          return Consumer<AuthProvider>(
            builder: (context, auth, _) {
              return auth.isLoggedIn ? const DashboardScreen() : const LoginScreen();
            },
          );
        },
      ),
    );
  }
}
