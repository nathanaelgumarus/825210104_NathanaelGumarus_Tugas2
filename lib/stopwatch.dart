import 'dart:async';

import 'package:flutter/material.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({Key? key}) : super(key: key);

  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  bool isTicking = false;
  int seconds = 0;
  late Timer timer;
  int milliseconds = 0;
  final laps = <int>[];
  final itemHeight = 60.0;
  final scrollController = ScrollController();

  void _onTick(Timer time){
    setState(() {
      milliseconds += 100;
    });
  }

  void _startTimer() {
    if (!isTicking) {
      timer = Timer.periodic(Duration(milliseconds: 100), _onTick);
      setState(() {
        isTicking = true;
        laps.clear();
      });
    }
  }

  void _stopTimer() {
    if (isTicking) {
      timer.cancel();
      setState(() {
        isTicking = false;
      });
    }
  }

  void _resetTimer() {
    setState(() {
      seconds = 0;
      milliseconds = 0;
    });
  }

  void _lap() {
    setState(() {
      laps.add(milliseconds);
      _resetTimer();
    });
    scrollController.animateTo(
      itemHeight * laps.length,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String _secondsString(int milliseconds) {
    final seconds = milliseconds / 1000;
    return '$seconds seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stopwatch'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: _buildCounter(context)),
          Expanded(child: _buildLapDisplay()),
        ],
      ),
    );
  }

  Widget _buildCounter(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Lap ${laps.length + 1}',
            style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.white),
          ),
          Text(
            _secondsString(milliseconds),
            style: Theme.of(context).textTheme.headline4?.copyWith(color: Colors.white),
          ),
          SizedBox(width: 20),
          buildControls(),
        ],
      ),
    );
  }

  Widget buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          onPressed: isTicking ? null : _startTimer,
          child: Text('Start'),
        ),
        SizedBox(width: 20),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          onPressed: isTicking ? _stopTimer : null,
          child: Text('Stop'),
        ),
        SizedBox(width: 20),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          onPressed: isTicking ? _lap : null,
          child: Text('Lap'),
        ),
      ],
    );
  }

  Widget _buildLapDisplay() {
    return Scrollbar(
      child: ListView.builder(
        controller: scrollController,
        itemExtent: itemHeight,
        itemCount: laps.length,
        itemBuilder: (context, index) {
          final milliseconds = laps[index];
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 50),
            title: Text('Lap ${index + 1}'),
            trailing: Text(_secondsString(milliseconds)),
          );
        },
      ),
    );
  }
}
