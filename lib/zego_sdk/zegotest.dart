import 'package:flutter/material.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallTest extends StatefulWidget {
  const CallTest({super.key});

  @override
  State<CallTest> createState() => _CallTestState();
}

class _CallTestState extends State<CallTest> {
  late ZegoEngineProfile profile;
  ZegoUser user = ZegoUser.id('user1');
  String roomId = "firstRoom";
  late Widget? previewWidget;
  late int? previewId;
  String streamId = "1234";
  late bool isLoading = true;
  late ZegoCanvas canvas;
  bool mute = true;
  bool _micEnable = true;
  bool _cameraEnable = true;

  @override
  void initState() {
    _start().then((_) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: previewWidget,
          );
  }

  startPublishingStream() async {
    ZegoExpressEngine.instance.startPublishingStream(streamId);
  }

  _start() async {
    await requestPermissions();
    await zegoProfile();
    await loginRoom();
    await roomUpdate();
    await userIncreased();
    await startPublishingStream();
    await roomStreamUpdate();
    await PlayerStateUpdate();
    await canvasView();
    await startPlayStream();
    //await disableVideo();
    //await muteAudio();
    //await stopPlayingStream();
    // await logOut();
  }

  roomStreamUpdate() async {
    ZegoExpressEngine.onRoomStreamUpdate = (roomId, ZegoUpdateType updateType,
        List<ZegoStream> streamList, Map<String, dynamic> extendedData) {
      print("🗿 Streams atualizadas");
    };
  }

  startPlayStream() async {
    await ZegoExpressEngine.instance.startPlayingStream(streamId);
  }

  canvasView() async {
    previewWidget = await ZegoExpressEngine.instance.createCanvasView((viewID) {
      previewId = viewID;
      // Set the preview canvas.
      canvas = ZegoCanvas.view(viewID);

      // Start the preview.
      ZegoExpressEngine.instance.startPlayingStream('1234', canvas: canvas);
    });
  }

  zegoProfile() async {
    //  profile = ZegoEngineProfile(4768693, ZegoScenario.General,
    //   appSign:
    //       '84d4e8ca326e5c830b5b15c509f2b70f57c944047be770ffbf3339bdd88e7b84',
    //  enablePlatformView: true);
    await ZegoExpressEngine.createEngineWithProfile(profile);
  }

  loginRoom() async {
    ZegoRoomConfig config = ZegoRoomConfig.defaultConfig();
    ZegoExpressEngine.instance.loginRoom(roomId, user, config: config);
  }

  muteAudio() async {
    ZegoExpressEngine.instance.muteAllPlayStreamAudio(mute);
  }

  disableVideo() async {
    ZegoExpressEngine.instance.muteAllPlayStreamVideo(mute);
  }

  // stopPlayingStream() async {
  //   ZegoExpressEngine.instance.stopPlayingStream(streamId);
  // }

  // logOut() async {
  //   ZegoExpressEngine.instance.logoutRoom(roomId);
  // }

  //updates 👇
  roomUpdate() async {
    ZegoExpressEngine.onRoomStateUpdate = (roomId, ZegoRoomState state,
        int errorCode, Map<String, dynamic> extendedData) {
      print("🗿 RoomUpdated");
    };
  }

  userIncreased() async {
    ZegoExpressEngine.onRoomUserUpdate =
        (roomId, ZegoUpdateType updateType, List<ZegoUser> userList) {
      print("🗿 Numero de usuário aumentou");
    };
  }

  PlayerStateUpdate() async {
    ZegoExpressEngine.onPlayerStateUpdate = (streamId, ZegoPlayerState state,
        int errorCode, Map<String, dynamic> extendedData) {
      print("🗿 Player State atualizado");
    };
  }

  requestPermissions() async {
    await [Permission.camera, Permission.microphone].request();
  }
}

// /// Cross APP playing stream configuration.
// class ZegoCrossAppInfo {
//   /// AppID for playing streams across apps.
//   int appID;

//   /// The token that needs to be set.
//   String token;

//   ZegoCrossAppInfo(this.appID, this.token);
// }

/// Device I
/// 
/// 
/// 









// Scaffold(
//             body: Center(
//               child: Stack(
//                 children: <Widget>[
//                   Positioned(
//                     bottom: 230,
//                     left: 0,
//                     right: 0,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         IconButton(
//                           onPressed: () {
//                             muteAudio();
//                             setState(() {
//                               _micEnable = !_micEnable;
//                             });
//                           },
//                           icon: Icon(_micEnable ? Icons.mic : Icons.mic_off),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             disableVideo();
//                             setState(() {
//                               _cameraEnable = !_cameraEnable;
//                             });
//                           },
//                           icon: Icon(_cameraEnable
//                               ? Icons.camera_alt
//                               : Icons.camera_alt_outlined),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );