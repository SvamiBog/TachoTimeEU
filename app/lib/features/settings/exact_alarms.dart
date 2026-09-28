import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/widgets/setting_rows.dart';
import 'package:tachogo/notifications/alert_providers.dart';

/// Системный экран «Будильники и напоминания» (Android 14+). Когда водитель
/// вернулся, расписание ставится заново — уже точными будильниками.
Future<void> allowExactAlarms(WidgetRef ref) async {
  await ref.read(notificationPlatformProvider).requestExactAlarms();
  ref.invalidate(exactAlarmsProvider);
  await ref.read(alertSchedulerProvider).reschedule();
}

/// «Точное время уведомлений», пока точные будильники запрещены: без них
/// система может сдвинуть предупреждение о перерыве до часа.
class ExactAlarmsRow extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return NavRow(
      icon: Icons.alarm_outlined,
      title: l.notifyExact,
      subtitle: l.notifyExactHint,
      onTap: () => unawaited(allowExactAlarms(ref)),
    );
  }
}
