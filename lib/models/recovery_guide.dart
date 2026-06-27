/// Fraud Recovery Center — Data Model
/// Matches PRD Chapter 8.2 (Fraud Recovery Center)
class RecoveryGuide {
  final String fraudType;
  final String iconKey; // mapped to IconData in UI
  final String whatHappened;
  final List<String> immediateActions;
  final List<String> evidenceChecklist;
  final List<String> reportingGuidance;
  final List<String> preventionTips;

  const RecoveryGuide({
    required this.fraudType,
    required this.iconKey,
    required this.whatHappened,
    required this.immediateActions,
    required this.evidenceChecklist,
    required this.reportingGuidance,
    required this.preventionTips,
  });
}

const _commonReporting = [
  'National Cyber Crime Helpline: 1930 par call karein',
  'cybercrime.gov.in par official complaint file karein',
  'Apne bank/app ki customer care ko bhi inform karein',
];

final List<RecoveryGuide> recoveryGuides = [
  RecoveryGuide(
    fraudType: 'UPI Fraud',
    iconKey: 'upi',
    whatHappened: 'Kisi ne aapko fake collect request, QR code ya link se UPI transaction '
        'karwa diya aur paise account se kat gaye.',
    immediateActions: [
      'Bank ko turant call/inform karein',
      'UPI app mein "Block" ya "Report Transaction" karein',
      'UPI PIN turant change karein',
    ],
    evidenceChecklist: [
      'Transaction ID/UTR number save karein',
      'Payment screenshot save karein',
      'Fraudster ka number/UPI ID note karein',
    ],
    reportingGuidance: _commonReporting,
    preventionTips: [
      'Collect request approve karne se pehle amount carefully check karein',
      'Unknown QR code scan na karein',
    ],
  ),
  RecoveryGuide(
    fraudType: 'Bank Account Fraud',
    iconKey: 'bank',
    whatHappened: 'Aapke bank account se unauthorized transaction hua ya account access '
        'compromise ho gaya.',
    immediateActions: [
      'Bank ki helpline pe call karke account turant freeze/block karwayein',
      'Net banking/mobile banking password change karein',
      'Linked mobile number active hai ya nahi check karein',
    ],
    evidenceChecklist: [
      'Bank statement ka screenshot save karein',
      'SMS alerts save karein',
      'Branch ka naam aur account number ready rakhein',
    ],
    reportingGuidance: _commonReporting,
    preventionTips: [
      'Net banking credentials kisi ke saath share na karein',
      'Regularly account statement check karte rahein',
    ],
  ),
  RecoveryGuide(
    fraudType: 'OTP Scam',
    iconKey: 'otp',
    whatHappened: 'Aapne OTP kisi caller/message ko share kar diya aur uska misuse ho gaya.',
    immediateActions: [
      'Concerned bank/app ko turant inform karein',
      'Account/card temporary block karwayein',
      'Future calls/messages se OTP share na karein',
    ],
    evidenceChecklist: [
      'OTP request wala SMS/call record save karein',
      'Caller ka number note karein',
      'Jis transaction ke liye OTP use hua, uska detail save karein',
    ],
    reportingGuidance: _commonReporting,
    preventionTips: [
      'Bank/company kabhi phone par OTP nahi maangti',
      'OTP sirf khud verify karne ke liye hota hai, kisi ko bhi nahi dena',
    ],
  ),
  RecoveryGuide(
    fraudType: 'Fake Loan App Scam',
    iconKey: 'loan',
    whatHappened: 'Fake loan app ne processing fee li aur loan diya nahi, ya app ne contacts/'
        'photos ka misuse karke threaten kiya.',
    immediateActions: [
      'App ko phone se uninstall karein',
      'App ko diye gaye sab permissions revoke karein',
      'Agar threat mil rahi hai, police cyber cell ko inform karein',
    ],
    evidenceChecklist: [
      'App ka naam/screenshot save karein',
      'Payment proof save karein',
      'Threat messages/calls record karein',
    ],
    reportingGuidance: _commonReporting,
    preventionTips: [
      'Sirf RBI-registered NBFC/Bank apps use karein',
      'Upfront fee maangne wale loan app se door rahein',
    ],
  ),
  RecoveryGuide(
    fraudType: 'Social Media Hacking',
    iconKey: 'social',
    whatHappened: 'Aapka social media account hack ho gaya ya kisi ne unauthorized access le liya.',
    immediateActions: [
      'Platform ki "Account Hacked" recovery process use karein',
      'Connected email/phone se password reset karein',
      'Friends/family ko inform karein taaki wo fraud messages ka shikaar na bane',
    ],
    evidenceChecklist: [
      'Login activity/unfamiliar location screenshot save karein',
      'Account se bheje gaye suspicious messages save karein',
    ],
    reportingGuidance: _commonReporting,
    preventionTips: [
      'Strong password aur two-factor authentication use karein',
      'Unknown links pe login details na daalein',
    ],
  ),
  RecoveryGuide(
    fraudType: 'WhatsApp Scam',
    iconKey: 'whatsapp',
    whatHappened: 'WhatsApp pe fake relative/friend banke paise maange gaye, ya account hijack '
        'karne ke liye verification code maanga gaya.',
    immediateActions: [
      'Verification code kisi ko na dein, agar de diya hai to WhatsApp se "Lost/Stolen Phone" process follow karein',
      'Contacts ko inform karein ki account compromised tha',
      'Two-step verification enable karein',
    ],
    evidenceChecklist: [
      'Suspicious chat screenshots save karein',
      'Unknown number note karein',
    ],
    reportingGuidance: _commonReporting,
    preventionTips: [
      'WhatsApp verification code kabhi share na karein',
      'Paise maangne wale messages ko call karke verify karein',
    ],
  ),
  RecoveryGuide(
    fraudType: 'QR Code Scam',
    iconKey: 'qr',
    whatHappened: 'Galat QR code scan karne se paise receive hone ki jagah account se paise '
        'kat gaye.',
    immediateActions: [
      'Bank ko turant inform karein',
      'UPI PIN change karein',
      'QR code se related app/seller ka detail note karein',
    ],
    evidenceChecklist: [
      'QR code ka photo save karein (agar possible ho)',
      'Transaction ID save karein',
    ],
    reportingGuidance: _commonReporting,
    preventionTips: [
      'Paise receive karne ke liye PIN ki zaroorat nahi hoti — yaad rakhein',
      'Sirf trusted merchants ke QR scan karein',
    ],
  ),
  RecoveryGuide(
    fraudType: 'Investment Scam',
    iconKey: 'investment',
    whatHappened: 'Fake high-return investment scheme mein paise invest kiye aur wo scam '
        'nikla.',
    immediateActions: [
      'Aur paise invest karna turant band karein',
      'Platform/app ka record save karein',
      'Bank ko transaction details ke saath inform karein',
    ],
    evidenceChecklist: [
      'Investment app/website ka screenshot save karein',
      'Payment proof aur communication save karein',
    ],
    reportingGuidance: _commonReporting,
    preventionTips: [
      'Guaranteed high-return scheme se savdhan rahein',
      'SEBI-registered platforms par hi invest karein',
    ],
  ),
  RecoveryGuide(
    fraudType: 'Job Scam',
    iconKey: 'job',
    whatHappened: 'Fake job offer ke naam par registration fee li gayi aur job nahi mili.',
    immediateActions: [
      'Company se further communication band karein',
      'Payment proof save karein',
      'Bank ko inform karein agar online payment kiya hai',
    ],
    evidenceChecklist: [
      'Job offer letter/message save karein',
      'Payment receipt save karein',
    ],
    reportingGuidance: _commonReporting,
    preventionTips: [
      'Legit company job ke liye paise nahi maangti',
      'Company ki official website/LinkedIn verify karein',
    ],
  ),
  RecoveryGuide(
    fraudType: 'Online Blackmail / Sextortion',
    iconKey: 'blackmail',
    whatHappened: 'Kisi ne private photos/videos ka misuse karke paise ya kuch aur maang rahe hain.',
    immediateActions: [
      'Blackmailer ko paise bilkul na dein — paying se demands badhti hain',
      'Sab evidence (chats, screenshots) save karein',
      'Turant cyber cell/1930 helpline contact karein',
    ],
    evidenceChecklist: [
      'Sab messages/calls record karein',
      'Profile/account details note karein',
    ],
    reportingGuidance: [
      'National Cyber Crime Helpline: 1930 (24x7)',
      'cybercrime.gov.in par confidential report file karein',
      'Trusted family member/counselor se support lein',
    ],
    preventionTips: [
      'Private content kisi ke saath share na karein',
      'Unknown contacts ke video calls accept na karein',
    ],
  ),
  RecoveryGuide(
    fraudType: 'Other',
    iconKey: 'other',
    whatHappened: 'Agar aapka fraud upar diye gaye categories mein fit nahi hota.',
    immediateActions: [
      'Jis bhi account/app se fraud hua, usko turant secure karein',
      'Sab communication aur transaction proof save karein',
    ],
    evidenceChecklist: [
      'Screenshots, messages, payment proof sab save karein',
    ],
    reportingGuidance: _commonReporting,
    preventionTips: [
      'Kisi bhi suspicious request ko verify karke hi respond karein',
    ],
  ),
];
