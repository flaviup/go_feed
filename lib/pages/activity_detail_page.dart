import 'dart:math';
import 'package:flutter/material.dart';
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

  String _fullName;
  String _description;

  @override
  void initState() {
    super.initState();
    _fullName = widget.activity.fullName;
    _description = widget.activity.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activity Detail", style: TextStyle(letterSpacing: 1),),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(height: 20, color: Colors.transparent, ),
              TextFormField(
                initialValue: _fullName,
                maxLines: 1,
                readOnly: widget.readOnly,
                decoration: InputDecoration(
                  isDense: false,
                  alignLabelWithHint: true,
                  labelText: 'Full name',
                  border: FieldBorder,
                  //focusedBorder: FieldBorder,
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
                  return null;
                },
                onSaved: (v) => _fullName = v,
              ),
              Divider(height: 10, color: Colors.transparent, ),
              TextFormField(
                initialValue: _description,
                maxLines: 10,
                readOnly: widget.readOnly,
                decoration: InputDecoration(
                  isDense: false,
                  alignLabelWithHint: true,
                  labelText: 'Description',
                  border: FieldBorder,
                  //focusedBorder: FieldBorder,
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
                  return null;
                },
                onSaved: (v) => _description = v,
              ),
              if (!widget.readOnly) Divider(height: 10, color: Colors.transparent, ),
              if (!widget.readOnly) RaisedButton(
                color: Colors.blue,
                child: Text("Save",
                ),
                shape: RoundedRectangleBorder(borderRadius: ButtonRadius),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    Navigator.pop(
                      context,
                      Activity(
                        avatarUrl: "",
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
    );
  }
}
