import 'package:flutter/material.dart';
import 'package:go_feed/model/activity.dart';

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
                            child: Hero(
                              tag: "heroImage${activity.id}",
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.blueGrey,
                                backgroundImage: activity.avatarImage,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  activity.fullName,
                                  semanticsLabel: "Full name ${activity.fullName}",
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
                                    semanticsLabel: "Location ${activity.address}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Text(
                                  activity.timeAgo,
                                  semanticsLabel: "Time ${activity.timeAgo}",
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
                          semanticsLabel: "Description ${activity.description}",
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