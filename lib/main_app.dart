import 'package:chirp_flutter/chirp_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chirp/chirp_listening.dart';
import 'package:flutter_chirp/chirp_game.dart';
import 'package:permission_handler/permission_handler.dart';

import 'constant.dart';


class MainAppWidget extends StatefulWidget {
  MainAppWidget({Key key}) : super(key: key);

  @override
  _MainAppWidgetState createState() => _MainAppWidgetState();
}

class _MainAppWidgetState extends State<MainAppWidget>  with WidgetsBindingObserver{

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    if(!kIsWeb)
      _requestPermissions();

    _initChirp();
    _startAudioProcessing();
    _setChirpCallbacks();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _stopAudioProcessing();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _stopAudioProcessing();
    } else if (state == AppLifecycleState.resumed) {
      _startAudioProcessing();
      _setChirpCallbacks();
    }
  }

  Future<void> _requestPermissions() async {
    PermissionStatus permissionStatus = await PermissionHandler().checkPermissionStatus(PermissionGroup.microphone);

    if(permissionStatus == PermissionStatus.denied){
      Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.microphone]);
    }

  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF9AD0A8),
                Color(0xFF7BCAAD),
                Color(0xFF51BDB1),
                Color(0xCC1AB8B7),
                Color(0xD91AB8B7),
              ],
            ),
          ),
          child: Stack(
            children: <Widget>[

              Offstage(
                offstage: _selectedIndex != 0,
                child: TickerMode(
                  enabled: _selectedIndex == 0,
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: ChirpListening(_selectedIndex)),
                ),
              ),

              Offstage(
                offstage: _selectedIndex != 1,
                child: TickerMode(
                  enabled: _selectedIndex == 1,
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: ChirpQuiz(_selectedIndex)),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xFF1AB8B7),
          unselectedItemColor: Colors.blueGrey[400],
          selectedItemColor: Colors.white,
          elevation: 5,
          currentIndex: _selectedIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.hearing),
              title: Text('Listen'),
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.videogame_asset),
              title: Text('Game'),
            ),
          ],
          onTap: _onItemTapped,
        ),
      ),
    );


  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _setChirpCallbacks() async {
    ChirpSDK.onStateChanged.listen((e) {
      setState(() {
        print(e.current);
      });
    });
  }

  Future<void> _initChirp() async {
    await ChirpSDK.init(CHIRP_APP_KEY, CHIRP_APP_SECRET);
    await ChirpSDK.setConfig(CHIRP_APP_CONFIG);
  }

  Future<void> _startAudioProcessing() async {
    if(await ChirpSDK.state == ChirpState.not_created &&
      await ChirpSDK.state != ChirpState.running) {
      await ChirpSDK.start();
    } else if(await ChirpSDK.state == ChirpState.stopped &&
      await ChirpSDK.state != ChirpState.running){
      await ChirpSDK.start();
    }
  }

  Future<void> _stopAudioProcessing() async {
    if(await ChirpSDK.state == ChirpState.running &&
      await ChirpSDK.state != ChirpState.stopped) {
      ChirpSDK.onReceived.listen(null);
      await ChirpSDK.stop();
    }
  }
}