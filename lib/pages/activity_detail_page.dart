import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:image_picker/image_picker.dart';
import 'package:go_feed/model/activity.dart';
import 'package:go_feed/location_picker/location_picker.dart';

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

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  final _formKey = GlobalKey<FormState>();

  static final FieldRadius = BorderRadius.circular(10); // 0 - 30
  static final FieldBorder = OutlineInputBorder(gapPadding: 6, borderRadius: FieldRadius);
  static final ButtonRadius = BorderRadius.circular(20); // 0 - 30

  String _avatarUrl;
  String _fullName;
  String _description;
  String _address;

  String _retrieveImageDataError;
  Map<dynamic, dynamic> _locationData;

  @override
  void initState() {
    super.initState();
    _avatarUrl = widget.activity.avatarUrl;
    _fullName = widget.activity.fullName;
    _description = widget.activity.description;
    _address = widget.activity.address;
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
                            backgroundImage: Activity.getImage(_avatarUrl),
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
                            if (!widget.readOnly) RaisedButton(
                              color: Colors.blue,
                              focusElevation: 4,
                              highlightElevation: 4,
                              child: Text(
                                "PICK LOCATION",
                                semanticsLabel: "Pick location button",
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: ButtonRadius,
                              ),
                              onPressed: _showLocationPicker,
                            ),
                            if (_address?.isNotEmpty) Text(
                              _address,
                              semanticsLabel: "Location ${_address}",
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
                  if (!widget.readOnly) RaisedButton(
                    color: Colors.blue,
                    focusElevation: 4,
                    highlightElevation: 4,
                    child: Text(
                      "SAVE",
                      semanticsLabel: "Save button",
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: ButtonRadius,
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        Navigator.pop(
                          context,
                          Activity(
                            id: activity.id,
                            avatarUrl: _avatarUrl,
                            fullName: _fullName,
                            when: DateTime.now().toUtc(),
                            description: _description,
                            location: (_locationData != null &&
                                       _locationData.containsKey("latitude") &&
                                       _locationData.containsKey("longitude")) ?
                                        Point(_locationData["latitude"], _locationData["longitude"]) :
                                        activity.location,
                            address: _address,
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
    );
  }

  Future _getImage(ImageSource imageSource) async {
    var image = await ImagePicker.pickImage(source: imageSource);

    if (image?.path != null && image.path.isNotEmpty) {
      setState(() {
        _avatarUrl = image.path;
      });
    }
  }

  Future<void> _retrieveLostImageData() async {
    final response = await ImagePicker.retrieveLostData();

    if (response.isEmpty) {
      return;
    }

    if (response.file != null) {
      if (response.type == RetrieveType.image) {
        setState(() {
          _avatarUrl = response.file.path;
        });
      }
    } else {
      _retrieveImageDataError = response.exception.code;
    }
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveImageDataError != null) {
      final result = Text(_retrieveImageDataError);
      _retrieveImageDataError = null;
      return result;
    }
    return null;
  }

  Column _buildBottomNavigationMenu() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.photo_camera),
          title: Text("Take camera photo"),
          onTap: () {
            Navigator.pop(context);
            _getImage(ImageSource.camera);
          },
        ),
        ListTile(
          leading: Icon(Icons.photo),
          title: Text("Select from gallery"),
          onTap: () {
            Navigator.pop(context);
            _getImage(ImageSource.gallery);
          },
        ),
      ],
    );
  }

  void _showLocationPicker() async {
    final initLocation = widget.activity.location;
    final picker = LocationPicker(
      initialLat: initLocation?.x ?? 0,
      initialLong: initLocation?.y ?? 0,
    );
    Map<dynamic, dynamic> result = null;

    try {
      result = await picker.showLocationPicker;
    } on PlatformException {
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted || result == null)
      return;

    setState(() {
      _locationData = result;

      if (result.containsKey("line0")) _address = result["line0"];
    });
  }
}
