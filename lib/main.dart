import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: promodoro(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class promodoro extends StatefulWidget {
  const promodoro({Key? key}) : super(key: key);

  @override
  State<promodoro> createState() => _promodoroState();
}

class _promodoroState extends State<promodoro> {
  Timer? repetedfunction;
  bool isRunning = true;
  Duration duration = const Duration(minutes: 25);
  startTimer() {
    repetedfunction = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        int newSecond = duration.inSeconds - 1;
        duration = Duration(seconds: newSecond);
        if (duration.inSeconds == 0) {
          duration = const Duration(minutes: 25);

          setState(() {
            isRunning = true;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text(
          "Promodoro",
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(255, 33, 40, 43),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  CircularPercentIndicator(
                    radius: 120.0,
                    progressColor: Color.fromARGB(255, 255, 85, 113),
                    backgroundColor: Colors.grey,
                    lineWidth: 8.0,
                    percent: duration.inMinutes/25,
                    animation: true,
                    animateFromLastPercent: true,
                    animationDuration: 250,
                    center: Text(
                      "${duration.inMinutes.remainder(60).toString().padLeft(2, "0")}:${duration.inSeconds.remainder(60).toString().padLeft(2, "0")}",
                      style: TextStyle(
                        fontSize: 70,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 55,
          ),
          Column(
            children: [
              isRunning
                  ? ElevatedButton(
                      onPressed: () {
                        startTimer();
                        setState(() {
                          isRunning = false;
                        });
                      },
                      child: Text(
                        "Start Studing",
                        style: TextStyle(fontSize: 19),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 25, 120, 197)),
                        padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9))),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (repetedfunction!.isActive) {
                              setState(() {
                                repetedfunction!.cancel();
                              });
                            } else {
                              startTimer();
                            }
                          },
                          child: Text(
                            (repetedfunction!.isActive) ? "Stop" : "Resume",
                            style: TextStyle(fontSize: 19),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 25, 120, 197)),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(14)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9))),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            repetedfunction!.cancel();
                            setState(() {
                              duration = Duration(minutes: 25);
                              isRunning = true;
                            });
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(fontSize: 19),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 200, 20, 100)),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(14)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9))),
                          ),
                        )
                      ],
                    ),
            ],
          )
        ],
      ),
    );
  }
}
