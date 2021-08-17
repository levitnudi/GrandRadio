import 'package:flutter/material.dart';

class PlayerController extends StatelessWidget {
  const PlayerController(
      {Key key,
      this.isPlaying,
      this.playOrPause,
      this.previous,
      this.next,
      this.isDisabled})
      : super(key: key);

  final VoidCallback previous;
  final VoidCallback next;
  final VoidCallback playOrPause;
  final bool isPlaying;
  final bool isDisabled;

  static const STATUS_PLAYING = "status_playing";
  static const STATUS_PAUSED = "status_paused";
  static const STATUS_LOADING = "status_loading";

  @override
  Widget build(BuildContext context) {
    double size = isPlaying ? 80 : 90;
    return FittedBox(
        fit: BoxFit.contain,
        child:
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              padding: EdgeInsets.all(30),
              onPressed: previous,
              icon: Icon(Icons.arrow_back),
              iconSize: 30),
          AnimatedContainer(
            width: size,
            height: size,
            curve: Curves.bounceOut,
            duration: Duration(milliseconds: 120),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 6,
                    blurRadius: 7,
                  )
                ],
                color: isDisabled
                    ? Theme.of(context).primaryColorLight
                    : Theme.of(context).primaryColor,
                shape: BoxShape.circle),
            child: isDisabled
                ? IconButton(
                    iconSize: 30,
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                    onPressed: playOrPause,
                  )
                : IconButton(
                    iconSize: 30,
                    icon: isPlaying
                        ? Icon(
                            Icons.pause,
                            color: Colors.white,
                          )
                        : Icon(Icons.play_arrow, color: Colors.white),
                    onPressed: playOrPause,
                  ),
          ),
          IconButton(
            padding: EdgeInsets.all(30),
            onPressed: next,
            icon: Icon(Icons.arrow_forward),
            iconSize: 30,
          )
        ]));
  }
}
