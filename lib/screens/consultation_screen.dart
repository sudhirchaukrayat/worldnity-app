import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../services/firestore_service.dart';

/// Consultation Booking — PRD Chapter 8.6
/// V1 pricing: ₹199 per consultation. Razorpay Key ID only (public key) —
/// Key Secret is never stored in the app.
class ConsultationScreen extends StatefulWidget {
  final String? initialFraudType;
  const ConsultationScreen({super.key, this.initialFraudType});

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  static const _razorpayKeyId = 'rzp_test_SVY1jTXN1Yf0ok';
  static const _amountRupees = 199;

  late Razorpay _razorpay;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _consultationType;
  String? _fraudType;
  String? _timeSlot;
  bool _processing = false;

  final _consultationTypes = [
    'Fraud Recovery',
    'Cyber Safety Guidance',
    'Scam Verification',
    'General Guidance',
  ];

  final _fraudTypes = [
    'UPI Fraud', 'Bank Account Fraud', 'OTP Scam', 'Loan App Scam',
    'WhatsApp Scam', 'Social Media Hacking', 'Job Scam', 'Investment Scam',
    'Family Safety', 'Other / Not Sure',
  ];

  final _timeSlots = [
    'Aaj, 5:00 PM - 6:00 PM',
    'Aaj, 7:00 PM - 8:00 PM',
    'Kal, 10:00 AM - 11:00 AM',
    'Kal, 5:00 PM - 6:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    _fraudType = widget.initialFraudType;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    _nameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _startPayment() {
    if (!_formKey.currentState!.validate() ||
        _consultationType == null || _fraudType == null || _timeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sab fields fill karein')),
      );
      return;
    }

    setState(() => _processing = true);

    final options = {
      'key': _razorpayKeyId,
      'amount': _amountRupees * 100, // paise
      'name': 'Wordnity CyberGuard',
      'description': 'Consultation Booking — $_consultationType',
      'prefill': {
        'contact': _contactController.text.trim(),
        'email': _emailController.text.trim().isEmpty
            ? 'support@worldnity.com'
            : _emailController.text.trim(),
      },
      'theme': {'color': '#6013DC'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      setState(() => _processing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment start nahi ho saka')),
      );
    }
  }

  void _onPaymentSuccess(PaymentSuccessResponse response) async {
    try {
      await FirestoreService.submitConsultationBooking(
        consultationType: _consultationType!,
        fraudType: _fraudType!,
        description: _descriptionController.text.trim(),
        timeSlot: _timeSlot!,
        name: _nameController.text.trim(),
        contact: _contactController.text.trim(),
        email: _emailController.text.trim(),
        paymentId: response.paymentId ?? '',
        amountPaise: _amountRupees * 100,
      );
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.success),
              const SizedBox(width: 8),
              Text('Booking Confirmed', style: AppTextStyles.h4),
            ],
          ),
          content: Text(
            'Aapka consultation book ho gaya hai ($_timeSlot). '
            'Expert aapse confirm number par contact karenge.',
            style: AppTextStyles.body,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // dialog
                Navigator.pop(context); // screen
              },
              child: Text('Theek Hai', style: AppTextStyles.cardTitle.copyWith(color: AppColors.brand)),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(
            'Payment ho gaya, lekin booking save karne mein error aaya. Support se contact karein.')),
      );
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  void _onPaymentError(PaymentFailureResponse response) {
    setState(() => _processing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment cancel/fail ho gaya. Phir try karein.')),
    );
  }

  void _onExternalWallet(ExternalWalletResponse response) {
    setState(() => _processing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book Consultation', style: AppTextStyles.h3)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.brand.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(Icons.support_agent_outlined, color: AppColors.brand),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Verified expert se 1-on-1 guidance — ₹$_amountRupees per session.',
                        style: AppTextStyles.body,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text('Consultation Type *', style: AppTextStyles.h4),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _consultationType,
                decoration: _fieldDecoration(),
                hint: const Text('Select karein'),
                items: _consultationTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _consultationType = v),
              ),
              const SizedBox(height: 20),

              Text('Fraud / Topic Type *', style: AppTextStyles.h4),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _fraudType,
                decoration: _fieldDecoration(),
                hint: const Text('Select karein'),
                items: _fraudTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _fraudType = v),
              ),
              const SizedBox(height: 20),

              Text('Problem Briefly Describe Karein *', style: AppTextStyles.h4),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Ye field zaroori hai' : null,
                decoration: _fieldDecoration(hint: 'Kya problem hai...'),
              ),
              const SizedBox(height: 20),

              Text('Time Slot *', style: AppTextStyles.h4),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _timeSlot,
                decoration: _fieldDecoration(),
                hint: const Text('Slot select karein'),
                items: _timeSlots.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _timeSlot = v),
              ),
              const SizedBox(height: 24),

              Text('Aapka Naam *', style: AppTextStyles.h4),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Naam zaroori hai' : null,
                decoration: _fieldDecoration(hint: 'Naam likhein'),
              ),
              const SizedBox(height: 20),

              Text('Contact Number *', style: AppTextStyles.h4),
              const SizedBox(height: 8),
              TextFormField(
                controller: _contactController,
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    (v == null || v.trim().length < 10) ? 'Valid number daalein' : null,
                decoration: _fieldDecoration(hint: '10-digit number'),
              ),
              const SizedBox(height: 20),

              Text('Email (Optional)', style: AppTextStyles.h4),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _fieldDecoration(hint: 'email@example.com'),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _processing ? null : _startPayment,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: _processing
                      ? const SizedBox(
                          height: 20, width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text('₹$_amountRupees Pay Karein & Book Karein', style: AppTextStyles.button),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Guidance milega, lekin money recovery, legal outcome ya fraud resolution ki guarantee nahi hai.',
                style: AppTextStyles.label,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.bgMuted),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}
