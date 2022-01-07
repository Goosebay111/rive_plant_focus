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

  @override
  void initState() {
    super.initState();
    plantButtonText = 'Plant';
    rootBundle.load('assets/tree_demo.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        var controller = StateMachineController.fromArtboard(artboard, 'Grow');
        if (controller != null) {
          artboard.addController(controller);
          _progress = controller.findInput('input');
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
          plantButtonText = 'Plant';
          _treeProgress = 0;
          _treeMaxProgress = 60;
        } else {
          setState(() {
            _treeProgress += 1;
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
                        child: Container(
                          width: treeWidth,
                          height: treeWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(treeWidth / 2),
                            border:
                                Border.all(color: Colors.white12, width: 10),
                          ),
                          child:
                              //RIVE
                              Rive(
                                  alignment: Alignment.center,
                                  artboard: _riveArtboard!),
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
