import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';
import 'package:jigrotech/core/constants/app_endpoints.dart';
import 'package:jigrotech/core/network/api_client.dart';
import 'package:jigrotech/features/home/data/models/version_configue_model.dart';

/// Represents the evaluated version check result.
class VersionCheckResult {
  final bool isUpdateAvailable;
  final bool isForceUpdate;
  final String installedVersion;
  final String targetVersion;
  final String updateUrl;
  final String message;

  const VersionCheckResult({
    required this.isUpdateAvailable,
    required this.isForceUpdate,
    required this.installedVersion,
    required this.targetVersion,
    required this.updateUrl,
    required this.message,
  });

  factory VersionCheckResult.noUpdate({
    required String installedVersion,
    String? updateUrl,
  }) {
    return VersionCheckResult(
      isUpdateAvailable: false,
      isForceUpdate: false,
      installedVersion: installedVersion,
      targetVersion: installedVersion,
      updateUrl: updateUrl ?? '',
      message: '',
    );
  }
}

class VersionCheckService {
  final ApiClient _apiClient;

  VersionCheckService([ApiClient? apiClient])
    : _apiClient = apiClient ?? ApiClient.instance;

  /// Fetches raw version configuration from the server.
  Future<VersionConfigueModel> getVersionConfig() async {
    final response = await _apiClient.get(AppEndpoints.versionControl);
    final data = response.data['data'] as Map<String, dynamic>;
    return VersionConfigueModel.fromJson(data);
  }

  Future<VersionCheckResult> checkAppVersion({
    String? overrideInstalledVersion,
  }) async {
    final config = await getVersionConfig();

    //. Get installed Version
    final installedVersionStr =
        overrideInstalledVersion ?? (await PackageInfo.fromPlatform()).version;

    final installed = parseVersionString(installedVersionStr);
    final target = parseVersionString(config.targetVersion);

    final isUpdateAvailable = installed < target;
    final isForceUpdate = isUpdateAvailable && config.isForceUpdate;

    return VersionCheckResult(
      isUpdateAvailable: isUpdateAvailable,
      isForceUpdate: isForceUpdate,
      installedVersion: installedVersionStr,
      targetVersion: config.targetVersion,
      updateUrl: config.updateUrl,
      message: config.message,
    );
  }
}

Version parseVersionString(String ver) {
  try {
    // Strip build numbers, trailing comments or metadata (e.g. +7)
    final cleanVer = ver.split('+').first.trim();
    final parts = cleanVer.split('.');
    if (parts.isEmpty || cleanVer.isEmpty) {
      return Version(1, 0, 0);
    }
    if (parts.length == 1) {
      return Version(int.tryParse(parts[0]) ?? 1, 0, 0);
    } else if (parts.length == 2) {
      return Version(
        int.tryParse(parts[0]) ?? 1,
        int.tryParse(parts[1]) ?? 0,
        0,
      );
    }
    return Version.parse(cleanVer);
  } catch (_) {
    return Version(1, 0, 0);
  }
}

/// Version Update Checker helper function.
bool isUpdateRequired({
  required String installedVersion,
  required String minimumVersion,
}) {
  final installed = parseVersionString(installedVersion);
  final minimum = parseVersionString(minimumVersion);

  return installed < minimum;
}
