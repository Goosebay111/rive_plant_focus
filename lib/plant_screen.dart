import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:rive_plant_focus/utils/time_util.dart';

class PlantScreen extends StatefulWidget {
  const PlantScreen({Key? key}) : super(key: key);

  @override
  _PlantScreenState createState() => _PlantScreenState();
}

class _PlantScreenState extends State<PlantScreen> {
  Artboard? _riveArtboard;
  StateMachineController? _controller;
  SMIInput<double>? _progress;
  String plantButtonText = '';

  late Timer _timer;
  int _treeProgress = 0;
  int _treeMaxProgress = 60;
  double _percent = 1.0;

  @override
  void initState() {
    super.initState();
    plantButtonText = 'Plant';
    rootBundle.load('assets/tree_demo.riv').then(
      (data) async {
        /// Rive
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        _controller = StateMachineController.fromArtboard(artboard, 'Grow');
        if (_controller != null) {
          artboard.addController(_controller!);
          _progress = _controller!.findInput('input');
          setState(() => _riveArtboard = artboard);
        }
      },
    );
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_treeProgress == _treeMaxProgress) {
          stopTimer();
          setState(() {
            plantButtonText = 'Plant';
            _treeProgress = 0;
            _treeMaxProgress = 60;
            _percent = 1.0;
          });
        } else {
          setState(() {
            _treeProgress += 1;
            _percent = (60 - _treeProgress) / 60;
            //rive
            _progress?.value = _treeProgress.toDouble();
          });
        }
      },
    );
  }

  void stopTimer() {
    setState(() {
      _timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    double treeWidth = MediaQuery.of(context).size.width - 40;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 60),
            child: Text(
              'Stay Focused',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child:

                ///RIVE
                _riveArtboard == null
                    ? const SizedBox()
                    : Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: SizedBox(
                                height: treeWidth,
                                width: treeWidth,
                                child: CircularProgressIndicator(
                                  color: Colors.white38,
                                  backgroundColor: Colors.white12,
                                  value: _percent,
                                  strokeWidth: 10,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: treeWidth * 0.9,
                              height: treeWidth * 0.9,
                              child:
                                  //RIVE
                                  Rive(
                                      alignment: Alignment.center,
                                      artboard: _riveArtboard!),
                            ),
                          ],
                        ),
                      ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              intToTimeLeft(_treeMaxProgress - _treeProgress).toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: MaterialButton(
              height: 40,
              minWidth: 180,
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.green,
              textColor: Colors.white,
              child: Text(plantButtonText),
              onPressed: () {
                if (_treeProgress > 0) {
                  stopTimer();
                  plantButtonText = 'Plant';
                  _treeProgress = 0;
                  _treeMaxProgress = 60;
                  return;
                }
                startTimer();
                plantButtonText = 'Surrender';
              },
              splashColor: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }
}
