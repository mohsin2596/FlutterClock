import 'dart:async';

import 'package:empathy_clock/anim_helper.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmpathyClock extends StatefulWidget {
  final ClockModel clockModel;

  const EmpathyClock({this.clockModel});

  @override
  _EmpathyClockState createState() => _EmpathyClockState();
}

class _EmpathyClockState extends State<EmpathyClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  //Local variables will be used to help update animation
  var hour = '';
  var minute = '';
  var is24HourFormat = false;

  //For displaying temperature
  var _temperature = '';
  var _condition = '';
  var _location = '';

  var animComplete = false;
  var animType = '';

  var animationName = 'sunny_morning'; //default anim

  @override
  void initState() {
    super.initState();
    widget.clockModel.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(EmpathyClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.clockModel != oldWidget.clockModel) {
      oldWidget.clockModel.removeListener(_updateModel);
      widget.clockModel.addListener(_updateModel);
    }
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.clockModel.temperatureString;
      _condition = widget.clockModel.weatherString;
      _location = widget.clockModel.location;

      animType =
          AnimHelper.getAnimationName(_condition, _dateTime.hour, animComplete);

      //windy and cloudy are the same
      var animCondition = (_condition == enumToString(WeatherCondition.windy))
          ? 'cloudy'
          : _condition;
      animationName = '$animCondition\_$animType';

      animComplete = false;
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();

      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    is24HourFormat = widget.clockModel.is24HourFormat;
    hour = DateFormat(is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    minute = DateFormat('mm').format(_dateTime);

    return Stack(
      fit: StackFit.expand,
      children: [
        FlareActor(
          "assets/FlutterClock.flr",
          animation: animationName,
          callback: (completed) {
            animComplete = true;
            if (animType == enumToString(AnimationTypes.night)) {
              AnimHelper.nightAnimCount += 1;
            }
            _updateModel();
          },
          fit: BoxFit.fill,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 8.0, top: 4.0),
              child: Text(
                '$hour:$minute',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 100,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                '$_temperature, $_condition',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                '$_location',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
