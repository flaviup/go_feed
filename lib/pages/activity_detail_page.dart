import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_feed/model/activity.dart';
import 'package:go_feed/pages/mixins/image_picker_mixin.dart';
import 'package:go_feed/pages/mixins/location_picker_mixin.dart';
import 'package:go_feed/pages/widgets/go_button.dart';

class ActivityDetailPage extends StatefulWidget {

  final Activity activity;
  final bool readOnly;
  ActivityDetailPage({Key key, @required this.activity, this.readOnly = true}) :
        assert(activity != null),
        assert(readOnly != null),
        super(key: key);

  @override
  _ActivityDetailPageState createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> with ImagePickerMixin, LocationPickerMixin {
  final _formKey = GlobalKey<FormState>();

  static final FieldRadius = BorderRadius.circular(10); // 0 - 30
  static final FieldBorder = OutlineInputBorder(gapPadding: 6, borderRadius: FieldRadius);

  String _fullName;
  String _description;

  @override
  void initState() {
    super.initState();
    _fullName = widget.activity.fullName;
    _description = widget.activity.description;
    avatarUrl = widget.activity.avatarUrl;
    address = widget.activity.address;
  }

  @override
  Widget build(BuildContext context) {
    final activity = widget.activity;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Activity Detail",
          semanticsLabel: "Page title: Activity Detail",
          style: TextStyle(
            letterSpacing: 1,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Divider(
                      height: 20,
                      color: Colors.transparent,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          child: Hero(
                            tag: "heroImage${activity.id}",
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.blueGrey,
                              backgroundImage: Activity.getImage(avatarUrl),
                            ),
                          ),
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  color: Colors.white,
                                  height: 120,
                                  child: _buildBottomNavigationMenu(),
                                );
                              },
                              backgroundColor: Colors.white,
                            );
                          },
                        ),
                        Container(
                          width: 8,
                          color: Colors.transparent,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (!widget.readOnly) GoButton(
                                text: "PICK LOCATION",
                                semanticsLabel: "Pick location button",
                                onPressed: () => showLocationPicker(activity.location),
                              ),
                              if (address?.isNotEmpty) Text(
                                address,
                                semanticsLabel: "Location ${address}",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 14,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 20,
                      color: Colors.transparent,
                    ),
                    TextFormField(
                      initialValue: _fullName,
                      maxLines: 1,
                      maxLength: 200,
                      maxLengthEnforced: true,
                      readOnly: widget.readOnly,
                      decoration: InputDecoration(
                        isDense: false,
                        alignLabelWithHint: true,
                        labelText: "Full name",
                        border: FieldBorder,
                        enabledBorder: FieldBorder,
                        hintText: "Enter your full name",
                        hintStyle: TextStyle(
                            letterSpacing: 1,
                            fontSize: 14,
                        ),
                        errorStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                        ),
                        counterText: "",
                      ),
                      validator: (v) {
                        if (v.trim().isEmpty) return "Empty name.";
                        return null;
                      },
                      onSaved: (v) => _fullName = v.trim(),
                    ),
                    Divider(height: 10, color: Colors.transparent,),
                    TextFormField(
                      initialValue: _description,
                      maxLines: 10,
                      maxLength: 2000,
                      maxLengthEnforced: true,
                      readOnly: widget.readOnly,
                      decoration: InputDecoration(
                        isDense: false,
                        alignLabelWithHint: true,
                        labelText: "Description",
                        border: FieldBorder,
                        enabledBorder: FieldBorder,
                        hintText: "Describe your activity",
                        hintStyle: TextStyle(
                          letterSpacing: 1,
                          fontSize: 14,
                        ),
                        errorStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                        ),
                      ),
                      validator: (v) {
                        if (v.trim().isEmpty) return "Empty description.";
                        return null;
                      },
                      onSaved: (v) => _description = v.trim(),
                    ),
                    if (activity.when != null) Divider(height: 10, color: Colors.transparent,),
                    if (activity.when != null) Text(
                      activity.timeAgo,
                      semanticsLabel: "Time ${activity.timeAgo}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey,
                        letterSpacing: 1,
                      ),
                    ),
                    if (!widget.readOnly) Divider(height: 10, color: Colors.transparent,),
                    if (!widget.readOnly) GoButton(
                      text: "SAVE",
                      semanticsLabel: "Save button",
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          Navigator.pop(
                            context,
                            Activity(
                              id: activity.id,
                              avatarUrl: avatarUrl,
                              fullName: _fullName,
                              when: DateTime.now().toUtc(),
                              description: _description,
                              location: (locationData != null &&
                                         locationData.containsKey("latitude") &&
                                         locationData.containsKey("longitude")) ?
                                          Point(locationData["latitude"], locationData["longitude"]) :
                                          activity.location,
                              address: address,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _buildBottomNavigationMenu() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.photo_camera),
          title: Text("Take camera photo"),
          onTap: () {
            Navigator.pop(context);
            getImage(ImageSource.camera);
          },
        ),
        ListTile(
          leading: Icon(Icons.photo),
          title: Text("Select from gallery"),
          onTap: () {
            Navigator.pop(context);
            getImage(ImageSource.gallery);
          },
        ),
      ],
    );
  }
}
