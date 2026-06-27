import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'theme/app_colors.dart';
import 'theme/app_text_styles.dart';

// Firebase imports — uncomment once firebase_options.dart is generated
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const WordnityApp());
}

class WordnityApp extends StatelessWidget {
  const WordnityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordnity',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const _SetupCheckScreen(),
    );
  }
}

/// Temporary placeholder — confirms build pipeline + design system work.
/// Replaced by real Home Screen in the next step (Scam Feed).
class _SetupCheckScreen extends StatelessWidget {
  const _SetupCheckScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wordnity', style: AppTextStyles.h3)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shield_outlined, size: 64, color: AppColors.brand),
              const SizedBox(height: 16),
              Text('Har Ghar Cyber Surakshit', style: AppTextStyles.h2, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('Build pipeline working ✅\nScam Feed next.',
                  style: AppTextStyles.bodyMuted, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
