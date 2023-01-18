// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

// Project imports:

/// Note that the userID needs to be globally unique,
final String localUserID = math.Random().nextInt(10000).toString();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: CallInvitationPage());
  }
}

class CallInvitationPage extends StatelessWidget {
  CallInvitationPage({Key? key}) : super(key: key);
  final TextEditingController inviteeUsersIDTextCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCallWithInvitation(
      appID: 4768693,
      appSign:
          '84d4e8ca326e5c830b5b15c509f2b70f57c944047be770ffbf3339bdd88e7b84',
      userID: localUserID,
      userName: "user_$localUserID",
      plugins: [ZegoUIKitSignalingPlugin()],
      notifyWhenAppRunningInBackgroundOrQuit: true,
      child: yourPage(context),
    );
  }

  Widget yourPage(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Your userID: $localUserID'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  inviteeUserIDInput(),
                  const SizedBox(width: 5),
                  callButton(false),
                  const SizedBox(width: 5),
                  callButton(true),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget inviteeUserIDInput() {
    return Expanded(
      child: TextFormField(
        controller: inviteeUsersIDTextCtrl,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9,]')),
        ],
        decoration: const InputDecoration(
          isDense: true,
          hintText: "Please Enter Invitees ID",
          labelText: "Invitees ID, Separate ids by ','",
        ),
      ),
    );
  }

  Widget callButton(bool isVideoCall) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: inviteeUsersIDTextCtrl,
      builder: (context, inviteeUserID, _) {
        var invitees = getInvitesFromTextCtrl(inviteeUsersIDTextCtrl.text);

        return ZegoSendCallInvitationButton(
          isVideoCall: isVideoCall,
          invitees: invitees,
          iconSize: const Size(40, 40),
          buttonSize: const Size(50, 50),
          onPressed: (String code, String message, List<String> errorInvitees) {
            if (errorInvitees.isNotEmpty) {
              String userIDs = "";
              for (int index = 0; index < errorInvitees.length; index++) {
                if (index >= 5) {
                  userIDs += '... ';
                  break;
                }

                var userID = errorInvitees.elementAt(index);
                userIDs += userID + ' ';
              }
              if (userIDs.isNotEmpty) {
                userIDs = userIDs.substring(0, userIDs.length - 1);
              }

              var message = 'User doesn\'t exist or is offline: $userIDs';
              if (code.isNotEmpty) {
                message += ', code: $code, message:$message';
              }
              showToast(
                message,
                position: StyledToastPosition.top,
                context: context,
              );
            } else if (code.isNotEmpty) {
              showToast(
                'code: $code, message:$message',
                position: StyledToastPosition.top,
                context: context,
              );
            }
          },
        );
      },
    );
  }

  List<ZegoUIKitUser> getInvitesFromTextCtrl(String textCtrlText) {
    List<ZegoUIKitUser> invitees = [];

    var inviteeIDs = textCtrlText.trim().replaceAll('，', '');
    inviteeIDs.split(",").forEach((inviteeUserID) {
      if (inviteeUserID.isEmpty) {
        return;
      }

      invitees.add(ZegoUIKitUser(
        id: inviteeUserID,
        name: 'user_$inviteeUserID',
      ));
    });

    return invitees;
  }
}





















// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: HomePage());
//   }
// }

// class HomePage extends StatelessWidget {
//   final callIDTextCtrl = TextEditingController(text: "testCallID");

//   HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: TextFormField(
//                   controller: callIDTextCtrl,
//                   decoration:
//                       const InputDecoration(labelText: "start a call by id"),
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) {
//                       return CallPage(callID: callIDTextCtrl.text);
//                     }),
//                   );
//                 },
//                 child: const Text("call"),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// String userID = Random().nextInt(10000).toString();

// class CallPage extends StatelessWidget {
//   const CallPage({Key? key, required this.callID}) : super(key: key);
//   final String callID;

//   @override
//   Widget build(BuildContext context) {
//     return ZegoUIKitPrebuiltCallWithInvitation(
//       appID: 4768693, // Your App ID
//       appSign:
//           '84d4e8ca326e5c830b5b15c509f2b70f57c944047be770ffbf3339bdd88e7b84', // Your App Sign
//       userID: userID,
//       userName: 'user_$userID',
//       plugins: [ZegoUIKitSignalingPlugin()],
//       notifyWhenAppRunningInBackgroundOrQuit: true,
//       isIOSSandboxEnvironment: false,
//       child: YourWidget(),
//     );
//   }
// }


////////////////////////////////////////////////////////////


// import 'package:flutter/material.dart';
// import 'package:zego_tes/Zego.dart';
// import 'package:zego_tes/zegotest.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Zego_teste',
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   bool test = true;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:
//           AppBar(title: Text('Zego test'), backgroundColor: Colors.amberAccent),
//       body: Center(
//         child: ElevatedButton(
//           child: (Text("Iniciar Chamada")),
//           onPressed: () async {
//             Navigator.push(context, MaterialPageRoute(builder: (context) {
//               return test ? const CallTest() : const GroupCallPage();
//             }));
//           },
//         ),
//       ),
//     );
//   }
// }
