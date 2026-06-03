/// Semantic icon registry. Values are asset basenames under
/// `assets/icons/duo/<name>.svg` — true two-colour Solar Duotone icons,
/// recoloured to the FAD palette (tech blue + cyan). Render with [DuoIcon].
class FadIcons {
  const FadIcons._();

  // Bottom navigation — SOLID (Bold) icons, tinted flat. Duotone reads poorly
  // at nav size, so these use full-opacity single-colour art.
  static const String navRadar = 'nav_radar';
  static const String navLearn = 'nav_learn';
  static const String navProjects = 'nav_projects';
  static const String navProfile = 'nav_profile';

  // Primary navigation (single duotone art; active state handled by tint)
  static const String radar = 'radar';
  static const String radarFill = 'radar';
  static const String learn = 'learn';
  static const String learnFill = 'learn';
  static const String projects = 'projects';
  static const String projectsFill = 'projects';
  static const String profile = 'profile';
  static const String profileFill = 'profile';
  static const String messages = 'messages';
  static const String messagesFill = 'messages';

  // App bar / common actions
  static const String search = 'search';
  static const String bell = 'bell';
  static const String bookmark = 'bookmark';
  static const String bookmarkFill = 'bookmark';
  static const String share = 'share';
  static const String comment = 'comment';
  static const String flag = 'flag';
  static const String back = 'back';
  static const String forward = 'forward';
  static const String plus = 'plus';
  static const String close = 'close';
  static const String check = 'check';
  static const String checkCircle = 'check';
  static const String mail = 'mail';

  // Signal / content semantics
  static const String sparkle = 'sparkle';
  static const String fire = 'fire';
  static const String clock = 'clock';
  static const String lightning = 'lightning';
  static const String proof = 'proof';
  static const String shield = 'shield';
  static const String aiAssist = 'ai';
  static const String localScore = 'localscore';
  static const String lesson = 'lesson';
  static const String series = 'series';
  static const String glossary = 'glossary';
  static const String play = 'play';
  static const String test = 'test';

  // Engagement
  static const String like = 'like';

  // Messaging composer
  static const String mic = 'mic2';
  static const String camera = 'camera';
  static const String video = 'video';
  static const String send = 'send';
  static const String attach = 'attach';
  static const String emoji = 'emoji';
  static const String gallery = 'gallery';
  static const String file = 'file';

  // Settings / profile
  static const String gear = 'gear';
  static const String globe = 'globe';
  static const String sun = 'sun';
  static const String moon = 'moon';
  static const String autoTheme = 'autotheme';
  static const String dataSaver = 'datasaver';
  static const String offline = 'offline';
  static const String privacy = 'privacy';
  static const String about = 'about';
  static const String invite = 'invite';
  static const String logout = 'logout';
  static const String trophy = 'trophy';

  // Interests / categories
  static const String ai = 'ai';
  static const String code = 'code';
  static const String cyber = 'cyber';
  static const String mobile = 'mobile';
  static const String design = 'design';
  static const String business = 'business';
  static const String openSource = 'opensource';
  static const String africa = 'globe';
}
