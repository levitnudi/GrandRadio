import 'dart:async';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:admob_flutter/admob_flutter.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';
import 'package:grand_radio/components/player.dart';
import 'package:grand_radio/screens/settings.dart';

import '../ad_manager.dart';
import '../components/header.dart';
import '../constants.dart';
import '../model/station.dart';
import '../components/station_card.dart';
import '../radio_controller.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  var playerState = FlutterRadioPlayer.flutter_radio_paused;
  var volume = 0.8;
  var interstitialCounter = kShowAdAfter; // how many

  bool count() {
    if (interstitialCounter < 0) {
      interstitialCounter = kShowAdAfter;
    }

    interstitialCounter -= 1;
    return interstitialCounter == 0;
  }

  List list;
  FlutterRadioPlayer _flutterRadioPlayer = new FlutterRadioPlayer();
  final CarouselController _controller = CarouselController();
  Station _station;
  String songTitle = "";
  int _selectedIndex = 0;

  // Admob
  AdmobBannerSize bannerSize;
  AdmobInterstitial interstitialAd;

  @override
  void initState() {
    super.initState();
    bannerSize = AdmobBannerSize.BANNER;
    if (kShowAd) {
      interstitialAd = AdmobInterstitial(
        adUnitId: AdManager.interstitialAdUnitId,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          if (event == AdmobAdEvent.closed) interstitialAd.load();
          handleEvent(event, args, 'Interstitial');
        },
      );

      interstitialAd.load();
    }
    _loadStations();
  }

  @override
  void dispose() {
    if (kShowAd) {
      interstitialAd.dispose();
    }
    _controller.stopAutoPlay();
    super.dispose();
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    print(adType + ": " + event.toString());
  }

  Future<void> _loadStations() async {
    list = await loadStations();
    _station = list[0];
    await initRadioService();
    if (kShowAd) {
      await Admob.requestTrackingAuthorization();
    }
    setState(() {});
  }

  Future<void> initRadioService() async {
    try {
      await _flutterRadioPlayer.init(
          _station.title, "Live", _station.url, "false");
    } on PlatformException {
      print("Exception occurred while trying to register the services.");
    }
  }

  Future<void> onPageChange(
      int index, CarouselPageChangedReason changeReason) async {
    Station item = list[index];
    selectStation(item);
  }

  Future<void> selectStation(Station item) async {
    _station = item;
    print("Selected: " + item.title);
    await _flutterRadioPlayer.stop();
    await _flutterRadioPlayer.init(item.title, "Live", item.url, "true");
    await _flutterRadioPlayer.play();
    volume = 1;
    songTitle = await _flutterRadioPlayer.currentSongTitle();

    if (count() && kShowAd) {
      print("Display interstitialAd");
      if (await interstitialAd.isLoaded) {
        interstitialAd.show();
      }
    }

    setState(() {});
  }

  void _onItemTapped(int index) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsScreen()));
  }

  Future<bool> _onBackPressed() async {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit this radio'),
            actions: <Widget>[
              TextButton(
                child: Text("NO"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text("Exit"),
                onPressed: () async {
                  await _flutterRadioPlayer.stop();
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 0.3;

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          body: list == null
              ? Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    Header(),
                    SafeArea(
                        child: Column(
                      children: [
                        kShowAd
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AdmobBanner(
                                    adUnitId: AdManager.bannerAdUnitId,
                                    adSize: bannerSize,
                                    listener: (AdmobAdEvent event,
                                        Map<String, dynamic> args) {
                                      handleEvent(event, args, 'Banner');
                                    },
                                  )
                                ],
                              )
                            : Row(),
                        Spacer(),
                        CarouselSlider(
                          options: CarouselOptions(
                            onPageChanged: onPageChange,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: false,
                            height: height,
                            viewportFraction: 0.6,
                            aspectRatio: 3 / 4,
                          ),
                          items: list
                              .map((item) => StationCard(
                                    item: item,
                                    radius: 48,
                                  ))
                              .toList(),
                          carouselController: _controller,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Text(_station.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4)),
                                StreamBuilder<String>(
                                    initialData: "",
                                    stream: _flutterRadioPlayer.metaDataStream,
                                    builder: (context, snapshot) {
                                      return Text(
                                        snapshot.data,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      );
                                    })
                              ]),
                        ),
                        SizedBox(
                          height: 120,
                          child: StreamBuilder(
                              stream: _flutterRadioPlayer.isPlayingStream,
                              initialData: playerState,
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                String returnData = snapshot.data;

                                switch (returnData) {
                                  case FlutterRadioPlayer.flutter_radio_loading:
                                    return PlayerController(
                                      isPlaying: false,
                                      playOrPause: () {},
                                      previous: _controller.previousPage,
                                      next: _controller.nextPage,
                                      isDisabled: true,
                                    );
                                  case FlutterRadioPlayer.flutter_radio_error:
                                    return ElevatedButton(
                                        child: Text("Retry ?"),
                                        onPressed: () async {
                                          await initRadioService();
                                        });
                                    break;
                                  default:
                                    return PlayerController(
                                      isPlaying: returnData ==
                                          FlutterRadioPlayer
                                              .flutter_radio_playing,
                                      playOrPause: () {
                                        setState(() {
                                          _flutterRadioPlayer.playOrPause();
                                        });
                                      },
                                      previous: _controller.previousPage,
                                      next: _controller.nextPage,
                                      isDisabled: false,
                                    );
                                    break;
                                }
                              }),
                        ),
                        Slider(
                            value: volume,
                            min: 0,
                            max: 1.0,
                            onChanged: (value) => setState(() {
                                  volume = value;
                                  _flutterRadioPlayer.setVolume(volume);
                                })),
                        Spacer(),
                      ],
                    ))
                  ],
                ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.radio),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'About',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ));
  }
}
