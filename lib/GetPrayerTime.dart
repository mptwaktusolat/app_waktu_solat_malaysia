import 'package:flutter/material.dart';
import 'package:waktusolatmalaysia/blocs/azan_times_today_bloc.dart';
import 'package:waktusolatmalaysia/models/azanproapi.dart';
import 'package:waktusolatmalaysia/utils/sizeconfig.dart';

import 'networking/Response.dart';

class GetPrayerTime extends StatefulWidget {
  @override
  _GetPrayerTimeState createState() => _GetPrayerTimeState();
}

class _GetPrayerTimeState extends State<GetPrayerTime> {
  PrayTimeBloc _bloc;
  String location = "sgr01";

  @override
  void initState() {
    super.initState();
    _bloc = PrayTimeBloc(location);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Response<PrayerTime>>(
      stream: _bloc.prayDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Loading(loadingMessage: snapshot.data.message);
              break;
            case Status.COMPLETED:
              return PrayTimeList(prayerTime: snapshot.data.data);
              break;
            case Status.ERROR:
              return Error(
                errorMessage: snapshot.data.message,
                onRetryPressed: () => _bloc.fetchPrayerTime(location),
              );
              break;
          }
        }
        return Container();
      },
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

class PrayTimeList extends StatelessWidget {
  final PrayerTime prayerTime;

  const PrayTimeList({Key key, this.prayerTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SolatCard(prayerTime.prayerTimes.subuh, null),
        SizedBox(
          height: SizeConfig.screenHeight / 100,
        ),
        SolatCard(null, null),
        SizedBox(
          height: SizeConfig.screenHeight / 100,
        ),
        SolatCard(null, null),
        SizedBox(
          height: SizeConfig.screenHeight / 100,
        ),
        SolatCard(null, null),
        SizedBox(
          height: SizeConfig.screenHeight / 100,
        ),
        SolatCard(null, null),
        SizedBox(
          height: SizeConfig.screenHeight / 100,
        ),
      ],
    );
  }
}

Widget SolatCard(String time, String name) {
  return Container(
      width: 300,
      height: 80,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 6.0,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            print('Pressed');
          },
          child: Text('sample'),
        ),
      ));
}

class Error extends StatelessWidget {
  final String errorMessage;

  final Function onRetryPressed;

  const Error({Key key, this.errorMessage, this.onRetryPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          RaisedButton(
            color: Colors.white,
            child: Text('Retry', style: TextStyle(color: Colors.black)),
            onPressed: onRetryPressed,
          )
        ],
      ),
    );
  }
}

class Loading extends StatelessWidget {
  final String loadingMessage;

  const Loading({Key key, this.loadingMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            loadingMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 24),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }
}
