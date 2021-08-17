import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../constants.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final InAppReview inAppReview = InAppReview.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white10,
          toolbarHeight: 80,
          textTheme: Theme.of(context).textTheme,
          iconTheme: Theme.of(context).iconTheme,
          title: Text("Settings"),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
        child: Column(
    children: <Widget>[
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("About us"),
              subtitle: Text("City of God's mission for this radio is making Jesus Known. Learn more"),
              onTap: () {
                _launchURL('https://coggrandradiouk.org');
              },
            ),
            ListTile(
              leading: Icon(Icons.card_giftcard),
              title: Text("Donate"),
              subtitle: Text("We are reaching millions through your giving."),
              onTap: () {
                _launchURL('https://coggrandradiouk.org/donations/make-jesus-known/');
              },
            ),
            ListTile(
              leading: Icon(Icons.supervised_user_circle_outlined),
              title: Text("Advertise"),
              subtitle: Text("Promote your business. Learn more"),
              onTap: () {
                _launchURL('https://coggrandradiouk.org/promote/');
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text("Share the app"),
              subtitle: Text("If you like it, share it :-)"),
              onTap: share_app,
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text("Rate the app"),
              subtitle: Text("Leave a review for this app"),
              onTap: _review,
            ),
            ListTile(
              leading: Icon(Icons.verified),
              title: Text("App Version"),
              subtitle: Text("1.0.0"),
            ),
            Text("Made with ♥️ in Newcastle, UK")
          ],
        )));
  }

  void _review() async {
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }

  void share_app(){
    if (Platform.isAndroid) {
      Share.share('I am listening to COG $appname. Download the app here\n'
          'https://play.google.com/store/apps/details?id=$androidPackage&hl=en');
    } else {
      Share.share('I am listening to COG $appname. Download the app here\n'
          '$iosPackage');
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
