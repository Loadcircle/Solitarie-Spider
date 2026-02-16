import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int _streakId = 1001;
  static const int _rewardId = 1002;

  static const String _channelStreakId = 'daily_streak';
  static const String _channelStreakName = 'Daily Streak';

  static const String _channelRewardId = 'reward_proximity';
  static const String _channelRewardName = 'Reward Alerts';

  static const String _keyLastPlayedDate = 'notif_lastPlayedDate';

  Future<void> init() async {
    tz.initializeTimeZones();
    _setLocalTimezone();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(initSettings);
  }

  /// Set tz.local to the device's timezone using the UTC offset.
  void _setLocalTimezone() {
    final Duration offset = DateTime.now().timeZoneOffset;
    // Find the first timezone matching the device's current offset.
    for (final String name in tz.timeZoneDatabase.locations.keys) {
      final tz.Location loc = tz.getLocation(name);
      if (loc.currentTimeZone.offset == offset.inMilliseconds) {
        tz.setLocalLocation(loc);
        return;
      }
    }
    // Fallback: stays as UTC.
  }

  Future<bool> requestPermission() async {
    final AndroidFlutterLocalNotificationsPlugin? android =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return false;
    final bool? granted = await android.requestNotificationsPermission();
    return granted ?? false;
  }

  Future<void> scheduleDailyStreak({
    required String title,
    required String body,
  }) async {
    await _plugin.zonedSchedule(
      _streakId,
      title,
      body,
      _next7pm(),
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelStreakId,
          _channelStreakName,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelDailyStreak() async {
    await _plugin.cancel(_streakId);
  }

  Future<void> scheduleRewardProximity({
    required String title,
    required String body,
    Duration delay = const Duration(hours: 1, minutes: 30),
  }) async {
    final tz.TZDateTime scheduledDate =
        tz.TZDateTime.now(tz.local).add(delay);

    await _plugin.zonedSchedule(
      _rewardId,
      title,
      body,
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelRewardId,
          _channelRewardName,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> cancelRewardProximity() async {
    await _plugin.cancel(_rewardId);
  }

  /// Fire a notification immediately (for debug/testing).
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
  }) async {
    await _plugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelRewardId,
          _channelRewardName,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> markPlayedToday() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String today = _todayString();
    await prefs.setString(_keyLastPlayedDate, today);
  }

  Future<bool> hasPlayedToday() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? lastPlayed = prefs.getString(_keyLastPlayedDate);
    return lastPlayed == _todayString();
  }

  tz.TZDateTime _next7pm() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      19,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  String _todayString() {
    final DateTime now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
