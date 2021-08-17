import 'dart:io';

class AdManager {
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-2717753214455804~2046900334";
    } else if (Platform.isIOS) {
      return "ca-app-pub-2717753214455804~7666537451";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-2717753214455804/3764426247";
    } else if (Platform.isIOS) {
      return "ca-app-pub-2717753214455804/9474443141";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-2717753214455804/5646878772";
    } else if (Platform.isIOS) {
      return "ca-app-pub-2717753214455804/5324919921";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
