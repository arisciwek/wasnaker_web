import 'package:nylo_framework/nylo_framework.dart';

/* Keys
|--------------------------------------------------------------------------
| Storage keys are used to read and write to local storage.
| Example: String coins = await StorageKeysConfig.coins.read();
|
| Learn more: https://nylo.dev/docs/7.x/storage#storage-keys
|-------------------------------------------------------------------------- */

final class StorageKeysConfig {
  // Define the keys you want to be synced on boot
  static syncedOnBoot() => () async {
        return [
          auth,
          bearerToken,
          // coins.defaultValue(10), // give the user 10 coins by default
        ];
      };

  static StorageKey auth = 'SK_USER';

  static StorageKey bearerToken = 'SK_BEARER_TOKEN';

  // static StorageKey coins = 'SK_COINS';

  /// Add your storage keys here...
}
