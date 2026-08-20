import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/notifications_repo.dart';

/// The bell icon's unread count — a plain `int`, decoupled from
/// [NotificationsCubit]'s full list so the layout shell can populate it
/// right after login without paging in the whole notifications screen.
class NotificationsBadgeCubit extends Cubit<int> {
  NotificationsBadgeCubit(this._repo) : super(0);

  final NotificationsRepo _repo;

  /// Silent by design — a transient failure here shouldn't interrupt the
  /// app with an error banner for a non-critical badge count.
  Future<void> refresh() async {
    try {
      emit(await _repo.getUnreadCount());
    } catch (_) {
      // Keep the last known count.
    }
  }

  void clear() => emit(0);
}
