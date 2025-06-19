import 'package:flutter/material.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

class AdManager {
  static final AdManager _instance = AdManager._internal();
  factory AdManager() => _instance;
  AdManager._internal();

  InterstitialAd? _ad;
  InterstitialAdLoader? _loader;
  int _tapCounter = 0;
  final int _threshold = 3;

  Future<void> init() async {
    try {
      _loader = await InterstitialAdLoader.create(
        onAdLoaded: (ad) {
          print('[AdManager] Ad loaded');
          _ad = ad;
        },
        onAdFailedToLoad: (e) {
          print('[AdManager] Failed to load ad: ${e.description}');
        },
      );
      await _loadAd();
    } catch (e, stack) {
      print('[AdManager] init error: $e\n$stack');
    }
  }

  Future<void> _loadAd() async {
    if (_loader == null) {
      print('[AdManager] Loader is null');
      return;
    }
    print('[AdManager] Loading ad...');
    try {
      await _loader!.loadAd(
        adRequestConfiguration: const AdRequestConfiguration(
          adUnitId: 'R-M-15627392-1',

          age: 24,
        ),
      );
    } catch (e, stack) {
      print('[AdManager] loadAd error: $e\n$stack');
    }
  }

  void _disposeAd() {
    try {
      _ad?.destroy();
      _ad = null;
      print('[AdManager] Ad disposed');
    } catch (e) {
      print('[AdManager] dispose error: $e');
    }
  }

  Future<void> maybeShowAd({
    required BuildContext context,
    required VoidCallback onFinish,
  }) async {
    print('[AdManager] maybeShowAd called, tap count: $_tapCounter');
    _tapCounter++;

    if (_tapCounter % _threshold == 0) {
      if (_ad == null) {
        print('[AdManager] Ad is null, skipping ad show');
        await _loadAd(); // попробовать загрузить новую
        onFinish();
        return;
      }

      try {
        _ad!.setAdEventListener(
          eventListener: InterstitialAdEventListener(
            onAdDismissed: () {
              print('[AdManager] Ad dismissed');
              _reload();
              onFinish();
            },
            onAdFailedToShow: (e) {
              print('[AdManager] Ad failed to show: ${e.description}');
              _reload();
              onFinish();
            },
          ),
        );
        print('[AdManager] Showing ad...');
        _ad!.show();
      } catch (e, stack) {
        print('[AdManager] show error: $e\n$stack');
        _reload();
        onFinish();
      }
    } else {
      onFinish();
    }
  }

  void _reload() {
    print('[AdManager] Reloading ad...');
    _disposeAd();
    _loadAd();
  }

  void dispose() {
    print('[AdManager] Disposing...');
    _disposeAd();
  }
}
