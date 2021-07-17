import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/helper_functions/sharedpref_helper.dart';
import 'package:messenger/services/auth.dart';
import 'package:messenger/services/database.dart';
import 'package:messenger/views/chat_screen.dart';
import 'package:messenger/views/sign_in.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearching = false;
  Stream? usersStream;

  TextEditingController searchUsernameController = TextEditingController();
  String? myName, myProfilePic, myUserName, myEmail;

  getMyInfoFromSharedPref() async {
    myName = SharedPreferenceHelper().getDisplayName() as String?;
    myProfilePic = SharedPreferenceHelper().getUserProfileUrl() as String?;
    myUserName = SharedPreferenceHelper().getUserName() as String?;
    myEmail = SharedPreferenceHelper().getUserEmail() as String?;

  }

  getChatroomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  onSearchButtonClick() async {
    isSearching = true;
    setState(() {});
    usersStream = await DatabaseMethods()
        .getUserByUsername(searchUsernameController.text);
  }

  Widget searchListUserTile({String? profileUrl, name, username, email}) {
    return GestureDetector(
      onTap: (){
        var chatroomId = getChatroomIdByUsernames(myUserName!, username);
        Map<String, dynamic> chatRoomInfo = {
          "users" : [myUserName, username],
        };
        DatabaseMethods().createChatRoom(chatroomId, chatRoomInfo);
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return ChatScreen(
            chatWithUsername: username,
            name: name,
          );
        }));
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40.0),
              child: Image.network(
            profileUrl!,
            width: 40.0,
            height: 40.0,
          )),
          SizedBox(
            width: 12.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name),
              Text(email),
            ],
          ),
        ],
      ),
    );
  }

  Widget searchUsersList(BuildContext context) {
    return StreamBuilder(
      stream: usersStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                  return searchListUserTile(profileUrl: documentSnapshot["imgUrl"],
                      name: documentSnapshot["name"], email: documentSnapshot["email"],
                  username: documentSnapshot["username"]);
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Widget chatRoomList() {
    return Container();
  }

  @override
  void initState() {
    getMyInfoFromSharedPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Messenger",
        ),
        actions: [
          InkWell(
            onTap: () {
              AuthMethods().signOut().then((value) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return SignIn();
                }));
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(
                Icons.exit_to_app,
              ),
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Row(
              children: [
                isSearching
                    ? GestureDetector(
                        onTap: () {
                          isSearching = false;
                          searchUsernameController.text = "";
                          setState(() {});
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 12.0),
                          child: Icon(
                            Icons.arrow_back,
                          ),
                        ),
                      )
                    : Container(),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 16.0),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchUsernameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'username',
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (searchUsernameController.text.isNotEmpty) {
                              onSearchButtonClick();
                            }
                          },
                          child: Icon(
                            Icons.search,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            isSearching ? searchUsersList(context) : chatRoomList(),
          ],
        ),
      ),
    );
  }
}
