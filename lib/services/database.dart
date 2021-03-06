import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

  Future addUserInfoToDB(String userId, Map<String, dynamic> userInfoMap) async{
    return FirebaseFirestore.instance.collection('users').doc(userId).set(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getUserByUsername(String username) async {
    return FirebaseFirestore.instance.collection('users').where('username', isEqualTo: username).snapshots();
  }

  Future addMessage(String chatroomId, String messageId, Map<String, dynamic> messageInfoMap){
    return FirebaseFirestore.instance.collection('chatrooms').doc(chatroomId).collection('chats').doc(messageId).set(messageInfoMap);
  }

  updateLastMessageSend(String chatroomId, Map<String, dynamic> lastMessageInfo){
    return FirebaseFirestore.instance.collection('chatrooms').doc(chatroomId).update(lastMessageInfo);
  }

  createChatRoom(String chatRoomId, Map<String, dynamic> chatroomInfoMap) async{
    final snapshot = await FirebaseFirestore.instance.collection('chatrooms').doc(chatRoomId).get();
    if(snapshot.exists){
      //chatroom already exists
      return true;
    }
    else{
      //chatroomdoes not exists, create one
      return FirebaseFirestore.instance.collection('chatrooms').doc(chatRoomId).set(chatroomInfoMap);
    }
  }
}