import 'package:auto_size_text/auto_size_text.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chirp_flutter/chirp_flutter.dart';
import 'package:flutter_chirp/main.dart';
import 'package:flutter_chirp/scratchcard/scratch_card.dart';
import 'package:permission_handler/permission_handler.dart';

import 'colors.dart';
import 'constant.dart';

class ChirpListening extends StatefulWidget {
  final int selectedPage;

  ChirpListening(this.selectedPage);


  @override
  _ChirpListeningState createState() => _ChirpListeningState();

}

class _ChirpListeningState extends State<ChirpListening> with WidgetsBindingObserver{

  String _data = "";

  String _soundWaveAnimation = "";
  String _explosionAnimation = "";
  String _btnListenText = "Listen Now";
  String _infoText = "Play video and press listen now";

  bool _listenState = false;
  bool _getReward = false;

  double _opacityAnimation = 0.0;

  final sendTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed) {
      _setChirpReceiver();
    }
  }

  void _setChirpReceiver() {
    if(!_getReward && widget.selectedPage == 0){
      ChirpSDK.onReceived.listen((e) {
        setState(() {
          print("Receive Data "+e.toString());
          _processingPayload(String.fromCharCodes(e.payload));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[

//          FlatButton(child: Text("mock sound"), onPressed: (){
//            _processingPayload("");
//          },),

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
                  offstage: _getReward,
                  child: Container(
                    alignment: Alignment.center,
                    height: 302,
                    width: 513,
                    child: FlareActor(
                      "assets/listening.flr",
                      animation: _soundWaveAnimation,
                    ),
                  ),
                ),

                Offstage(
                  offstage: !_getReward,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[

                      AnimatedOpacity(
                        child: _renderCouponWidget(context),
                        opacity: _opacityAnimation,
                        duration: Duration(seconds: 3),
                      ),

                      IgnorePointer(
                        ignoring: true,
                        child: Container(
                          alignment: Alignment.center,
                          height: 302,
                          width: 513,
                          child: FlareActor(
                            "assets/stareffect.flr",
                            animation: _explosionAnimation,
                          ),
                        ),
                      ),

                    ],
                  )
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
                _infoText,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: Theme.of(context).textTheme.display1.copyWith(color: Colors.black87),),
            ),
          ),

          Expanded(
            flex: 4,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 65),
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
                    _btnListenText,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.display1.copyWith(color: Colors.white.withAlpha(220)),
                  ),
                  onPressed: _onListenButtonPressed
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container _renderCouponWidget(BuildContext context) {
    return Container(
      width: 280.0,
      height: 180.0,
      child: ScratchCard(
        cover: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset(
              'assets/imgtemp.png',
              repeat: ImageRepeat.noRepeat,
              fit: BoxFit.cover,
            ),
          ],
        ),
        reveal: DecoratedBox(
          decoration: const BoxDecoration(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Congratulations! You WON!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.title
              ),
            ),
          ),
        ),
        strokeWidth: 15.0,
        finishPercent: 50,
      ),
    );
  }

  void _onListenButtonPressed(){
    if(!_listenState){
      setState(() {
        _getReward = false;
        _btnListenText = "Stop Listening";
        _soundWaveAnimation = "listenloop";
        _infoText = "Listening...\nStay tune for your reward";
      });
      ChirpSDK.onReceived.listen((e) {
        setState(() {
          print("Receive Data");
          print(e.payload);
          _data = String.fromCharCodes(e.payload);
          _processingPayload(_data);
        });
      });
    }
    else {
      setState(() {
        _btnListenText = "Listen Now";
        _soundWaveAnimation = "stoplisten";
        _infoText = "Play video from beginning and press listen";
      });
      ChirpSDK.onReceived.listen(null);
    }

    setState(() { _listenState = !_listenState;});
  }

  void _processingPayload(String data) {
    setState(() {
      _getReward = true;
      _explosionAnimation = "explode";

      _opacityAnimation = 1.0;

      _onListenButtonPressed();
    });
  }

}