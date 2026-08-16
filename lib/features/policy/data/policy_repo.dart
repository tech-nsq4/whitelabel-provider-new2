import 'models/policy_settings_model.dart';

/// TODO(api): mock data until `ApiEndpoints.policy` exists.
class PolicyRepo {
  Future<PolicySettingsModel> getSettings() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const PolicySettingsModel();
  }

  Future<void> saveSettings(PolicySettingsModel settings) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
