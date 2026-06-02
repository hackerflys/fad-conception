import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppL10n
/// returned by `AppL10n.of(context)`.
///
/// Applications need to include `AppL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppL10n.localizationsDelegates,
///   supportedLocales: AppL10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppL10n.supportedLocales
/// property.
abstract class AppL10n {
  AppL10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppL10n of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n)!;
  }

  static const LocalizationsDelegate<AppL10n> delegate = _AppL10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'FAD Conception'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'The verified tech radar'**
  String get tagline;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @navRadar.
  ///
  /// In en, this message translates to:
  /// **'Radar'**
  String get navRadar;

  /// No description provided for @navLearn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get navLearn;

  /// No description provided for @navProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get navProjects;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get navMessages;

  /// No description provided for @actionNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get actionNext;

  /// No description provided for @actionSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get actionSkip;

  /// No description provided for @actionStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get actionStart;

  /// No description provided for @actionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get actionShare;

  /// No description provided for @actionComment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get actionComment;

  /// No description provided for @actionReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get actionReport;

  /// No description provided for @actionSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get actionSend;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// No description provided for @actionSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get actionSeeAll;

  /// No description provided for @actionOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get actionOpen;

  /// No description provided for @onboardTitle1.
  ///
  /// In en, this message translates to:
  /// **'Discover verified tech'**
  String get onboardTitle1;

  /// No description provided for @onboardBody1.
  ///
  /// In en, this message translates to:
  /// **'Every day, a useful tech signal backed by clear proof.'**
  String get onboardBody1;

  /// No description provided for @onboardTitle2.
  ///
  /// In en, this message translates to:
  /// **'Learn in 60 seconds'**
  String get onboardTitle2;

  /// No description provided for @onboardBody2.
  ///
  /// In en, this message translates to:
  /// **'Simple mini-lessons to understand and take action fast.'**
  String get onboardBody2;

  /// No description provided for @onboardTitle3.
  ///
  /// In en, this message translates to:
  /// **'Show your project'**
  String get onboardTitle3;

  /// No description provided for @onboardBody3.
  ///
  /// In en, this message translates to:
  /// **'Publish your app, tool, research or prototype with real proof.'**
  String get onboardBody3;

  /// No description provided for @interestsTitle.
  ///
  /// In en, this message translates to:
  /// **'What are you into?'**
  String get interestsTitle;

  /// No description provided for @interestsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a few topics to tune your radar.'**
  String get interestsSubtitle;

  /// No description provided for @authTitle.
  ///
  /// In en, this message translates to:
  /// **'Join FAD Conception'**
  String get authTitle;

  /// No description provided for @authSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stays readable without an account.'**
  String get authSubtitle;

  /// No description provided for @authGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authGoogle;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with email'**
  String get authEmail;

  /// No description provided for @authGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue without account'**
  String get authGuest;

  /// No description provided for @radarSignalOfDay.
  ///
  /// In en, this message translates to:
  /// **'Signal of the day'**
  String get radarSignalOfDay;

  /// No description provided for @radarFilterForYou.
  ///
  /// In en, this message translates to:
  /// **'For you'**
  String get radarFilterForYou;

  /// No description provided for @radarFilterRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get radarFilterRecent;

  /// No description provided for @radarFilterPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get radarFilterPopular;

  /// No description provided for @radarFilterCameroon.
  ///
  /// In en, this message translates to:
  /// **'Cameroon'**
  String get radarFilterCameroon;

  /// No description provided for @radarSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search signals, projects, lessons'**
  String get radarSearchHint;

  /// No description provided for @signalIn10s.
  ///
  /// In en, this message translates to:
  /// **'In 10 seconds'**
  String get signalIn10s;

  /// No description provided for @signalWhy.
  ///
  /// In en, this message translates to:
  /// **'Why it matters'**
  String get signalWhy;

  /// No description provided for @signalProof.
  ///
  /// In en, this message translates to:
  /// **'The proof'**
  String get signalProof;

  /// No description provided for @signalLocalScore.
  ///
  /// In en, this message translates to:
  /// **'Local score'**
  String get signalLocalScore;

  /// No description provided for @signalLinkedLesson.
  ///
  /// In en, this message translates to:
  /// **'Linked mini-lesson'**
  String get signalLinkedLesson;

  /// No description provided for @signalRelated.
  ///
  /// In en, this message translates to:
  /// **'Related signals'**
  String get signalRelated;

  /// No description provided for @signalTestNow.
  ///
  /// In en, this message translates to:
  /// **'Test now'**
  String get signalTestNow;

  /// No description provided for @signalVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified proof'**
  String get signalVerified;

  /// No description provided for @signalAiAssisted.
  ///
  /// In en, this message translates to:
  /// **'AI assisted'**
  String get signalAiAssisted;

  /// No description provided for @signalHumanReview.
  ///
  /// In en, this message translates to:
  /// **'Human validation'**
  String get signalHumanReview;

  /// No description provided for @learnTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learnTitle;

  /// No description provided for @learnFullPathsSoon.
  ///
  /// In en, this message translates to:
  /// **'Full learning paths coming soon'**
  String get learnFullPathsSoon;

  /// No description provided for @learnNotifyMe.
  ///
  /// In en, this message translates to:
  /// **'Notify me'**
  String get learnNotifyMe;

  /// No description provided for @learnMiniLessons.
  ///
  /// In en, this message translates to:
  /// **'Mini-lessons · 60 seconds'**
  String get learnMiniLessons;

  /// No description provided for @learnSeries.
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get learnSeries;

  /// No description provided for @learnGlossary.
  ///
  /// In en, this message translates to:
  /// **'Tech glossary'**
  String get learnGlossary;

  /// No description provided for @lessonMarkDone.
  ///
  /// In en, this message translates to:
  /// **'Mark as done'**
  String get lessonMarkDone;

  /// No description provided for @lessonKeyTakeaway.
  ///
  /// In en, this message translates to:
  /// **'Key takeaway'**
  String get lessonKeyTakeaway;

  /// No description provided for @lessonNext.
  ///
  /// In en, this message translates to:
  /// **'Next lesson'**
  String get lessonNext;

  /// No description provided for @projectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Projects to discover'**
  String get projectsTitle;

  /// No description provided for @projectsSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get projectsSubmit;

  /// No description provided for @projectNeedsTesters.
  ///
  /// In en, this message translates to:
  /// **'Testers'**
  String get projectNeedsTesters;

  /// No description provided for @projectNeedsDevs.
  ///
  /// In en, this message translates to:
  /// **'Developers'**
  String get projectNeedsDevs;

  /// No description provided for @projectNeedsSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get projectNeedsSupport;

  /// No description provided for @projectSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get projectSupport;

  /// No description provided for @projectJoin.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get projectJoin;

  /// No description provided for @submitProjectTitle.
  ///
  /// In en, this message translates to:
  /// **'Submit a project'**
  String get submitProjectTitle;

  /// No description provided for @submitDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get submitDraft;

  /// No description provided for @submitForReview.
  ///
  /// In en, this message translates to:
  /// **'Send for review'**
  String get submitForReview;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get profileSaved;

  /// No description provided for @profileSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted projects'**
  String get profileSubmitted;

  /// No description provided for @profileProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get profileProgress;

  /// No description provided for @profileInvite.
  ///
  /// In en, this message translates to:
  /// **'Invite a friend'**
  String get profileInvite;

  /// No description provided for @profileContributorLevel.
  ///
  /// In en, this message translates to:
  /// **'Contributor level'**
  String get profileContributorLevel;

  /// No description provided for @statProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get statProjects;

  /// No description provided for @statLessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get statLessons;

  /// No description provided for @statShares.
  ///
  /// In en, this message translates to:
  /// **'Shares'**
  String get statShares;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsData.
  ///
  /// In en, this message translates to:
  /// **'Data & connection'**
  String get settingsData;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacy;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsDataSaver.
  ///
  /// In en, this message translates to:
  /// **'Data saver'**
  String get settingsDataSaver;

  /// No description provided for @settingsOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline reading'**
  String get settingsOffline;

  /// No description provided for @settingsClearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear cache'**
  String get settingsClearCache;

  /// No description provided for @messagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messagesTitle;

  /// No description provided for @messagesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get messagesEmpty;

  /// No description provided for @messageHint.
  ///
  /// In en, this message translates to:
  /// **'Write a message'**
  String get messageHint;

  /// No description provided for @messageVoice.
  ///
  /// In en, this message translates to:
  /// **'Voice note'**
  String get messageVoice;

  /// No description provided for @messagePhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get messagePhoto;

  /// No description provided for @messageVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get messageVideo;

  /// No description provided for @messageText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get messageText;

  /// No description provided for @stateEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get stateEmpty;

  /// No description provided for @stateError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get stateError;

  /// No description provided for @stateOffline.
  ///
  /// In en, this message translates to:
  /// **'You are offline'**
  String get stateOffline;

  /// No description provided for @adminTitle.
  ///
  /// In en, this message translates to:
  /// **'Validation'**
  String get adminTitle;

  /// No description provided for @adminApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get adminApprove;

  /// No description provided for @adminReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get adminReject;

  /// No description provided for @adminRequestFix.
  ///
  /// In en, this message translates to:
  /// **'Request changes'**
  String get adminRequestFix;

  /// No description provided for @adminSetSignalOfDay.
  ///
  /// In en, this message translates to:
  /// **'Set as signal of the day'**
  String get adminSetSignalOfDay;
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(lookupAppL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppL10nDelegate old) => false;
}

AppL10n lookupAppL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppL10nEn();
    case 'fr':
      return AppL10nFr();
  }

  throw FlutterError(
    'AppL10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
