import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../data/auth_repo.dart';
import '../data/models/manager_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repo) : super(const AuthInitial());

  final AuthRepo _repo;

  /// Logs the manager in with [phone] + [password] and persists the session.
  Future<void> login({required String phone, required String password}) async {
    emit(const AuthLoading());
    try {
      final manager = await _repo.login(phone: phone, password: password);
      emit(AuthSuccess(manager));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      emit(AuthError(msg));
    }
  }

  Future<void> logout() async {
    try {
      await _repo.logout();
      emit(const AuthInitial());
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      emit(AuthError(msg));
    }
  }
}
