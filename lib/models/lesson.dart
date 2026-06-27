/// Cyber Safety Lessons — PRD V1 Feature 6
/// Short, quick-read lessons (different from full Knowledge Center articles).
class Lesson {
  final String title;
  final String content;
  final String iconKey;

  const Lesson({required this.title, required this.content, required this.iconKey});
}

final List<Lesson> lessons = [
  Lesson(
    title: 'OTP Kabhi Share Mat Karo',
    iconKey: 'otp',
    content: 'OTP sirf aapki identity verify karne ke liye hota hai. Bank, company, ya delivery '
        'agent — koi bhi genuine sources kabhi phone par OTP nahi maangta. Agar koi maange, '
        'turant samajh jao ki ye scam hai.',
  ),
  Lesson(
    title: 'Fake Links Kaise Pehchane',
    iconKey: 'link',
    content: 'Fake links mein chhoti spelling mistakes hoti hain (jaise "amaz0n.com"), URL '
        'https:// se shuru nahi hota, ya domain unfamiliar hota hai. Hamesha link ko carefully '
        'padho, click karne se pehle.',
  ),
  Lesson(
    title: 'Loan App Scams Kaise Pehchane',
    iconKey: 'loan',
    content: 'Agar koi loan app "instant approval, no documents" ka vaada karta hai aur '
        'upfront processing fee maangta hai — ye red flag hai. Sirf RBI-registered NBFC ya '
        'banks ke apps use karo.',
  ),
  Lesson(
    title: 'UPI PIN Kabhi Type Mat Karo Receive Karne Ke Liye',
    iconKey: 'upi',
    content: 'Paise receive karne ke liye PIN ki zaroorat nahi hoti — sirf paise bhejne ke '
        'liye PIN dalte hain. Agar koi "paise lene ke liye PIN dalo" kehta hai, ye scam hai.',
  ),
  Lesson(
    title: 'Strong Password Banane Ka Tareeka',
    iconKey: 'password',
    content: 'Apna naam, birthday, ya "123456" jaise simple passwords avoid karo. Kam se kam '
        '8 characters, numbers aur symbols mix karke password banao, aur har account ke liye '
        'alag password rakho.',
  ),
  Lesson(
    title: 'Social Media Pe Safe Kaise Rahein',
    iconKey: 'social',
    content: 'Apni location, financial details, ya personal documents social media par share '
        'na karein. Unknown friend requests accept karne se pehle profile carefully check karo.',
  ),
  Lesson(
    title: 'Fake Calls Ko Pehchanna',
    iconKey: 'call',
    content: 'Scammers khud ko bank, police, ya government official batake call karte hain '
        'aur urgency create karte hain ("turant action lo warna account block ho jayega"). Asli '
        'organizations kabhi itni jaldi nahi karte.',
  ),
  Lesson(
    title: 'QR Code Scan Karne Se Pehle',
    iconKey: 'qr',
    content: 'Sirf trusted, well-known merchants ke QR code scan karo. Random QR codes (jo '
        'kisi ne WhatsApp par bheja ho, ya kisi poster pe chipka ho) scan karne se bachein.',
  ),
];
