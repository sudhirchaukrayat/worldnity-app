import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../services/firestore_service.dart';
import '../services/local_profile_service.dart';
import '../models/lesson.dart';

/// Family Invite System + Basic Family Dashboard
/// PRD Chapter 8.3 (Family Dashboard) + Chapter 6.2/6.3 (Family Admin/Member roles)
/// V1 simplified — no full login, profile stored locally on device.
class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  bool _loading = true;
  Map<String, String>? _profile;
  Map<String, String>? _family;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final profile = await LocalProfileService.getProfile();
    final family = await LocalProfileService.getFamily();
    setState(() {
      _profile = profile;
      _family = family;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text('Family', style: AppTextStyles.h3)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_profile == null) {
      return _ProfileSetupView(onDone: _load);
    }
    if (_family == null) {
      return _FamilyChoiceView(profile: _profile!, onDone: _load);
    }
    return _FamilyDashboardView(profile: _profile!, family: _family!);
  }
}

// ---------------------------------------------------------------------------
// Step 1: Basic profile setup (name + user type)
// ---------------------------------------------------------------------------
class _ProfileSetupView extends StatefulWidget {
  final VoidCallback onDone;
  const _ProfileSetupView({required this.onDone});

  @override
  State<_ProfileSetupView> createState() => _ProfileSetupViewState();
}

class _ProfileSetupViewState extends State<_ProfileSetupView> {
  final _nameController = TextEditingController();
  String? _userType;
  final _userTypes = ['Parent / Family Admin', 'Student', 'Senior Citizen', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Setup', style: AppTextStyles.h3)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Family features use karne ke liye, pehle apna basic profile bana lein.',
                  style: AppTextStyles.bodyMuted),
              const SizedBox(height: 24),
              Text('Aapka Naam', style: AppTextStyles.h4),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Naam likhein',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.bgMuted),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Aap Kaun Hain?', style: AppTextStyles.h4),
              const SizedBox(height: 8),
              ..._userTypes.map((type) => RadioListTile<String>(
                    value: type,
                    groupValue: _userType,
                    onChanged: (v) => setState(() => _userType = v),
                    title: Text(type, style: AppTextStyles.body),
                    activeColor: AppColors.brand,
                    contentPadding: EdgeInsets.zero,
                  )),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_nameController.text.trim().isEmpty || _userType == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Naam aur user type select karein')),
                      );
                      return;
                    }
                    await LocalProfileService.saveProfile(
                      name: _nameController.text.trim(),
                      userType: _userType!,
                    );
                    widget.onDone();
                  },
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: Text('Continue', style: AppTextStyles.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Step 2: Create new family OR join existing family via code
// ---------------------------------------------------------------------------
class _FamilyChoiceView extends StatefulWidget {
  final Map<String, String> profile;
  final VoidCallback onDone;
  const _FamilyChoiceView({required this.profile, required this.onDone});

  @override
  State<_FamilyChoiceView> createState() => _FamilyChoiceViewState();
}

class _FamilyChoiceViewState extends State<_FamilyChoiceView> {
  bool _showJoinForm = false;
  bool _busy = false;
  final _codeController = TextEditingController();

  String _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // avoid confusing O/0/I/1
    final rand = Random();
    return List.generate(6, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  Future<void> _createFamily() async {
    setState(() => _busy = true);
    try {
      final code = _generateCode();
      await FirestoreService.createFamily(code);
      await FirestoreService.addFamilyMember(
        familyCode: code,
        name: widget.profile['name']!,
        userType: widget.profile['userType']!,
        role: 'Family Admin',
      );
      await LocalProfileService.saveFamily(code: code, role: 'Family Admin');
      widget.onDone();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kuch gadbad ho gayi. Phir try karein.')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _joinFamily() async {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) return;
    setState(() => _busy = true);
    try {
      final exists = await FirestoreService.familyExists(code);
      if (!exists) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ye family code valid nahi hai')),
        );
        return;
      }
      await FirestoreService.addFamilyMember(
        familyCode: code,
        name: widget.profile['name']!,
        userType: widget.profile['userType']!,
        role: 'Family Member',
      );
      await LocalProfileService.saveFamily(code: code, role: 'Family Member');
      widget.onDone();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kuch gadbad ho gayi. Phir try karein.')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Family Setup', style: AppTextStyles.h3)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Namaste, ${widget.profile['name']}! 👋', style: AppTextStyles.h3),
              const SizedBox(height: 8),
              Text('Naya family group banayein, ya kisi existing family mein join karein.',
                  style: AppTextStyles.bodyMuted),
              const SizedBox(height: 24),

              if (!_showJoinForm) ...[
                _ChoiceCard(
                  icon: Icons.add_circle_outline,
                  title: 'Naya Family Banayein',
                  subtitle: 'Aap Family Admin banenge',
                  onTap: _busy ? null : _createFamily,
                ),
                const SizedBox(height: 12),
                _ChoiceCard(
                  icon: Icons.group_add_outlined,
                  title: 'Existing Family Join Karein',
                  subtitle: 'Family code daal ke join karein',
                  onTap: _busy ? null : () => setState(() => _showJoinForm = true),
                ),
              ] else ...[
                Text('Family Code', style: AppTextStyles.h4),
                const SizedBox(height: 8),
                TextField(
                  controller: _codeController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: '6-character code',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.bgMuted),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _busy ? null : _joinFamily,
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: _busy
                        ? const SizedBox(
                            height: 18, width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text('Join Karein', style: AppTextStyles.button),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => setState(() => _showJoinForm = false),
                  child: Text('Wapas', style: AppTextStyles.body),
                ),
              ],

              if (_busy && !_showJoinForm) const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  const _ChoiceCard({required this.icon, required this.title, required this.subtitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.brand.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.brand),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.cardTitle),
                    Text(subtitle, style: AppTextStyles.label),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textFaint),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Step 3: Family Dashboard (PRD Chapter 8.3 — simplified for V1)
// ---------------------------------------------------------------------------
class _FamilyDashboardView extends StatefulWidget {
  final Map<String, String> profile;
  final Map<String, String> family;
  const _FamilyDashboardView({required this.profile, required this.family});

  @override
  State<_FamilyDashboardView> createState() => _FamilyDashboardViewState();
}

class _FamilyDashboardViewState extends State<_FamilyDashboardView> {
  late Future<List<Map<String, String>>> _membersFuture;
  int _lessonsCompleted = 0;

  @override
  void initState() {
    super.initState();
    _membersFuture = FirestoreService.fetchFamilyMembers(widget.family['code']!);
    LocalProfileService.getCompletedLessons().then((set) {
      setState(() => _lessonsCompleted = set.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    final code = widget.family['code']!;
    final role = widget.family['role']!;

    return Scaffold(
      appBar: AppBar(title: Text('Family Dashboard', style: AppTextStyles.h3)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.brand,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Family Code', style: AppTextStyles.label.copyWith(color: Colors.white70)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(code,
                          style: AppTextStyles.h1.copyWith(color: Colors.white, letterSpacing: 4)),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: code));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Code copy ho gaya')),
                          );
                        },
                        icon: const Icon(Icons.copy, color: Colors.white),
                      ),
                    ],
                  ),
                  Text('Ye code family members ke saath share karein',
                      style: AppTextStyles.body.copyWith(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: FutureBuilder<List<Map<String, String>>>(
                    future: _membersFuture,
                    builder: (context, snapshot) {
                      final count = snapshot.data?.length ?? 0;
                      return _StatCard(label: 'Members', value: '$count', icon: Icons.group_outlined);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Lessons Done',
                    value: '$_lessonsCompleted/${lessons.length}',
                    icon: Icons.school_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Text('Aapka Role: $role', style: AppTextStyles.h4),
            const SizedBox(height: 12),
            Text('Family Members', style: AppTextStyles.h4),
            const SizedBox(height: 10),
            FutureBuilder<List<Map<String, String>>>(
              future: _membersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final members = snapshot.data ?? [];
                if (members.isEmpty) {
                  return Text('Abhi koi member nahi mila.', style: AppTextStyles.bodyMuted);
                }
                return Column(
                  children: members.map((m) {
                    final isAdmin = m['role'] == 'Family Admin';
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.brand.withOpacity(0.1),
                          child: Icon(
                            isAdmin ? Icons.shield : Icons.person_outline,
                            color: AppColors.brand,
                          ),
                        ),
                        title: Text(m['name'] ?? '', style: AppTextStyles.cardTitle),
                        subtitle: Text(m['userType'] ?? '', style: AppTextStyles.bodyMuted),
                        trailing: Text(
                          m['role'] ?? '',
                          style: AppTextStyles.label.copyWith(color: AppColors.brand),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.brand),
            const SizedBox(height: 8),
            Text(value, style: AppTextStyles.h3),
            Text(label, style: AppTextStyles.label),
          ],
        ),
      ),
    );
  }
}
