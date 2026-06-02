import 'package:flutter/widgets.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Semantic, rounded **duotone** icon set for FAD.
/// Inactive states use duotone; active/selected states use the filled twin
/// so the brand gradient reads clearly. One source of truth for all icons.
class FadIcons {
  const FadIcons._();

  // Primary navigation
  static const IconData radar = PhosphorIconsDuotone.broadcast;
  static const IconData radarFill = PhosphorIconsFill.broadcast;
  static const IconData learn = PhosphorIconsDuotone.graduationCap;
  static const IconData learnFill = PhosphorIconsFill.graduationCap;
  static const IconData projects = PhosphorIconsDuotone.rocketLaunch;
  static const IconData projectsFill = PhosphorIconsFill.rocketLaunch;
  static const IconData profile = PhosphorIconsDuotone.userCircle;
  static const IconData profileFill = PhosphorIconsFill.userCircle;
  static const IconData messages = PhosphorIconsDuotone.chatCircleDots;
  static const IconData messagesFill = PhosphorIconsFill.chatCircleDots;

  // App bar / common actions
  static const IconData search = PhosphorIconsDuotone.magnifyingGlass;
  static const IconData bell = PhosphorIconsDuotone.bellSimple;
  static const IconData bookmark = PhosphorIconsDuotone.bookmarkSimple;
  static const IconData bookmarkFill = PhosphorIconsFill.bookmarkSimple;
  static const IconData share = PhosphorIconsDuotone.shareNetwork;
  static const IconData comment = PhosphorIconsDuotone.chatCircleText;
  static const IconData flag = PhosphorIconsDuotone.flag;
  static const IconData back = PhosphorIconsBold.caretLeft;
  static const IconData forward = PhosphorIconsBold.caretRight;
  static const IconData plus = PhosphorIconsBold.plus;
  static const IconData close = PhosphorIconsBold.x;
  static const IconData check = PhosphorIconsBold.check;
  static const IconData checkCircle = PhosphorIconsDuotone.checkCircle;

  // Signal / content semantics
  static const IconData sparkle = PhosphorIconsDuotone.sparkle;
  static const IconData fire = PhosphorIconsDuotone.fire;
  static const IconData clock = PhosphorIconsDuotone.clock;
  static const IconData lightning = PhosphorIconsDuotone.lightning;
  static const IconData proof = PhosphorIconsDuotone.sealCheck;
  static const IconData shield = PhosphorIconsDuotone.shieldCheck;
  static const IconData aiAssist = PhosphorIconsDuotone.brain;
  static const IconData localScore = PhosphorIconsDuotone.mapPin;
  static const IconData lesson = PhosphorIconsDuotone.bookOpenText;
  static const IconData series = PhosphorIconsDuotone.stackSimple;
  static const IconData glossary = PhosphorIconsDuotone.bookmarks;
  static const IconData play = PhosphorIconsFill.playCircle;
  static const IconData test = PhosphorIconsDuotone.flask;

  // Messaging composer
  static const IconData mic = PhosphorIconsDuotone.microphone;
  static const IconData camera = PhosphorIconsDuotone.camera;
  static const IconData video = PhosphorIconsDuotone.videoCamera;
  static const IconData send = PhosphorIconsFill.paperPlaneRight;
  static const IconData attach = PhosphorIconsDuotone.paperclip;

  // Settings / profile
  static const IconData gear = PhosphorIconsDuotone.gearSix;
  static const IconData globe = PhosphorIconsDuotone.globeHemisphereWest;
  static const IconData sun = PhosphorIconsDuotone.sun;
  static const IconData moon = PhosphorIconsDuotone.moon;
  static const IconData autoTheme = PhosphorIconsDuotone.circleHalf;
  static const IconData dataSaver = PhosphorIconsDuotone.cellSignalMedium;
  static const IconData offline = PhosphorIconsDuotone.cloudArrowDown;
  static const IconData privacy = PhosphorIconsDuotone.lockKey;
  static const IconData about = PhosphorIconsDuotone.info;
  static const IconData invite = PhosphorIconsDuotone.userPlus;
  static const IconData logout = PhosphorIconsDuotone.signOut;
  static const IconData trophy = PhosphorIconsDuotone.trophy;

  // Interests / categories
  static const IconData ai = PhosphorIconsDuotone.brain;
  static const IconData code = PhosphorIconsDuotone.code;
  static const IconData cyber = PhosphorIconsDuotone.shieldStar;
  static const IconData mobile = PhosphorIconsDuotone.deviceMobile;
  static const IconData design = PhosphorIconsDuotone.palette;
  static const IconData business = PhosphorIconsDuotone.briefcase;
  static const IconData openSource = PhosphorIconsDuotone.gitBranch;
  static const IconData africa = PhosphorIconsDuotone.globeStand;
}
