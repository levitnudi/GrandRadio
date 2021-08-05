import 'package:flutter/material.dart';
import '../model/station.dart';

class StationCard extends StatelessWidget {
  const StationCard({Key key, @required this.item, this.radius = 16})
      : super(key: key);

  final Station item;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Card(
        elevation: 8,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius))),
        child: ClipPath(
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius))),
            child:
                Image.network(item.imgurl, fit: BoxFit.fill, height: height)));
  }
}
