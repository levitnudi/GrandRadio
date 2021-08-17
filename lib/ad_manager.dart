import 'dart:io';

class AdManager {
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-2629753334484842~3684202054";
    } else if (Platform.isIOS) {
      return "ca-app-pub-2629753334484842~4314757442";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-2629753334484842/9674895339";
    } else if (Platform.isIOS) {
      return "ca-app-pub-2629753334484842/6338285558";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-2629753334484842/6805189416";
    } else if (Platform.isIOS) {
      return "ca-app-pub-2629753334484842/7459795539";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
