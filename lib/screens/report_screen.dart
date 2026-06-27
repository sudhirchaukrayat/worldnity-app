import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../services/firestore_service.dart';

/// Scam Report Submission — PRD Chapter 8.9 (V1 simplified version)
/// User submits a suspicious scam; goes to Firestore "reports" collection
/// with status "pending" for moderator review (full community database is V2).
class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _evidenceController = TextEditingController();

  String? _category;
  DateTime _date = DateTime.now();
  bool _submitting = false;

  final _categories = [
    'UPI Scam',
    'Banking Scam',
    'Loan App Scam',
    'Job Scam',
    'Investment Scam',
    'Social Media Scam',
    'Other',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _evidenceController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _category == null) {
      if (_category == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Scam category select karein')),
        );
      }
      return;
    }

    setState(() => _submitting = true);
    try {
      await FirestoreService.submitReport(
        category: _category!,
        description: _descriptionController.text.trim(),
        date: '${_date.day}/${_date.month}/${_date.year}',
        state: _stateController.text.trim(),
        city: _cityController.text.trim(),
        evidence: _evidenceController.text.trim(),
      );
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.success),
              const SizedBox(width: 8),
              Text('Report Submit Ho Gaya', style: AppTextStyles.h4),
            ],
          ),
          content: Text(
            'Aapka report hamari team ko mil gaya hai. Verification ke baad ye community ko aware karega.',
            style: AppTextStyles.body,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // close screen
              },
              child: Text('Theek Hai', style: AppTextStyles.cardTitle.copyWith(color: AppColors.brand)),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kuch gadbad ho gayi. Phir try karein.')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scam Report Karein', style: AppTextStyles.h3)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(Icons.shield_outlined, color: AppColors.info),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Aapki identity private rahegi. Report verification ke baad community ko warn karne mein madad karega.',
                        style: AppTextStyles.body,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text('Scam Category *', style: AppTextStyles.h4),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.bgMuted),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                hint: const Text('Category select karein'),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) => setState(() => _category = value),
              ),
              const SizedBox(height: 20),

              Text('Kya Hua? *', style: AppTextStyles.h4),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Description likhna zaroori hai' : null,
                decoration: InputDecoration(
                  hintText: 'Scam ka detail likhein...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.bgMuted),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text('Scam Kab Hua?', style: AppTextStyles.h4),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.bgMuted),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${_date.day}/${_date.month}/${_date.year}', style: AppTextStyles.body),
                      Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.textFaint),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text('Location (Optional)', style: AppTextStyles.h4),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _stateController,
                      decoration: InputDecoration(
                        hintText: 'State',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.bgMuted),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        hintText: 'City',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.bgMuted),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Text('Evidence (Optional)', style: AppTextStyles.h4),
              const SizedBox(height: 8),
              TextFormField(
                controller: _evidenceController,
                decoration: InputDecoration(
                  hintText: 'Fraud number, website ya link...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.bgMuted),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: _submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text('Report Submit Karein', style: AppTextStyles.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
