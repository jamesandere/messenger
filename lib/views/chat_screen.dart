import 'package:flutter/material.dart';
import 'package:messenger/helper_functions/sharedpref_helper.dart';
import 'package:messenger/services/database.dart';
import 'package:random_string/random_string.dart';

class ChatScreen extends StatefulWidget {
  final String? chatWithUsername, name;
  ChatScreen({this.chatWithUsername, this.name});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? chatroomId, messageId = "";
  String? myName, myProfilePic, myUserName, myEmail;
  TextEditingController messageTextController = TextEditingController();

  getMyInfoFromSharedPref() async {
    myName = SharedPreferenceHelper().getDisplayName() as String?;
    myProfilePic = SharedPreferenceHelper().getUserProfileUrl() as String?;
    myUserName = SharedPreferenceHelper().getUserName() as String?;
    myEmail = SharedPreferenceHelper().getUserEmail() as String?;

    chatroomId =
        getChatroomIdByUsernames(widget.chatWithUsername!, myUserName!);
  }

  getChatroomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  addMessage(bool sendClicked){
    if(messageTextController.text.isNotEmpty){
      String message = messageTextController.text;

      var lastMessageTs = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "message" : message,
        "sendBy" : myUserName,
        "ts" : lastMessageTs,
        "imgUrl" : myProfilePic,
      };

      if(messageId == ""){
        messageId = randomAlphaNumeric(12);
      }
      
      DatabaseMethods().addMessage(chatroomId!, messageId!, messageInfoMap).then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage" : message,
          "lastMessageSendTs" : lastMessageTs,
          "lastMessageSendBy" : myUserName,
        };

        DatabaseMethods().updateLastMessageSend(chatroomId!, lastMessageInfoMap);

        if(sendClicked){
          //remove the text from text field
          messageTextController.text = "";

          //make message id blank
          messageId = "";
        }
      });
    }
  }

  getAndSetMessages() async {}

  doThisOnLaunch() async {
    await getMyInfoFromSharedPref();
    getAndSetMessages();
  }

  @override
  void initState() {
    doThisOnLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name!,
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(color: Colors.black.withOpacity(0.8),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Send a message..",
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        controller: messageTextController,
                      ),
                    ),
                    Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
