import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:labplus_for_gitlab/models/models.dart';
import 'package:labplus_for_gitlab/shared/constants/constants.dart';
import 'package:labplus_for_gitlab/shared/data/secure_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<SecureStorage> storageWith(SecureAppSettings settings) async {
    FlutterSecureStorage.setMockInitialValues({
      SecureStorageConstants.appSettings: settings.toJsonString(),
    });
    final storage = SecureStorage();
    await storage.init();
    return storage;
  }

  AppAccount account(int id) => AppAccount(
        userId: id,
        name: 'user$id',
        accessToken: 'token$id',
        refreshToken: 'refresh$id',
        baseUrl: 'https://gitlab.example',
      );

  group('getDefaultAccount', () {
    test('returns the account matching the default id', () async {
      final storage = await storageWith(
        SecureAppSettings(accounts: [account(1), account(2)], defaultId: 2),
      );

      expect(storage.getDefaultAccount()?.userId, 2);
    });

    // This used to be `singleWhere` with no `orElse`, which threw a bare
    // StateError. handleTokenExiration() calls it on every 401, so a signed-out
    // user hitting an expired token crashed instead of being sent to auth.
    test('returns null when there are no accounts', () async {
      final storage =
          await storageWith(SecureAppSettings(accounts: [], defaultId: -1));

      expect(storage.getDefaultAccount(), isNull);
    });

    test('returns null when the default id matches no account', () async {
      final storage = await storageWith(
        SecureAppSettings(accounts: [account(1)], defaultId: 99),
      );

      expect(storage.getDefaultAccount(), isNull);
    });

    test('survives storage that has never been written', () async {
      FlutterSecureStorage.setMockInitialValues({});
      final storage = SecureStorage();
      await storage.init();

      expect(storage.getDefaultAccount(), isNull);
      expect(storage.getAccounts(), isEmpty);
    });
  });

  group('init', () {
    test('adopts the default account token and base url', () async {
      final storage = await storageWith(
        SecureAppSettings(accounts: [account(1), account(2)], defaultId: 1),
      );

      expect(storage.getToken(), 'token1');
      expect(storage.getBaseurl(), 'https://gitlab.example');
    });
  });

  group('addUpdateAccount', () {
    test('persists a new account', () async {
      final storage =
          await storageWith(SecureAppSettings(accounts: [], defaultId: -1));

      await storage.addUpdateAccount(account(7));

      expect(storage.getAccounts().map((a) => a.userId), [7]);
    });

    test('replaces an existing account rather than duplicating it', () async {
      final storage = await storageWith(
        SecureAppSettings(accounts: [account(7)], defaultId: 7),
      );

      await storage.addUpdateAccount(account(7)..accessToken = 'rotated');

      final accounts = storage.getAccounts();
      expect(accounts, hasLength(1));
      expect(accounts.single.accessToken, 'rotated');
    });

    // The token-refresh path did not await this. A rotated credential could
    // still be unwritten when the next request read it back.
    test('has written through by the time the future completes', () async {
      final storage =
          await storageWith(SecureAppSettings(accounts: [], defaultId: -1));

      await storage.addUpdateAccount(account(7)..accessToken = 'rotated');

      final raw = await const FlutterSecureStorage()
          .read(key: SecureStorageConstants.appSettings);
      final persisted =
          SecureAppSettings.fromJson(json.decode(raw!) as Map<String, dynamic>);
      expect(persisted.accounts!.single.accessToken, 'rotated');
    });
  });
}
