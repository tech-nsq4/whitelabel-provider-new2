import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../data/models/notification_model.dart';
import '../data/notifications_repo.dart';
import 'notifications_badge_cubit.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._repo, this._badgeCubit)
      : super(const NotificationsInitial());

  final NotificationsRepo _repo;

  /// The shared badge singleton — marking notifications read here should
  /// clear/shrink the dashboard bell without that screen reloading the
  /// full list itself.
  final NotificationsBadgeCubit _badgeCubit;

  Future<void> loadNotifications() async {
    emit(const NotificationsLoading());
    try {
      final notifications = await _repo.getNotifications();
      emit(NotificationsSuccess(notifications));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(NotificationsError(msg));
    }
  }

  /// Marks every notification read, then reloads the list — used by the
  /// screen's "تسجيل الكل كمقروء" button, which shows its own loading
  /// state while this runs.
  Future<void> markAllAsRead() async {
    try {
      await _repo.markAllAsRead();
      await loadNotifications();
      _badgeCubit.clear();
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
    }
  }

  /// Marks one notification read, then quietly refreshes the list in the
  /// background — no [NotificationsLoading] in between, so the screen
  /// never flashes a spinner for tapping a single row.
  Future<void> markAsRead(String notificationId) async {
    try {
      await _repo.markAsRead(notificationId);
      final notifications = await _repo.getNotifications();
      emit(NotificationsSuccess(notifications));
      unawaited(_badgeCubit.refresh());
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
    }
  }
}
