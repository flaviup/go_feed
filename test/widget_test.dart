// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:go_feed/main.dart';
import 'package:go_feed/model/activity.dart';
import 'package:go_feed/model/activity_feed_model.dart';
import 'package:go_feed/pages/activity_feed_page.dart';
import 'package:go_feed/pages/items/activity_feed_item.dart';

void main() {
  testWidgets('Add new activity smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(ActivityFeedPage), findsOneWidget);
    expect(find.byType(AnimatedList), findsOneWidget);

    final listKey = GlobalKey<AnimatedListState>();
    final activityFeedModel = ActivityFeedModel(
      listKey: listKey,
      initialActivities: <Activity>[
        Activity(avatarUrl: "https://thispersondoesnotexist.com/image",
            fullName: "John Doe",
            when: DateTime.now().toUtc(),
            description: "Description",
            location: Point<double>(31.7532126, -106.3401488))
      ],
    );
    expect(activityFeedModel.length, 1);

    // Tap the '+' icon and trigger a frame.
    //await tester.tap(find.byIcon(Icons.add));
    //await tester.pump(Duration(seconds: 2));

    //expect(find.byType(RaisedButton), findsOneWidget);
  });
}
