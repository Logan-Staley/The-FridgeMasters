import 'dart:io';

class ApiKeys {
  final String appId;
  final String appKey;

  ApiKeys({required this.appId, required this.appKey});

  static ApiKeys get instance {
    return ApiKeys(
      appId: Platform.environment['EDAMAM_APP_ID'] ?? "default_app_id",
      appKey: Platform.environment['EDAMAM_APP_KEY'] ?? "default_app_key",
    );
  }
}
