import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../models/scam.dart';

/// Home Screen — Scam Feed (PRD Chapter 8.1 + Chapter 10.1)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Header(),
            const SizedBox(height: 20),
            _EmergencyButton(),
            const SizedBox(height: 24),
            Text('Latest Scam Feed', style: AppTextStyles.h3),
            const SizedBox(height: 12),
            ...dummyScams.map((scam) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ScamCard(scam: scam),
                )),
          ],
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recovery Center — coming next')),
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

class _ScamCard extends StatelessWidget {
  final Scam scam;
  const _ScamCard({required this.scam});

  @override
  Widget build(BuildContext context) {
    final riskColor = AppColors.riskColor(scam.riskLevel);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(scam.title, style: AppTextStyles.cardTitle)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: riskColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    scam.riskLevel,
                    style: AppTextStyles.label.copyWith(color: riskColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(scam.category, style: AppTextStyles.label),
            const SizedBox(height: 10),
            Text(
              scam.description,
              style: AppTextStyles.bodyMuted,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => _showDetail(context, scam),
                child: Text('Learn More', style: AppTextStyles.cardTitle.copyWith(color: AppColors.brand)),
              ),
            ),
          ],
        ),
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
        if (i != 0) {
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
