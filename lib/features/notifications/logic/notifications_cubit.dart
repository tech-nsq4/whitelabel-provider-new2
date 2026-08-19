import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../data/models/notification_model.dart';
import '../data/notifications_repo.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._repo) : super(const NotificationsInitial());

  final NotificationsRepo _repo;

  int get unreadCount => state is NotificationsSuccess
      ? (state as NotificationsSuccess)
          .notifications
          .where((n) => !n.isRead)
          .length
      : 0;

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

  /// Clears the bell badge once the notifications screen has been opened.
  /// Local-only — the API has no endpoint to persist read state.
  void markAllAsRead() {
    final current = state;
    if (current is! NotificationsSuccess) return;
    emit(NotificationsSuccess([
      for (final n in current.notifications)
        n.isRead ? n : n.copyWith(readAt: DateTime.now().toIso8601String()),
    ]));
  }
}
