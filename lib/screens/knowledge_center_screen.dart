import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../models/scam.dart';
import '../services/firestore_service.dart';

/// Scam Knowledge Center — PRD Chapter 8.4
/// Reuses Scam Feed data (Firestore), organized by category with search.
class KnowledgeCenterScreen extends StatefulWidget {
  const KnowledgeCenterScreen({super.key});

  @override
  State<KnowledgeCenterScreen> createState() => _KnowledgeCenterScreenState();
}

class _CategoryDef {
  final String name;
  final IconData icon;
  const _CategoryDef(this.name, this.icon);
}

const _categories = [
  _CategoryDef('UPI Scams', Icons.qr_code_2),
  _CategoryDef('Banking Scams', Icons.account_balance),
  _CategoryDef('Loan App Scams', Icons.request_quote_outlined),
  _CategoryDef('Social Media Scams', Icons.person_outline),
  _CategoryDef('Student Scams', Icons.school_outlined),
  _CategoryDef('Senior Citizen Scams', Icons.elderly_outlined),
  _CategoryDef('Job Scams', Icons.work_outline),
  _CategoryDef('Investment Scams', Icons.trending_up),
];

class _KnowledgeCenterScreenState extends State<KnowledgeCenterScreen> {
  late Future<List<Scam>> _allScamsFuture;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _allScamsFuture = FirestoreService.fetchScams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scam Knowledge Center', style: AppTextStyles.h3)),
      body: SafeArea(
        child: FutureBuilder<List<Scam>>(
          future: _allScamsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final allScams = snapshot.data ?? [];

            final searchResults = _searchQuery.trim().isEmpty
                ? <Scam>[]
                : allScams.where((s) =>
                    s.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    s.category.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search scams, fraud type, keywords...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.textFaint),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.bgMuted),
                    ),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
                const SizedBox(height: 20),

                if (_searchQuery.trim().isNotEmpty) ...[
                  Text('Search Results', style: AppTextStyles.h4),
                  const SizedBox(height: 10),
                  if (searchResults.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text('Kuch nahi mila. Doosra keyword try karein.',
                          style: AppTextStyles.bodyMuted),
                    )
                  else
                    ...searchResults.map((scam) => _ScamListTile(scam: scam)),
                ] else ...[
                  Text('Browse by Category', style: AppTextStyles.h4),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.95,
                    children: _categories.map((cat) {
                      final count = allScams.where((s) => s.category == cat.name).length;
                      return _CategoryCard(
                        def: cat,
                        count: count,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => _CategoryScamsScreen(
                              category: cat.name,
                              scams: allScams.where((s) => s.category == cat.name).toList(),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final _CategoryDef def;
  final int count;
  final VoidCallback onTap;
  const _CategoryCard({required this.def, required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.brand.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(def.icon, color: AppColors.brand, size: 22),
              ),
              const Spacer(),
              Text(def.name, style: AppTextStyles.cardTitle.copyWith(fontSize: 15), maxLines: 2),
              const SizedBox(height: 2),
              Text('$count article${count == 1 ? '' : 's'}', style: AppTextStyles.label),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryScamsScreen extends StatelessWidget {
  final String category;
  final List<Scam> scams;
  const _CategoryScamsScreen({required this.category, required this.scams});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category, style: AppTextStyles.h3)),
      body: SafeArea(
        child: scams.isEmpty
            ? Center(
                child: Text('Is category mein abhi koi article nahi hai.',
                    style: AppTextStyles.bodyMuted),
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: scams.map((scam) => _ScamListTile(scam: scam)).toList(),
              ),
      ),
    );
  }
}

class _ScamListTile extends StatelessWidget {
  final Scam scam;
  const _ScamListTile({required this.scam});

  @override
  Widget build(BuildContext context) {
    final riskColor = AppColors.riskColor(scam.riskLevel);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(scam.title, style: AppTextStyles.cardTitle),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(scam.description, style: AppTextStyles.bodyMuted, maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: riskColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(scam.riskLevel, style: AppTextStyles.label.copyWith(color: riskColor)),
        ),
        onTap: () => _showArticle(context, scam),
      ),
    );
  }

  void _showArticle(BuildContext context, Scam scam) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: scrollController,
            children: [
              Text(scam.category, style: AppTextStyles.label.copyWith(color: AppColors.brand)),
              const SizedBox(height: 4),
              Text(scam.title, style: AppTextStyles.h3),
              const SizedBox(height: 12),
              Text('Overview', style: AppTextStyles.h4),
              const SizedBox(height: 6),
              Text(scam.description, style: AppTextStyles.body),
              const SizedBox(height: 20),
              Text('Prevention Tips', style: AppTextStyles.h4),
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
      ),
    );
  }
}
