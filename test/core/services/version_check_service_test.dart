import 'package:flutter_test/flutter_test.dart';
import 'package:jigrotech/core/services/version_check_service.dart';
import 'package:jigrotech/features/home/data/models/version_configue_model.dart';
import 'package:version/version.dart';

void main() {
  group('VersionConfigueModel', () {
    test('parses real backend API structure correctly', () {
      final json = {
        'android': {
          'version': '2.1.0',
          'force_update': true,
          'update_url':
              'https://play.google.com/store/apps/details?id=com.jigropay.jigro',
        },
        'ios': {
          'version': '1.0.0',
          'force_update': false,
          'update_url': '',
        },
        'message': 'Please update to continue.',
      };

      final model = VersionConfigueModel.fromJson(json);

      expect(model.android?.version, '2.1.0');
      expect(model.android?.forceUpdate, true);
      expect(model.android?.updateUrl,
          'https://play.google.com/store/apps/details?id=com.jigropay.jigro');

      expect(model.ios?.version, '1.0.0');
      expect(model.ios?.forceUpdate, false);
      expect(model.ios?.updateUrl, '');

      expect(model.message, 'Please update to continue.');
    });

    test('backward-compatible getters return active platform values', () {
      final json = {
        'android': {
          'version': '2.1.0',
          'force_update': true,
          'update_url': 'https://example.com/playstore',
        },
      };

      final model = VersionConfigueModel.fromJson(json);
      expect(model.targetVersion, isNotEmpty);
      expect(model.latestVersion, model.targetVersion);
      expect(model.storeUrl, isNotEmpty);
    });
  });

  group('parseVersionString', () {
    test('parses clean semver correctly', () {
      final v = parseVersionString('2.1.0');
      expect(v, Version(2, 1, 0));
    });

    test('strips build numbers (+7, etc.) correctly', () {
      final v = parseVersionString('1.0.0+7');
      expect(v, Version(1, 0, 0));
    });

    test('normalizes two-part versions (e.g. 1.2)', () {
      final v = parseVersionString('1.2');
      expect(v, Version(1, 2, 0));
    });

    test('normalizes single-part versions (e.g. 2)', () {
      final v = parseVersionString('2');
      expect(v, Version(2, 0, 0));
    });

    test('gracefully falls back on invalid input', () {
      final v = parseVersionString('invalid');
      expect(v, Version(1, 0, 0));
    });
  });

  group('isUpdateRequired helper', () {
    test('returns true when installed version is lower than minimum', () {
      expect(
        isUpdateRequired(installedVersion: '1.0.0', minimumVersion: '2.0.0'),
        true,
      );
    });

    test('returns false when installed version is equal to minimum', () {
      expect(
        isUpdateRequired(installedVersion: '2.0.0', minimumVersion: '2.0.0'),
        false,
      );
    });

    test('returns false when installed version is higher than minimum', () {
      expect(
        isUpdateRequired(installedVersion: '2.1.0', minimumVersion: '2.0.0'),
        false,
      );
    });

    test('handles build numbers correctly', () {
      expect(
        isUpdateRequired(
          installedVersion: '1.0.0+7',
          minimumVersion: '1.0.1',
        ),
        true,
      );
      expect(
        isUpdateRequired(
          installedVersion: '1.0.1+7',
          minimumVersion: '1.0.1',
        ),
        false,
      );
    });
  });

  group('VersionCheckResult evaluation', () {
    test('evaluates force update condition accurately', () {
      const result = VersionCheckResult(
        isUpdateAvailable: true,
        isForceUpdate: true,
        installedVersion: '1.0.0',
        targetVersion: '2.1.0',
        updateUrl: 'https://example.com',
        message: 'Force update',
      );

      expect(result.isUpdateAvailable, true);
      expect(result.isForceUpdate, true);
    });

    test('evaluates optional update condition accurately', () {
      const result = VersionCheckResult(
        isUpdateAvailable: true,
        isForceUpdate: false,
        installedVersion: '2.0.0',
        targetVersion: '2.1.0',
        updateUrl: 'https://example.com',
        message: 'Optional update',
      );

      expect(result.isUpdateAvailable, true);
      expect(result.isForceUpdate, false);
    });

    test('noUpdate factory produces valid up-to-date state', () {
      final result = VersionCheckResult.noUpdate(installedVersion: '2.1.0');

      expect(result.isUpdateAvailable, false);
      expect(result.isForceUpdate, false);
      expect(result.installedVersion, '2.1.0');
    });
  });
}
