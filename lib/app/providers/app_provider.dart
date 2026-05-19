import 'package:flutter/material.dart';
import '/app/networking/api_service.dart';
import '/config/storage_keys.dart';
import '/config/toast_notification.dart';
import '/bootstrap/decoders.dart';
import '/config/design.dart';
import '/bootstrap/theme.dart';
import '/config/localization.dart';
import 'package:nylo_framework/nylo_framework.dart';

class AppProvider implements NyProvider {

  @override
  setup(Nylo nylo) async {
    await nylo.configure(
      localization: NyLocalizationConfig(
          languageCode: LocalizationConfig.languageCode,
          localeType: LocalizationConfig.localeType,
          assetsDirectory: LocalizationConfig.assetsDirectory
      ),
      loader: DesignConfig.loader,
      logo: DesignConfig.logo,
      themes: appThemes,
      initialThemeId: 'light_theme',
      toastNotifications: ToastNotificationConfig.styles,
      modelDecoders: modelDecoders,
      controllers: controllers,
      apiDecoders: apiDecoders,
      authKey: StorageKeysConfig.auth,
      syncKeys: StorageKeysConfig.syncedOnBoot,
      monitorAppUsage: false,
      showDateTimeInLogs: false,
      broadcastEvents: false,
      useErrorStack: true,
    );

    return nylo;
  }

  @override
  boot(Nylo nylo) async {
    WidgetsBinding.instance.addObserver(_AuthRefreshObserver());
  }
}

/// Refreshes staff data (capabilities, membership) from /auth/me
/// every time the app comes back to foreground.
class _AuthRefreshObserver with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refresh();
    }
  }

  Future<void> _refresh() async {
    if (Auth.data() == null) return;
    try {
      final response = await api<ApiService>((s) => s.me());
      if (response?['user'] != null) {
        await Auth.set((data) => {
          ...(data as Map? ?? {}),
          'staff': response['user'],
        });
      }
    } catch (_) {}
  }
}
