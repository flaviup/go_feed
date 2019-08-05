import 'package:flutter/material.dart';
import 'package:go_feed/model/activity.dart';
import 'package:geocoder/geocoder.dart';
import 'package:timeago/timeago.dart' as TimeAgo;

class ActivityFeedItem extends StatefulWidget {

  ActivityFeedItem({Key key, @required this.activity, @required this.animation, this.onTap, this.selected = false, }) :
        assert(activity != null),
        assert(animation != null),
        assert(selected != null),
        super(key: key);

  final Activity activity;
  final Animation<double> animation;
  final VoidCallback onTap;
  final bool selected;

  @override
  _ActivityFeedItemState createState() => _ActivityFeedItemState();
}

class _ActivityFeedItemState extends State<ActivityFeedItem> {

  @override
  void initState() {
    final activity = widget.activity;

    Geocoder.local
            .findAddressesFromCoordinates(Coordinates(activity.location.x, activity.location.y))
            .then((a) => setState(() => activity.address = a.first.addressLine))
            .catchError((e) => print("Could not reverse geocode (Lat ${activity.location.x}, Lng ${activity.location.y}): ${e}"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final activity = widget.activity;
    final animation = widget.animation;

      return SlideTransition(
          position: animation.drive(Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0))),
          child: Card(
            color: widget.selected ? Colors.white54 : Colors.white,
            child: InkWell(
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(activity.avatarUrl),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  activity.fullName,
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Divider(
                                    height: 0.5,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    activity.address,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Text(
                                  TimeAgo.format(activity.when),
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          activity.description,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      );
  }
}