/// Scam Feed — Data Model
/// Matches PRD Chapter 8.1 (Scam Feed) structure
class Scam {
  final String title;
  final String description;
  final String riskLevel; // Low, Medium, High, Critical
  final String category;
  final String imageUrl;
  final List<String> preventionTips;

  const Scam({
    required this.title,
    required this.description,
    required this.riskLevel,
    required this.category,
    required this.imageUrl,
    required this.preventionTips,
  });
}

/// Temporary dummy data — replace with Firebase data later.
/// Admin (you) will add real entries via Firebase Console for now,
/// later via a proper Admin Panel.
final List<Scam> dummyScams = [
  Scam(
    title: 'Fake Loan App Scam',
    description:
        'Fraudsters fake loan apps banate hain jo instant approval ka vaada karte hain, '
        'lekin processing fee ke naam par paise le lete hain aur loan kabhi nahi milta.',
    riskLevel: 'Critical',
    category: 'Loan App Scams',
    imageUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=800&q=80',
    preventionTips: [
      'Sirf RBI-registered NBFC/Bank apps use karo',
      'Upfront processing fee maangne wale app se door raho',
      'App ke reviews aur permissions check karo',
    ],
  ),
  Scam(
    title: 'WhatsApp OTP Scam',
    description:
        'Scammer aapko call/message karke khud ko "bank employee" batate hain aur OTP '
        'share karne ke liye kehte hain taaki aapke account se paise nikal sakein.',
    riskLevel: 'High',
    category: 'Banking Scams',
    imageUrl: 'https://images.unsplash.com/photo-1611606063065-ee7946f0787a?w=800&q=80',
    preventionTips: [
      'OTP kisi ke saath kabhi share na karein',
      'Bank kabhi phone par OTP nahi maangta',
      'Suspicious call disconnect karke bank ko directly call karein',
    ],
  ),
  Scam(
    title: 'UPI Collect Request Scam',
    description:
        'Fraudster ek "collect request" bhejta hai jo dikhta hai jaise paise aa rahe hain, '
        'lekin approve karte hi aapke account se paise kat jaate hain.',
    riskLevel: 'High',
    category: 'UPI Scams',
    imageUrl: 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=800&q=80',
    preventionTips: [
      'Collect request ko carefully padho approve karne se pehle',
      'Paise receive karne ke liye PIN ki zaroorat nahi hoti',
      'Unknown collect request ko decline karein',
    ],
  ),
  Scam(
    title: 'Fake KYC Update Call',
    description:
        'Caller khud ko bank/telecom representative batakar KYC update ke naam par '
        'personal details ya remote access app install karne ko kehta hai.',
    riskLevel: 'Medium',
    category: 'Banking Scams',
    imageUrl: 'https://images.unsplash.com/photo-1556740758-90de374c12ad?w=800&q=80',
    preventionTips: [
      'KYC sirf bank branch ya official app se update karein',
      'Koi bhi remote-access app (AnyDesk etc.) install na karein',
      'Personal details phone par share na karein',
    ],
  ),
  Scam(
    title: 'Online Job Offer Scam',
    description:
        'Students ko "work from home" job ka offer milta hai jisme pehle "registration fee" '
        'maangi jaati hai, fee dene ke baad job gayab ho jaati hai.',
    riskLevel: 'Medium',
    category: 'Student Scams',
    imageUrl: 'https://images.unsplash.com/photo-1521791136064-7986c2920216?w=800&q=80',
    preventionTips: [
      'Koi bhi legit company job ke liye paise nahi maangti',
      'Company ki official website verify karein',
      'Family/seniors se salah lekar hi payment karein',
    ],
  ),
];
