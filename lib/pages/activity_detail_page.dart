import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_feed/model/activity.dart';

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

  String _retrieveImageDataError;

  @override
  void initState() {
    super.initState();
    _avatarUrl = widget.activity.avatarUrl;
    _fullName = widget.activity.fullName;
    _description = widget.activity.description;
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
                  InkWell(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blueGrey,
                      backgroundImage: Activity.getImage(_avatarUrl),
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
                  Divider(
                    height: 20,
                    color: Colors.transparent,
                  ),
                  TextFormField(
                    initialValue: _fullName,
                    maxLines: 1,
                    readOnly: widget.readOnly,
                    decoration: InputDecoration(
                      isDense: false,
                      alignLabelWithHint: true,
                      labelText: 'Full name',
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
                    readOnly: widget.readOnly,
                    decoration: InputDecoration(
                      isDense: false,
                      alignLabelWithHint: true,
                      labelText: 'Description',
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
                            avatarUrl: _avatarUrl,
                            fullName: _fullName,
                            when: DateTime.now().toUtc(),
                            description: _description,
                            location: Point(0, 0),
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
}
