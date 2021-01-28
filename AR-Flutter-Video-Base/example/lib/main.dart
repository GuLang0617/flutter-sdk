import 'dart:async';
import 'dart:core';
import 'package:ar_rtc_engine/rtc_engine.dart';
//import 'package:ar_rtc_engine/rtc_stream_kit.dart';
//import 'package:ar_rtc_engine/rtc_media_player.dart';
import 'package:ar_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:ar_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:ar_rtc_engine/rtc_player_view.dart' as RtcMediaPlayerView;
import 'package:ar_rtc_engine_example/home_start.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
// class Helper {
//   static String numFormat(int num) {
//     if(num /50 < 1) {
//       return "num";
//     }else if(num / 50 < 1) {
//       return null;
//     }
//   }
// }
class _MyAppState extends State<MyApp> {
  bool _joined = false;
  String _remoteUid = "";
  bool _switch = false;
  bool muted = false;
  bool muted2 = false;
  RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }
  @override
  void destroy(){
    return destroy();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    await [Permission.camera, Permission.microphone, Permission.storage]
        .request();
    ///* AppID * anyRTC 为 App 开发者签发的 App ID。每个项目都应该有一个独一无二的 App ID。如果你的开发包里没有 App ID，请从anyRTC官网(https://www.anyrtc.io)申请一个新的 App ID
    var engine = await RtcEngine.create('YOUR APP ID');
    //var streamKit = await StreamKit.create();
    engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, String uid, int elapsed) {
          print('joinChannelSuccess ${channel} ${uid}');
          setState(() {
            _joined = true;
          });
        }, userJoined: (String uid, int elapsed) {
      print('userJoined ${uid}');
      setState(() {
        _remoteUid = uid;
      });
    }, userOffline: (String uid, UserOfflineReason reason) {
      print('userOffline ${uid}');
      setState(() {
        _remoteUid = "";
      });
    },rejoinChannelSuccess:(String channel, String uid, int elapsed) {
      print('rejoinChannelSuccess ${channel} ${uid}');
    },remoteAudioStateChanged: (String uid,
        AudioRemoteState state, AudioRemoteStateReason reason, int elapsed){
      print('remoteAudioStateChanged ${uid} -${state} - ${reason} -${elapsed}');
    },remoteVideoStateChanged: (String uid,
        VideoRemoteState state, VideoRemoteStateReason reason, int elapsed){
      print('remoteVideoStateChanged ${uid} -${state} - ${reason} -${elapsed}');
    },localAudioStateChanged: (AudioLocalState state, AudioLocalError error){
      print('localAudioStateChanged ${state} - ${error} ');
    },localVideoStateChanged: (LocalVideoStreamState localVideoState, LocalVideoStreamError error){
      print('localVideoStateChanged ${localVideoState} - ${error} ');
    },remoteAudioStats: (RemoteAudioStats stats){
      print('RemoteAudioStats ${stats.audioLossRate}');
    },remoteVideoStats: (RemoteVideoStats stats){
      print('RemoteVideoStats ${stats.decoderOutputFrameRate} == ${stats.rendererOutputFrameRate}');
    },rtcStats:(RtcStats stats) {
      print('RtcStats ${stats.totalDuration} == ${stats.rxBytes}');
    },networkTypeChanged: (NetworkType type){
      print('NetworkType ${NetworkType.WIFI} ');
    }
    ));
    await engine.enableVideo();
    await engine.joinChannel(null, '909090', "");//userId = ""时 sdk会自动生成一个
  }
  // List<Widget> Boxs() => List.generate(16, (index) {
  //   return MaterialApp(
  //     home: Builder(
  //       builder: (context) => Scaffold(
  //         body: Stack(
  //           children: [
  //             Wrap(
  //               spacing: 2,
  //               runSpacing: 5,
  //               children: Boxs(),
  //             ),
  //             Align(
  //               alignment: Alignment.topLeft,
  //               child: Container(
  //                 color: Colors.blue,
  //                 child: GestureDetector(
  //                   onTap: () {
  //                     setState(() {
  //                       _switch = !_switch;
  //                     });
  //                   },
  //                   child: Center(
  //                     child:
  //                     _switch ? _renderLocalPreview() : _renderRemoteVideo(),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: Stack(
            children: [
              // // GridView.builder(
              // //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              // //       crossAxisCount: 4,
              // //       crossAxisSpacing: 2,
              // //       mainAxisSpacing: 2,
              // //       childAspectRatio: 1
              // //   ),
              // //   itemBuilder: (BuildContext context,int index){
              // //     return _mediaPlayerVideo();
              // //   },
              // // ),
              // Center(
              //   child: _switch ? _renderRemoteVideo() : _mediaPlayerVideo(),
              // ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(top: 35),
                  width: 91,
                  height: 95,
                  color: Colors.blue,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _switch = !_switch;
                      });
                    },
                    child: Center(
                      child:
                      _switch ? _renderLocalPreview() : _renderRemoteVideo(),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 35,right: 85),
                  width: 91,
                  height: 95,
                  color: Colors.blue,
                  child: Center(
                    child: _switch ? _renderRemoteVideo() : _mediaPlayerVideo(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(top: 35,right: 85),
                  width: 91,
                  height: 95,
                  color: Colors.blue,
                  child: Center(
                    child: _switch ? _renderRemoteVideo() : _mediaPlayerVideo(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(top: 35,left: 276),
                  width: 91,
                  height: 95,
                  color: Colors.blue,
                  child: Center(
                    child: _switch ? _renderRemoteVideo() : _mediaPlayerVideo(),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(top: 131),
                  width: 91,
                  height: 95,
                  color: Colors.blue,
                  child: Center(
                    child: _switch ? _renderRemoteVideo() : _mediaPlayerVideo(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 131,right: 85),
                  width: 91,
                  height: 95,
                  color: Colors.blue,
                  child: Center(
                    child: _switch ? _renderRemoteVideo() : _mediaPlayerVideo(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(top: 131,right: 85),
                  width: 91,
                  height: 95,
                  color: Colors.blue,
                  child: Center(
                    child: _switch ? _renderRemoteVideo() : _mediaPlayerVideo(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(top: 131,left: 276),
                  width: 91,
                  height: 95,
                  color: Colors.blue,
                  child: Center(
                    child: _switch ? _renderRemoteVideo() : _mediaPlayerVideo(),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(top: 227),
                  width: 91,
                  height: 95,
                  color: Colors.blue,
                  child: Center(
                    child: _switch ? _renderRemoteVideo() : _mediaPlayerVideo(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 227,right: 85),
                  width: 91,
                  height: 95,
                  color: Colors.blue,
                  child: Center(
                    child: _switch ? _renderRemoteVideo() : _mediaPlayerVideo(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(top: 227,right: 85),
                  width: 91,
                  height: 95,
                  color: Colors.blue,
                  child: Center(
                    child: _switch ? _renderRemoteVideo() : _mediaPlayerVideo(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(top: 227,left: 276),
                  width: 91,
                  height: 95,
                  color: Colors.blue,
                  child: Center(
                    child: _switch ? _renderRemoteVideo() : _mediaPlayerVideo(),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(top: 323),
                  width: 91,
                  height: 95,
                  color: Colors.blue,
                  child: Center(
                    child: _switch ? _renderRemoteVideo() : _mediaPlayerVideo(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 323,right: 85),
                  width: 91,
                  height: 95,
                  color: Colors.blue,
                  child: Center(
                    child: _switch ? _renderRemoteVideo() : _mediaPlayerVideo(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(top: 323,right: 85),
                  width: 91,
                  height: 95,
                  color: Colors.blue,
                  child: Center(
                    child: _switch ? _renderRemoteVideo() : _mediaPlayerVideo(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(top: 323,left: 276),
                  width: 91,
                  height: 95,
                  color: Colors.blue,
                  child: Center(
                    child: _switch ? _renderRemoteVideo() : _mediaPlayerVideo(),
                  ),
                ),
              ),


              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: EdgeInsets.only(bottom: 50,left: 30),
                  child: RawMaterialButton(
                    onPressed: _onToggleMute,
                    child: Icon(
                      muted ? Icons.mic_off : Icons.mic,
                      color: muted ? Colors.white : Colors.blueAccent,
                      size: 20.0,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: muted ? Colors.blueAccent : Colors.white,
                    padding: const EdgeInsets.all(12.0),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: EdgeInsets.only(bottom: 50,right: 30),
                  child: RawMaterialButton(
                    onPressed: _onSwitchCamera,
                    child: Icon(
                      muted2 ? Icons.flip_camera_ios_outlined:Icons.flip_camera_ios,
                      color: muted2 ? Colors.white : Colors.blueAccent,
                      size: 20.0,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: muted2 ? Colors.blueAccent : Colors.white,
                    padding: const EdgeInsets.all(12.0),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 50),
                  child: RaisedButton(
                    child: Text("挂断"),
                    color: Colors.red,
                    textColor: Colors.white,
                    onPressed: (){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_userEtController) => HoMe()));
                      return destroy();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }
  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  Widget _renderLocalPreview() {
    if (_joined) {
      return RtcLocalView.SurfaceView(renderMode: VideoRenderMode.Fit);
    } else {
      return Text(
        'Please join channel first',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _renderRemoteVideo() {
    if (_remoteUid != "") {
      return RtcRemoteView.SurfaceView(uid: _remoteUid,renderMode: VideoRenderMode.Fit);
    } else {
      return Text(
        'Please wait remote user join',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _mediaPlayerVideo() {
    return RtcMediaPlayerView.MediaPlayerView();
  }
}
