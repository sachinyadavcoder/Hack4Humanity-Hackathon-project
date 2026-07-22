import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- Models ---

class UserProfile {
  final String name;
  final String village;
  final String doctorName;
  final String ashaWorkerName;
  final DateTime estimatedDeliveryDate;
  final int pregnancyWeek;
  final double weight;
  final String bloodPressure;
  final double hemoglobin;
  final int bloodSugar;
  final bool isPregnancyActive;

  UserProfile({
    required this.name,
    required this.village,
    required this.doctorName,
    required this.ashaWorkerName,
    required this.estimatedDeliveryDate,
    required this.pregnancyWeek,
    required this.weight,
    required this.bloodPressure,
    required this.hemoglobin,
    required this.bloodSugar,
    this.isPregnancyActive = true,
  });

  UserProfile copyWith({bool? isPregnancyActive}) {
    return UserProfile(
      name: name,
      village: village,
      doctorName: doctorName,
      ashaWorkerName: ashaWorkerName,
      estimatedDeliveryDate: estimatedDeliveryDate,
      pregnancyWeek: pregnancyWeek,
      weight: weight,
      bloodPressure: bloodPressure,
      hemoglobin: hemoglobin,
      bloodSugar: bloodSugar,
      isPregnancyActive: isPregnancyActive ?? this.isPregnancyActive,
    );
  }
}

class Appointment {
  final String title;
  final DateTime date;
  final String doctorOrAsha;
  final String location;
  final bool isCompleted;

  Appointment({
    required this.title,
    required this.date,
    required this.doctorOrAsha,
    required this.location,
    required this.isCompleted,
  });
}

class AppNotification {
  final String title;
  final String message;
  final DateTime time;
  final String type; // 'reminder', 'tip', 'alert'
  final bool isRead;

  AppNotification({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}

class DailyRecoveryChecklist {
  final bool waterIntake;
  final bool nutrition;
  final bool medicine;
  final bool walking;
  final bool breastfeeding;
  final bool sleep;
  final String mood;

  DailyRecoveryChecklist({
    this.waterIntake = false,
    this.nutrition = false,
    this.medicine = false,
    this.walking = false,
    this.breastfeeding = false,
    this.sleep = false,
    this.mood = 'Good',
  });

  DailyRecoveryChecklist copyWith({
    bool? waterIntake,
    bool? nutrition,
    bool? medicine,
    bool? walking,
    bool? breastfeeding,
    bool? sleep,
    String? mood,
  }) {
    return DailyRecoveryChecklist(
      waterIntake: waterIntake ?? this.waterIntake,
      nutrition: nutrition ?? this.nutrition,
      medicine: medicine ?? this.medicine,
      walking: walking ?? this.walking,
      breastfeeding: breastfeeding ?? this.breastfeeding,
      sleep: sleep ?? this.sleep,
      mood: mood ?? this.mood,
    );
  }
}


// --- Notifiers ---

class UserProfileNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() {
    return UserProfile(
      name: 'Sunita',
      village: 'Rampur',
      doctorName: 'Dr. Meena',
      ashaWorkerName: 'Savitri Tai',
      estimatedDeliveryDate: DateTime(2026, 10, 12),
      pregnancyWeek: 28,
      weight: 58.0,
      bloodPressure: '118/78',
      hemoglobin: 11.2,
      bloodSugar: 96,
    );
  }

  void togglePregnancyMode(bool isActive) {
    state = state.copyWith(isPregnancyActive: isActive);
  }
}

class RecoveryChecklistNotifier extends Notifier<DailyRecoveryChecklist> {
  @override
  DailyRecoveryChecklist build() {
    return DailyRecoveryChecklist();
  }

  void toggleItem(String item) {
    switch (item) {
      case 'water':
        state = state.copyWith(waterIntake: !state.waterIntake);
        break;
      case 'nutrition':
        state = state.copyWith(nutrition: !state.nutrition);
        break;
      case 'medicine':
        state = state.copyWith(medicine: !state.medicine);
        break;
      case 'walking':
        state = state.copyWith(walking: !state.walking);
        break;
      case 'breastfeeding':
        state = state.copyWith(breastfeeding: !state.breastfeeding);
        break;
      case 'sleep':
        state = state.copyWith(sleep: !state.sleep);
        break;
    }
  }

  void setMood(String mood) {
    state = state.copyWith(mood: mood);
  }
}


// --- Providers ---

final userProfileProvider = NotifierProvider<UserProfileNotifier, UserProfile>(() {
  return UserProfileNotifier();
});

final appointmentsProvider = Provider<List<Appointment>>((ref) {
  return [
    Appointment(title: 'ASHA Home Visit', date: DateTime.now().add(const Duration(days: 2)), doctorOrAsha: 'Savitri Tai', location: 'Home', isCompleted: false),
    Appointment(title: 'Tetanus Injection', date: DateTime.now().add(const Duration(days: 5)), doctorOrAsha: 'Dr. Meena', location: 'Primary Health Center', isCompleted: false),
    Appointment(title: 'Monthly Checkup', date: DateTime.now().add(const Duration(days: 14)), doctorOrAsha: 'Dr. Meena', location: 'District Hospital', isCompleted: false),
    Appointment(title: 'Iron Tablets Refill', date: DateTime.now().subtract(const Duration(days: 10)), doctorOrAsha: 'Savitri Tai', location: 'Home', isCompleted: true),
    Appointment(title: 'Ultrasound Scan', date: DateTime.now().subtract(const Duration(days: 25)), doctorOrAsha: 'Dr. Ramesh', location: 'City Clinic', isCompleted: true),
    Appointment(title: 'First Trimester Screening', date: DateTime.now().subtract(const Duration(days: 100)), doctorOrAsha: 'Dr. Meena', location: 'District Hospital', isCompleted: true),
    Appointment(title: 'ASHA Home Visit', date: DateTime.now().subtract(const Duration(days: 80)), doctorOrAsha: 'Savitri Tai', location: 'Home', isCompleted: true),
    Appointment(title: 'ASHA Home Visit', date: DateTime.now().subtract(const Duration(days: 50)), doctorOrAsha: 'Savitri Tai', location: 'Home', isCompleted: true),
    Appointment(title: 'Dietary Consultation', date: DateTime.now().subtract(const Duration(days: 45)), doctorOrAsha: 'Dietician', location: 'Primary Health Center', isCompleted: true),
    Appointment(title: 'Vaccination', date: DateTime.now().subtract(const Duration(days: 30)), doctorOrAsha: 'Dr. Meena', location: 'Primary Health Center', isCompleted: true),
    Appointment(title: 'Glucose Tolerance Test', date: DateTime.now().add(const Duration(days: 20)), doctorOrAsha: 'Dr. Meena', location: 'City Clinic', isCompleted: false),
    Appointment(title: 'ASHA Home Visit', date: DateTime.now().add(const Duration(days: 28)), doctorOrAsha: 'Savitri Tai', location: 'Home', isCompleted: false),
    Appointment(title: 'Birth Plan Discussion', date: DateTime.now().add(const Duration(days: 40)), doctorOrAsha: 'Dr. Meena', location: 'District Hospital', isCompleted: false),
    Appointment(title: 'Final Scan', date: DateTime.now().add(const Duration(days: 50)), doctorOrAsha: 'Dr. Ramesh', location: 'City Clinic', isCompleted: false),
    Appointment(title: 'Post Delivery Checkup', date: DateTime.now().add(const Duration(days: 90)), doctorOrAsha: 'Dr. Meena', location: 'District Hospital', isCompleted: false),
  ];
});

final notificationsProvider = Provider<List<AppNotification>>((ref) {
  return [
    AppNotification(title: 'Medicine Reminder', message: 'Time to take your Iron and Folic Acid tablet.', time: DateTime.now().subtract(const Duration(minutes: 30)), type: 'reminder'),
    AppNotification(title: 'Health Tip', message: 'Drink at least 8 glasses of water today.', time: DateTime.now().subtract(const Duration(hours: 2)), type: 'tip'),
    AppNotification(title: 'ASHA Message', message: 'I will visit you tomorrow at 10 AM. - Savitri', time: DateTime.now().subtract(const Duration(hours: 5)), type: 'alert'),
    AppNotification(title: 'Upcoming Appointment', message: 'Your checkup is scheduled in 2 days.', time: DateTime.now().subtract(const Duration(days: 1)), type: 'reminder'),
    AppNotification(title: 'Baby Milestone', message: 'Your baby is now the size of an eggplant!', time: DateTime.now().subtract(const Duration(days: 2)), type: 'tip'),
    AppNotification(title: 'Scheme Alert', message: 'You are eligible for JSY scheme benefits.', time: DateTime.now().subtract(const Duration(days: 3)), type: 'tip'),
    AppNotification(title: 'Medicine Reminder', message: 'Take your calcium tablet after dinner.', time: DateTime.now().subtract(const Duration(days: 3, hours: 2)), type: 'reminder'),
    AppNotification(title: 'Health Tip', message: 'A short 15-minute walk is good for you and your baby.', time: DateTime.now().subtract(const Duration(days: 4)), type: 'tip'),
    AppNotification(title: 'ASHA Message', message: 'Keep your hospital bag ready.', time: DateTime.now().subtract(const Duration(days: 5)), type: 'alert'),
    AppNotification(title: 'Nutrition Tip', message: 'Include dark leafy greens in your meals.', time: DateTime.now().subtract(const Duration(days: 6)), type: 'tip'),
    AppNotification(title: 'Medicine Reminder', message: 'Time to take your Iron and Folic Acid tablet.', time: DateTime.now().subtract(const Duration(days: 7)), type: 'reminder'),
    AppNotification(title: 'Baby Tip', message: 'Singing or talking to your baby helps them recognize your voice.', time: DateTime.now().subtract(const Duration(days: 8)), type: 'tip'),
    AppNotification(title: 'Rest Reminder', message: 'Ensure you get at least 8 hours of sleep.', time: DateTime.now().subtract(const Duration(days: 9)), type: 'reminder'),
    AppNotification(title: 'Warning Sign', message: 'If you feel severe abdominal pain, contact your ASHA immediately.', time: DateTime.now().subtract(const Duration(days: 10)), type: 'alert'),
    AppNotification(title: 'Diet Tip', message: 'Avoid spicy and oily food to reduce heartburn.', time: DateTime.now().subtract(const Duration(days: 11)), type: 'tip'),
    AppNotification(title: 'Scheme Update', message: 'Your PMMVY installment has been processed.', time: DateTime.now().subtract(const Duration(days: 12)), type: 'tip'),
    AppNotification(title: 'Activity Tip', message: 'Try some gentle stretches today.', time: DateTime.now().subtract(const Duration(days: 13)), type: 'tip'),
    AppNotification(title: 'Hygiene Tip', message: 'Wash hands before every meal.', time: DateTime.now().subtract(const Duration(days: 14)), type: 'tip'),
    AppNotification(title: 'ASHA Message', message: 'Please share your latest weight with me.', time: DateTime.now().subtract(const Duration(days: 15)), type: 'alert'),
    AppNotification(title: 'Hydration', message: 'Have you had enough water today?', time: DateTime.now().subtract(const Duration(days: 16)), type: 'tip'),
  ];
});

final recoveryChecklistProvider = NotifierProvider<RecoveryChecklistNotifier, DailyRecoveryChecklist>(() {
  return RecoveryChecklistNotifier();
});
