import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../services/local_profile_service.dart';
import '../models/lesson.dart';
import '../services/auth_service.dart';
import 'auth_screen.dart';

/// Profile Screen — shows current profile + family info, allows editing.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, String>? _profile;
  Map<String, String>? _family;
  int _lessonsCompleted = 0;
  bool _loading = true;

  final _userTypes = ['Parent / Family Admin', 'Student', 'Senior Citizen', 'Other'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final profile = await LocalProfileService.getProfile();
    final family = await LocalProfileService.getFamily();
    final completed = await LocalProfileService.getCompletedLessons();
    setState(() {
      _profile = profile;
      _family = family;
      _lessonsCompleted = completed.length;
      _loading = false;
    });
  }

  void _editProfile() {
    final nameController = TextEditingController(text: _profile?['name'] ?? '');
    String? selectedType = _profile?['userType'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 24, right: 24, top: 24,
            bottom: 24 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Profile Edit Karein', style: AppTextStyles.h3),
              const SizedBox(height: 20),
              Text('Naam', style: AppTextStyles.h4),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.bgMuted),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('User Type', style: AppTextStyles.h4),
              const SizedBox(height: 8),
              ..._userTypes.map((type) => RadioListTile<String>(
                    value: type,
                    groupValue: selectedType,
                    onChanged: (v) => setSheetState(() => selectedType = v),
                    title: Text(type, style: AppTextStyles.body),
                    activeColor: AppColors.brand,
                    contentPadding: EdgeInsets.zero,
                  )),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.trim().isEmpty || selectedType == null) return;
                    await LocalProfileService.saveProfile(
                      name: nameController.text.trim(),
                      userType: selectedType!,
                    );
                    if (!mounted) return;
                    Navigator.pop(context);
                    _load();
                  },
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: Text('Save Karein', style: AppTextStyles.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text('Profile', style: AppTextStyles.h3)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_profile == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Profile', style: AppTextStyles.h3)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Profile abhi set nahi hai. "Family" tab se profile create karein.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMuted,
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: () async {
                    await AuthService.signOut();
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                      (route) => false,
                    );
                  },
                  icon: Icon(Icons.logout, size: 18, color: AppColors.error),
                  label: Text('Log Out', style: AppTextStyles.cardTitle.copyWith(color: AppColors.error)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.error.withOpacity(0.3)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: AppTextStyles.h3),
        actions: [
          IconButton(onPressed: _editProfile, icon: const Icon(Icons.edit_outlined)),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.brand.withOpacity(0.1),
                    child: Text(
                      _profile!['name']!.isNotEmpty ? _profile!['name']![0].toUpperCase() : '?',
                      style: AppTextStyles.h1.copyWith(color: AppColors.brand),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(_profile!['name']!, style: AppTextStyles.h3),
                  Text(_profile!['userType']!, style: AppTextStyles.bodyMuted),
                ],
              ),
            ),
            const SizedBox(height: 28),

            _InfoTile(
              icon: Icons.family_restroom,
              title: 'Family',
              subtitle: _family != null
                  ? 'Code: ${_family!['code']} · ${_family!['role']}'
                  : 'Abhi kisi family se jude nahi hain',
            ),
            _InfoTile(
              icon: Icons.school_outlined,
              title: 'Lessons Completed',
              subtitle: '$_lessonsCompleted/${lessons.length}',
            ),
            const SizedBox(height: 20),

            Text('App Info', style: AppTextStyles.h4),
            const SizedBox(height: 10),
            _InfoTile(
              icon: Icons.shield_outlined,
              title: 'Wordnity CyberGuard',
              subtitle: 'Version 1.0.0',
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: Text('Log Out?', style: AppTextStyles.h4),
                      content: Text('Aap apne account se log out ho jayenge.', style: AppTextStyles.body),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('Cancel', style: AppTextStyles.body),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text('Log Out', style: AppTextStyles.cardTitle.copyWith(color: AppColors.error)),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await AuthService.signOut();
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                      (route) => false,
                    );
                  }
                },
                icon: Icon(Icons.logout, size: 18, color: AppColors.error),
                label: Text('Log Out', style: AppTextStyles.cardTitle.copyWith(color: AppColors.error)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: AppColors.error.withOpacity(0.3)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _InfoTile({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.brand.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.brand),
        ),
        title: Text(title, style: AppTextStyles.cardTitle),
        subtitle: Text(subtitle, style: AppTextStyles.bodyMuted),
      ),
    );
  }
}
