import 'package:tachogo/notifications/notification_platform.dart';

/// Уведомление в расписании фейковой платформы.
typedef PendingAlert = ({ScheduledAlert alert, bool exact});

/// Плагин уведомлений в памяти: расписание и шторка — словари, вызовы
/// записываются. Будильник «срабатывает» по [fire].
class FakeNotificationPlatform implements NotificationPlatform {
  new({this.isAndroid = true});

  @override
  final bool isAndroid;

  /// «Будильники и напоминания» разрешены.
  bool exactAllowed = true;

  /// Ответ водителя на системном экране точных будильников.
  bool exactAnswer = true;

  final pending = <int, PendingAlert>{};

  /// id уведомлений в шторке.
  final active = <int>{};
  final calls = <String>[];
  AlertChannelNames? channels;

  /// Бросить ошибку при следующем пересчёте.
  Error? failNext;

  /// Одно и то же уведомление поставлено дважды без отмены.
  int duplicates = 0;

  @override
  Future<void> initialize() async {
    if (failNext case final error?) {
      failNext = null;
      throw error;
    }
    calls.add('initialize');
  }

  @override
  Future<void> createChannels(AlertChannelNames names) async =>
      channels = names;

  @override
  Future<bool> canScheduleExact() async => exactAllowed;

  @override
  Future<bool> requestExactAlarms() async {
    calls.add('requestExactAlarms');
    return exactAllowed = exactAnswer;
  }

  @override
  Future<void> cancelAllPending() async {
    calls.add('cancelAllPending');
    pending.clear();
  }

  @override
  Future<void> schedule(
    ScheduledAlert alert, {
    required bool exact,
    required AlertChannelNames names,
  }) async {
    if (pending.containsKey(alert.id)) duplicates++;
    pending[alert.id] = (alert: alert, exact: exact);
  }

  @override
  Future<List<int>> activeIds() async => [...active];

  @override
  Future<void> cancel(int id) async {
    calls.add('cancel $id');
    active.remove(id);
    pending.remove(id);
  }

  /// Будильник сработал: уведомление ушло из расписания в шторку.
  void fire(int id) {
    pending.remove(id);
    active.add(id);
  }

  /// Уведомления в расписании по времени.
  List<ScheduledAlert> get scheduled =>
      [for (final p in pending.values) p.alert]
        ..sort((a, b) => a.at.compareTo(b.at));
}
