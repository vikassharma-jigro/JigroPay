import 'dart:io';

class AppPlatformConfig {
  final String version;
  final bool forceUpdate;
  final String updateUrl;

  const AppPlatformConfig({
    required this.version,
    required this.forceUpdate,
    required this.updateUrl,
  });

  factory AppPlatformConfig.fromJson(Map<String, dynamic>? json) {
    return AppPlatformConfig(
      version: json?['version'] as String? ?? '1.0.0',
      forceUpdate: json?['force_update'] as bool? ?? false,
      updateUrl: json?['update_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'force_update': forceUpdate,
      'update_url': updateUrl,
    };
  }
}

class VersionConfigueModel {
  final AppPlatformConfig? android;
  final AppPlatformConfig? ios;
  final String message;

  const VersionConfigueModel({
    this.android,
    this.ios,
    this.message = 'A new version of JigroPay is available.',
  });

  /// Returns the configuration for the active platform.
  AppPlatformConfig? get currentPlatformConfig {
    try {
      if (Platform.isIOS) return ios;
      return android;
    } catch (_) {
      // In testing environments where Platform is not available
      return android ?? ios;
    }
  }

  String get targetVersion => currentPlatformConfig?.version ?? '1.0.0';
  bool get isForceUpdate => currentPlatformConfig?.forceUpdate ?? false;
  String get updateUrl => currentPlatformConfig?.updateUrl ?? '';

  // Backward compatibility getters
  String get latestVersion => targetVersion;
  String get minimumVersion => targetVersion;
  String get storeUrl => updateUrl;

  factory VersionConfigueModel.fromJson(Map<String, dynamic> json) {
    return VersionConfigueModel(
      android: json['android'] is Map<String, dynamic>
          ? AppPlatformConfig.fromJson(json['android'] as Map<String, dynamic>)
          : null,
      ios: json['ios'] is Map<String, dynamic>
          ? AppPlatformConfig.fromJson(json['ios'] as Map<String, dynamic>)
          : null,
      message:
          (json['message'] as String?) ??
          'A new version of JigroPay is available.',
    );
  }
}
