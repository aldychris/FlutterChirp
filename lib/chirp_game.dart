import 'package:chirp_flutter/chirp_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'colors.dart';
import 'constant.dart';
import 'main.dart';

class ChirpQuiz extends StatefulWidget {

  final int selectedPage;

  ChirpQuiz(this.selectedPage);

  @override
  _ChirpQuizState createState() => _ChirpQuizState();

}

class _ChirpQuizState extends State<ChirpQuiz> with WidgetsBindingObserver{

  String _soundWaveAnimation = "";
  String _timerAnimation = "";

  bool _btnReadyState = false;
  String _btnReadyText = "Ready";

  bool _quizStarting = false;

  String _questionText = "Press ready when video start play";

  var answersList = ["","","",""];
  var answersColor = [primaryColor, primaryColor, primaryColor, primaryColor];
  var answersStatus = [false, false, false, false];
  var buttonClickableStatus = [false, false, false, false];
  String tempAnswer = "";
  var userAnswer = "";

  var totalTrue = 0;
  var totalFalse = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed) {
      _setChirpReceiver();
    }
  }

  void _setChirpReceiver() {
    if(!_btnReadyState && widget.selectedPage == 1){
      ChirpSDK.onReceived.listen((e) {
        setState(() {
          print("Receive Data");
          processingPayload(String.fromCharCodes(e.payload));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

//          SingleChildScrollView(
//            scrollDirection: Axis.horizontal,
//            child: Row(
//              children: <Widget>[
//                FlatButton(child: Text("TimerBw"), onPressed: (){
//                  startTimer();
//                },),
//
//                FlatButton(child: Text("Reset"), onPressed: (){
//                  processingPayload("reset");
//                },),
//
//                FlatButton(child: Text("Quiz Start"), onPressed: (){
//                  quisIsStarting();
//                  tempAnswer = "a";
//                },),
//
//                FlatButton(child: Text("Gen1"), onPressed: (){
//                  genQuest1();
//                  tempAnswer = "a";
//                },),
//                FlatButton(child: Text("Gen2"), onPressed: (){
//                  genQuest2();
//                  tempAnswer = "c";
//                },),
//                FlatButton(child: Text("Total"), onPressed: (){
//                  showResult("");
//                },),
//              ],
//            ),
//          ),


          Expanded(
            flex: 8,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[

//                Align(
//                  alignment: Alignment.topCenter,
//                  child: Container(
//                    padding: EdgeInsets.only(top: 2),
//                    child: Text(
//                      "Goto this link to play video http://bitly/xxxxx",
//                      style: Theme.of(context).textTheme.body1.copyWith(color: Colors.black87),),
//                  ),
//                ),

                Offstage(
                  offstage: _quizStarting,
//                  offstage: true,
                  child: Container(
                    alignment: Alignment.center,
                    child: FlareActor(
                      "assets/listening.flr",
                      animation: _soundWaveAnimation,
                    ),
                  ),
                ),

                Offstage(
                  offstage: !_quizStarting,
//                  offstage: false,
                  child: Container(
                    padding: EdgeInsets.only(top: 16),
                    alignment: Alignment.center,
                    child: FlareActor(
                      "assets/timer.flr",
                      animation: _timerAnimation,
                      callback: (animName) {
                        print(animName+" finish");
                        if (animName == "playBw") {
                          switch (tempAnswer) {
                            case "a" :
                              setState(() {
                                answersColor[0] = Colors.greenAccent;
                                disableButtonPressed();
                                answersStatus[0] = true;
                              });
                              break;
                            case "b" :
                              setState(() {
                                answersColor[1] = Colors.greenAccent;
                                disableButtonPressed();
                                answersStatus[1] = true;
                              });
                              break;
                            case "c" :
                              setState(() {
                                answersColor[2] = Colors.greenAccent;
                                disableButtonPressed();
                                answersStatus[2] = true;
                              });
                              break;
                            case "d" :
                              setState(() {
                                answersColor[3] = Colors.greenAccent;
                                disableButtonPressed();
                                answersStatus[3] = true;
                              });
                              break;
                          }
                        } else if (animName == "playFw") {

                        }
                      }
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(8)
              ),
              child: AutoSizeText(
                _questionText,
                maxLines: 3,
                style: Theme.of(context).textTheme.display1.copyWith(color: Colors.black87),),
            ),
          ),


          Expanded(
            flex: 4,
            child: Stack(
              children: <Widget>[

                Offstage(
                  offstage: _quizStarting,
//                  offstage: true,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 75),
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: double.infinity,
                      height: 75,
                      child: RaisedButton(
                        clipBehavior: Clip.antiAlias,
                        color: primaryColor,
                        textColor: Colors.white,
                        elevation: 5,
                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          _btnReadyText,
                          style: Theme.of(context).textTheme.display1.copyWith(color: Colors.white.withAlpha(220)),
                        ),
                        onPressed: () {
                          onButtonReadyPressed();
                        },
                      ),
                    ),
                  )
                ),

                Offstage(
                  offstage: !_quizStarting,
//                  offstage: false,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: Table(
                      columnWidths: {
                        0: FlexColumnWidth(5),
                        1: FlexColumnWidth(0.7),
                        2: FlexColumnWidth(5)
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          children: [
                            answerRaisedButton(
                              answersList[0],
                              answersColor[0],
                              answersStatus[0],
                              buttonClickableStatus[0],
                              onButtonPress: () {
                                btnAnswerAPressed();
                              }
                            ),
                            SizedBox(),
                            answerRaisedButton(
                              answersList[1],
                              answersColor[1],
                              answersStatus[1],
                              buttonClickableStatus[1],
                              onButtonPress: () {
                                btnAnswerBPressed();
                              }
                            ),
                          ]
                        ),

                        TableRow(
                          children: [
                            SizedBox(height: 16,),SizedBox(),SizedBox(),
                          ]
                        ),

                        TableRow(
                          children: [
                            answerRaisedButton(
                              answersList[2],
                              answersColor[2],
                              answersStatus[2],
                              buttonClickableStatus[2],
                              onButtonPress: () {
                                btnAnswerCPressed();
                              }
                            ),
                            SizedBox(),
                            answerRaisedButton(
                              answersList[3],
                              answersColor[3],
                              answersStatus[3],
                              buttonClickableStatus[3],
                              onButtonPress: () {
                                btnAnswerDPressed();
                              }
                            ),
                          ]
                        )
                      ],
                    ),
                  ),
                ),

              ],
            )
            ,
          )

        ],
      ),
    );
  }

  Widget answerRaisedButton(String text, Color color, bool isTrue, bool isClickable, {List Function() onButtonPress}) {
    return IgnorePointer(
      ignoring: isClickable,
      child: RaisedButton(
        clipBehavior: Clip.antiAlias,
        padding: EdgeInsets.all(16),
        color: color,
        textColor: Colors.white,
        elevation: 5,
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(text, maxLines: 3)
              ),
              Offstage(
                offstage: !isTrue,
                child: Icon(Icons.check, color: Colors.lightGreenAccent, size: 17,))
            ]
          ),
        ),
        onPressed: onButtonPress,
      ),
    );
  }

  startTimer() {
    setState(() {
      _timerAnimation = "playBw";
    });
  }

  resetTimer() {
    calculateScore();
    setState(() {
      _timerAnimation = "playFw";
    });
  }

  onButtonReadyPressed() {
    if(!_btnReadyState){
      setState(() {
        _questionText = "Checking video...";
        _soundWaveAnimation = "listenloop";
        _btnReadyText = "Stop";
        ChirpSDK.onReceived.listen((e) {
          setState(() {
            print("Receive Data "+e.payload.toString());
            processingPayload(String.fromCharCodes(e.payload));
          });
        });
      });
    }
    else {
      setState(() {
        _questionText = "Press ready when video start play";
        _soundWaveAnimation = "stoplisten";
        _btnReadyText = "Ready";
      });
      ChirpSDK.onReceived.listen(null);
    }

    setState(() { _btnReadyState = !_btnReadyState;});
  }

  void processingPayload(String value) {
    switch(value){
      case "start" :
        quisIsStarting();
        break;
      case "reset" :
        resetTimer();
        resetQuestionAndAnswerText();
        resetButton();
        break;
      case "result" :
        showResult(value);
        break;
      default : //q_1_d, q_2_c, q_3_d, q_4_c, q_5_b, q_6_b, q_7_c, q_8_b, q_9_c, q_10_c, q_11_c, q_12_c
        showQuestion(value);
    }
  }

  void quisIsStarting() {
    totalTrue = 0;
    totalFalse = 0;
    setState(() {
      _quizStarting = true;
      _questionText = "Stay tune question will show soon.";
    });
  }

  void showQuestion(String val) {
    var data = val.split("_");

    if(data.length > 0 && data[0] != "q")
      return;

    String qNumber = data[1];
    tempAnswer = data[2];

    switch(qNumber){
      case "1" : genQuest1();break;
      case "2" : genQuest2();break;
      case "3" : genQuest3();break;
      case "4" : genQuest4();break;
      case "5" : genQuest5();break;
      case "6" : genQuest6();break;
      case "7" : genQuest7();break;
      case "8" : genQuest8();break;
      case "9" : genQuest9();break;
      case "10" : genQuest10();break;
      case "11" : genQuest11();break;
      case "12" : genQuest12();break;
    }
  }

  //region generate quest
  void genQuest1() {
    setState(() {
      _questionText = "Which source water you choose?";

      answersList[0] = "Juicy Cactus";
      answersList[1] = "Pond";
      answersList[2] = "Lake";
      answersList[3] = "Stream";

      startTimer();
    });
  }

  void genQuest2() {
    setState(() {
      _questionText = "Which person actually broke the law?";

      answersList[0] = "Truck";
      answersList[1] = "Horse";
      answersList[2] = "Motorcycle";
      answersList[3] = "Blue Car";

      startTimer();
    });
  }

  void genQuest3() {
    setState(() {
      _questionText = "Which way you choose?";

      answersList[0] = "West";
      answersList[1] = "North";
      answersList[2] = "East";
      answersList[3] = "South";

      startTimer();
    });
  }

    void genQuest4() {
    setState(() {
      _questionText = "Which door you choose?";

      answersList[0] = "Dessert";
      answersList[1] = "Sunny Field";
      answersList[2] = "Strom Beach";
      answersList[3] = "None";

      startTimer();
    });
  }

  void genQuest5() {
    setState(() {
      _questionText = "Which door you choose?";

      answersList[0] = "Zombie";
      answersList[1] = "Warewolf";
      answersList[2] = "Vampire";
      answersList[3] = "None";

      startTimer();
    });
  }

  void genQuest6() {
    setState(() {
      _questionText = "Which door to escape?";

      answersList[0] = "Stay There";
      answersList[1] = "Dinosaurs";
      answersList[2] = "Jungle";
      answersList[3] = "Icy Lake";

      startTimer();
    });
  }

  void genQuest7() {
    setState(() {
      _questionText = "Why James want to wash his face?";

      answersList[0] = "James want to pee after fall";
      answersList[1] = "James want to get a towel";
      answersList[2] = "James thought his face dirty";
      answersList[3] = "James want to get a band aid";

      startTimer();
    });
  }

  void genQuest8() {
    setState(() {
      _questionText = "What is the result of code?";

      answersList[0] = "4 Step North";
      answersList[1] = "South";
      answersList[2] = "9 Step North";
      answersList[3] = "North";

      startTimer();
    });
  }

  void genQuest9() {
    setState(() {
      _questionText = "Which door to escape?";

      answersList[0] = "Ice Door";
      answersList[1] = "Water Door";
      answersList[2] = "Sunny Door";
      answersList[3] = "Toxic Door";

      startTimer();
    });
  }

  void genQuest10() {
    setState(() {
      _questionText = "Which object John can use to get out?";

      answersList[0] = "Metal Safe";
      answersList[1] = "A Rope";
      answersList[2] = "Wodden Barrel";
      answersList[3] = "Stack all object";

      startTimer();
    });
  }

  void genQuest11() {
    setState(() {
      _questionText = "Who is the thieft?";

      answersList[0] = "First person";
      answersList[1] = "Second person";
      answersList[2] = "Third person";
      answersList[3] = "Fourth person";

      startTimer();
    });
  }

  void genQuest12() {
    setState(() {
      _questionText = "Which tunnel to escape?";

      answersList[0] = "Bomb";
      answersList[1] = "Poisoners Snake";
      answersList[2] = "Fire ";
      answersList[3] = "Digging another tunnel";

      startTimer();
    });
  }
  //endregion

  void showResult(String value) {
    setState(() {
      _questionText = "Total correct answers : "+totalTrue.toString();
      answersList[0] = "";
      answersList[1] = "";
      answersList[2] = "";
      answersList[3] = "";
    });
  }

  void calculateScore(){
    if(tempAnswer == userAnswer){
      totalTrue++;
    } else {
      totalFalse++;
    }
  }

  void disableButtonPressed() {
    buttonClickableStatus.setAll(0, [true, true, true, true]);
  }

  void resetQuestionAndAnswerText(){
    setState(() {
      answersList.setAll(0, ["","","",""]);
      _questionText = "Stay tune for next question";
    });
  }

  void resetButton() {
    setState(() {
      buttonClickableStatus.setAll(0, [false, false, false, false]);
      answersStatus.setAll(0, [false, false, false, false]);
      answersColor.setAll(0, [primaryColor, primaryColor, primaryColor, primaryColor]);
    });
  }

  btnAnswerAPressed() {
    resetButton();
    setState(() {
      userAnswer = "a";
      answersColor[0] = Colors.greenAccent;
    });
  }

  btnAnswerBPressed() {
    resetButton();
    setState(() {
      userAnswer = "b";
      answersColor[1] = Colors.greenAccent;
    });
  }

  btnAnswerCPressed() {
    resetButton();
    setState(() {
      userAnswer = "c";
      answersColor[2] = Colors.greenAccent;
    });
  }

  btnAnswerDPressed() {
    resetButton();
    setState(() {
      userAnswer = "d";
      answersColor[3] = Colors.greenAccent;
    });
  }

//  Future<void> _initChirp() async {
//    await ChirpSDK.init(CHIRP_APP_KEY, CHIRP_APP_SECRET);
//    await ChirpSDK.setConfig(CHIRP_APP_CONFIG);
//    await _startAudioProcessing();
//  }
//
//  Future<void> _startAudioProcessing() async {
//    if(await ChirpSDK.state == ChirpState.not_created &&
//       await ChirpSDK.state != ChirpState.running) {
//      await ChirpSDK.start();
//    } else if(await ChirpSDK.state == ChirpState.stopped &&
//      await ChirpSDK.state != ChirpState.running){
//      await ChirpSDK.start();
//    }
//  }
//
//  Future<void> _stopAudioProcessing() async {
//    if(await ChirpSDK.state == ChirpState.running &&
//       await ChirpSDK.state != ChirpState.stopped) {
//      ChirpSDK.onReceived.listen(null);
//      await ChirpSDK.stop();
//    }
//  }
}



