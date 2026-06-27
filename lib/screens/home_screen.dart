import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../models/scam.dart';
import '../services/firestore_service.dart';
import 'recovery_screen.dart';
import 'knowledge_center_screen.dart';

/// Home Screen — Scam Feed (PRD Chapter 8.1 + Chapter 10.1)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Scam>> _scamsFuture;

  @override
  void initState() {
    super.initState();
    _scamsFuture = FirestoreService.fetchScams();
  }

  Future<void> _refresh() async {
    setState(() {
      _scamsFuture = FirestoreService.fetchScams();
    });
    await _scamsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _Header(),
              const SizedBox(height: 20),
              _EmergencyButton(),
              const SizedBox(height: 24),
              Text('Latest Scam Feed', style: AppTextStyles.h3),
              const SizedBox(height: 12),
              FutureBuilder<List<Scam>>(
                future: _scamsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          'Kuch gadbad ho gayi.\nNeeche kheech ke phir try karo.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMuted,
                        ),
                      ),
                    );
                  }
                  final scams = snapshot.data ?? [];
                  if (scams.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text('Abhi koi scam entry nahi hai.', style: AppTextStyles.bodyMuted),
                      ),
                    );
                  }
                  return Column(
                    children: scams
                        .map((scam) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _ScamCard(scam: scam),
                            ))
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _BottomNav(),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Namaste 👋', style: AppTextStyles.bodyMuted),
              Text('Wordnity', style: AppTextStyles.h2),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

class _EmergencyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RecoveryScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Text('Mere Saath Fraud Ho Gaya', style: AppTextStyles.button),
          ],
        ),
      ),
    );
  }
}

class _ScamCard extends StatefulWidget {
  final Scam scam;
  const _ScamCard({required this.scam});

  @override
  State<_ScamCard> createState() => _ScamCardState();
}

class _ScamCardState extends State<_ScamCard> {
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    final scam = widget.scam;
    final riskColor = AppColors.riskColor(scam.riskLevel);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Image header (Instagram-post style) ----
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 10,
                child: Image.network(
                  scam.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: AppColors.bgMuted,
                      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    );
                  },
                  errorBuilder: (context, error, stack) => Container(
                    color: AppColors.bgMuted,
                    child: Icon(Icons.image_not_supported_outlined, color: AppColors.textFaint),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: riskColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    scam.riskLevel,
                    style: AppTextStyles.label.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

          // ---- Content ----
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(scam.category, style: AppTextStyles.label.copyWith(color: AppColors.brand)),
                const SizedBox(height: 4),
                Text(scam.title, style: AppTextStyles.cardTitle),
                const SizedBox(height: 8),
                Text(
                  scam.description,
                  style: AppTextStyles.bodyMuted,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // ---- Action row (like/save/share — social-post style) ----
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 16, 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.thumb_up_outlined, size: 21),
                  color: AppColors.textFaint,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.share_outlined, size: 21),
                  color: AppColors.textFaint,
                  onPressed: () {},
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    size: 21,
                  ),
                  color: isSaved ? AppColors.brand : AppColors.textFaint,
                  onPressed: () => setState(() => isSaved = !isSaved),
                ),
                TextButton(
                  onPressed: () => _showDetail(context, scam),
                  child: Text('Learn More',
                      style: AppTextStyles.cardTitle.copyWith(color: AppColors.brand)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, Scam scam) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(scam.title, style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Text(scam.description, style: AppTextStyles.body),
            const SizedBox(height: 16),
            Text('Prevention Steps', style: AppTextStyles.cardTitle),
            const SizedBox(height: 8),
            ...scam.preventionTips.map(
              (tip) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle, size: 18, color: AppColors.success),
                    const SizedBox(width: 8),
                    Expanded(child: Text(tip, style: AppTextStyles.body)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (i) {
        if (i == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const KnowledgeCenterScreen()),
          );
        } else if (i != 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Coming soon')),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'Learn'),
        BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: 'Alerts'),
        BottomNavigationBarItem(icon: Icon(Icons.family_restroom), label: 'Family'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}
