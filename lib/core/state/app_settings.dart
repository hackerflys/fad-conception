import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Injected in main() after SharedPreferences is ready.
final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPrefsProvider must be overridden in main()');
});

@immutable
class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.dark,
    this.locale,
    this.onboardingDone = false,
    this.dataSaver = false,
    this.offlineReading = true,
    this.interests = const <String>{},
    this.isGuest = false,
  });

  final ThemeMode themeMode;
  final Locale? locale; // null = follow system
  final bool onboardingDone;
  final bool dataSaver;
  final bool offlineReading;
  final Set<String> interests;
  final bool isGuest;

  AppSettings copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool clearLocale = false,
    bool? onboardingDone,
    bool? dataSaver,
    bool? offlineReading,
    Set<String>? interests,
    bool? isGuest,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      locale: clearLocale ? null : (locale ?? this.locale),
      onboardingDone: onboardingDone ?? this.onboardingDone,
      dataSaver: dataSaver ?? this.dataSaver,
      offlineReading: offlineReading ?? this.offlineReading,
      interests: interests ?? this.interests,
      isGuest: isGuest ?? this.isGuest,
    );
  }
}

class SettingsController extends Notifier<AppSettings> {
  static const _kTheme = 'fad.themeMode';
  static const _kLocale = 'fad.locale';
  static const _kOnboard = 'fad.onboardingDone';
  static const _kDataSaver = 'fad.dataSaver';
  static const _kOffline = 'fad.offlineReading';
  static const _kInterests = 'fad.interests';
  static const _kGuest = 'fad.isGuest';

  SharedPreferences get _p => ref.read(sharedPrefsProvider);

  @override
  AppSettings build() {
    final themeIdx = _p.getInt(_kTheme) ?? ThemeMode.dark.index;
    final localeCode = _p.getString(_kLocale);
    return AppSettings(
      themeMode: ThemeMode.values[themeIdx.clamp(0, ThemeMode.values.length - 1)],
      locale: localeCode == null ? null : Locale(localeCode),
      onboardingDone: _p.getBool(_kOnboard) ?? false,
      dataSaver: _p.getBool(_kDataSaver) ?? false,
      offlineReading: _p.getBool(_kOffline) ?? true,
      interests: (_p.getStringList(_kInterests) ?? const []).toSet(),
      isGuest: _p.getBool(_kGuest) ?? false,
    );
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    _p.setInt(_kTheme, mode.index);
  }

  void setLocale(Locale? locale) {
    state = state.copyWith(locale: locale, clearLocale: locale == null);
    if (locale == null) {
      _p.remove(_kLocale);
    } else {
      _p.setString(_kLocale, locale.languageCode);
    }
  }

  void completeOnboarding() {
    state = state.copyWith(onboardingDone: true);
    _p.setBool(_kOnboard, true);
  }

  void setDataSaver(bool v) {
    state = state.copyWith(dataSaver: v);
    _p.setBool(_kDataSaver, v);
  }

  void setOfflineReading(bool v) {
    state = state.copyWith(offlineReading: v);
    _p.setBool(_kOffline, v);
  }

  void toggleInterest(String id) {
    final next = {...state.interests};
    next.contains(id) ? next.remove(id) : next.add(id);
    state = state.copyWith(interests: next);
    _p.setStringList(_kInterests, next.toList());
  }

  void continueAsGuest() {
    state = state.copyWith(isGuest: true);
    _p.setBool(_kGuest, true);
  }
}

final settingsProvider =
    NotifierProvider<SettingsController, AppSettings>(SettingsController.new);
