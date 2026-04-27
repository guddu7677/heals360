import 'package:shared_preferences/shared_preferences.dart';

class _Keys {
  static const fullName      = 'profile_fullName';
  static const phone         = 'profile_phone';
  static const email         = 'profile_email';
  static const gender        = 'profile_gender';
  static const married       = 'profile_married';
  static const marriageYear  = 'profile_marriageYear';
  static const ttcYear       = 'profile_ttcYear';
  static const issues        = 'profile_issues';
  static const tried         = 'profile_tried';
  static const goal          = 'profile_goal';
  static const completedStep = 'profile_completedStep';
  static const isComplete    = 'profile_isComplete';
}

class ProfileData {
  String       fullName     = '';
  String       phone        = '';
  String       email        = '';
  String       gender       = '';   // 'male' | 'female'
  bool?        married;
  String       marriageYear = '';
  String       ttcYear      = '';
  List<String> issues       = [];
  List<String> tried        = [];
  String       goal         = '';
  int          completedStep = 0;
  bool         isComplete   = false;

  // ── persistence ──────────────────────────────────────────────────────────

  static Future<ProfileData> load() async {
    final prefs = await SharedPreferences.getInstance();
    final d = ProfileData();
    d.fullName      = prefs.getString(_Keys.fullName)      ?? '';
    d.phone         = prefs.getString(_Keys.phone)         ?? '';
    d.email         = prefs.getString(_Keys.email)         ?? '';
    d.gender        = prefs.getString(_Keys.gender)        ?? '';
    final m         = prefs.getString(_Keys.married);
    d.married       = m == null ? null : m == 'true';
    d.marriageYear  = prefs.getString(_Keys.marriageYear)  ?? '';
    d.ttcYear       = prefs.getString(_Keys.ttcYear)       ?? '';
    d.issues        = prefs.getStringList(_Keys.issues)    ?? [];
    d.tried         = prefs.getStringList(_Keys.tried)     ?? [];
    d.goal          = prefs.getString(_Keys.goal)          ?? '';
    d.completedStep = prefs.getInt(_Keys.completedStep)    ?? 0;
    d.isComplete    = prefs.getBool(_Keys.isComplete)      ?? false;
    return d;
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_Keys.fullName,      fullName);
    await prefs.setString(_Keys.phone,         phone);
    await prefs.setString(_Keys.email,         email);
    await prefs.setString(_Keys.gender,        gender);
    if (married != null) {
      await prefs.setString(_Keys.married, married.toString());
    }
    await prefs.setString(_Keys.marriageYear,  marriageYear);
    await prefs.setString(_Keys.ttcYear,       ttcYear);
    await prefs.setStringList(_Keys.issues,    issues);
    await prefs.setStringList(_Keys.tried,     tried);
    await prefs.setString(_Keys.goal,          goal);
    await prefs.setInt(_Keys.completedStep,    completedStep);
    await prefs.setBool(_Keys.isComplete,      isComplete);
  }

  // ── computed ─────────────────────────────────────────────────────────────

  /// 0.0 – 1.0
  double get progress {
    const totalSteps = 6;
    if (isComplete) return 1.0;
    return ((completedStep + 1) / totalSteps).clamp(0.0, 1.0);
  }

  List<String> get issueOptions => gender == 'male'
      ? [
          'Low Sperm Count',
          'Low Motility',
          'No Sperm (Azoospermia)',
          'Erectile Dysfunction',
          'Hormonal Issues',
          'Varicocele',
          'No Diagnosis Yet',
          'Other',
        ]
      : [
          'PCOS / PCOD',
          'Irregular Periods',
          'Thyroid Issues',
          'Low AMH',
          'Endometriosis',
          'Blocked Tubes',
          'Recurrent Miscarriage',
          'No Diagnosis Yet',
          'Other',
        ];

  List<String> get triedOptions => gender == 'male'
      ? ['Medicines', 'Supplements', 'IVF / IUI', 'Natural / Home Remedies', 'Nothing Yet', 'Other']
      : ['Medicines', 'IVF / IUI', 'Hormonal Treatment', 'Natural / Home Remedies', 'Nothing Yet', 'Other'];
}