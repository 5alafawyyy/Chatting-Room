// ignore_for_file: file_names

import 'package:chattingroom/models/chattingroom_model.dart';
import 'package:chattingroom/models/message_model.dart';
import 'package:chattingroom/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../ui/theme.dart';
import '../call/video_call_page.dart';

class ChattingRoom extends StatefulWidget {
  final UserModel targetUser;
  final ChattingRoomModel chattingRoom;
  final UserModel userModel;
  final User firebaseUser;
  const ChattingRoom(
      {Key? key,
      required this.targetUser,
      required this.chattingRoom,
      required this.userModel,
      required this.firebaseUser})
      : super(key: key);

  @override
  State<ChattingRoom> createState() => _ChattingRoomState();
}

class _ChattingRoomState extends State<ChattingRoom> {
  TextEditingController messageController = TextEditingController();
  void sendMessage() async {
    String? message = messageController.text.trim();
    messageController.clear();
    if (message != "") {
      MessageModel newMessage = MessageModel(
        messageId: uuid.v1(),
        createdOn: DateTime.now(),
        seen: false,
        sender: widget.userModel.phoneNumber,
        text: message,
      );
      FirebaseFirestore.instance
          .collection('chattingrooms')
          .doc(widget.chattingRoom.chattingroomId)
          .collection('messages')
          .doc(newMessage.messageId)
          .set(newMessage.toMap());
      widget.chattingRoom.lastMessage = message;
      FirebaseFirestore.instance
          .collection('chattingrooms')
          .doc(widget.chattingRoom.chattingroomId)
          .set(widget.chattingRoom.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        actions: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('vc')
                .doc(widget.chattingRoom.chattingroomId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  // ignore: unused_local_variable
                  DocumentSnapshot datasnapshot =
                      snapshot.data as DocumentSnapshot;

                  final data = snapshot.data?.data()?['VideoCall'] ?? false;
                  if (data == true) {
                    return IconButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('vc')
                              .doc(widget.chattingRoom.chattingroomId)
                              .set({'VideoCall': true});
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => VideoCallPage(
                                      callID:
                                          widget.chattingRoom.chattingroomId!,
                                      userId: widget.userModel.phoneNumber!,
                                      userName: widget.userModel.fullName!)));
                        },
                        icon: const Icon(Icons.video_call,
                            color: Colors.green, size: 30));
                  } else {
                    return IconButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('vc')
                              .doc(widget.chattingRoom.chattingroomId)
                              .set({'VideoCall': true});
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => VideoCallPage(
                                      callID:
                                          widget.chattingRoom.chattingroomId!,
                                      userId: widget.userModel.phoneNumber!,
                                      userName: widget.userModel.fullName!)));
                        },
                        icon: const Icon(Icons.video_call,
                            color: Colors.black, size: 30));
                  }
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                        "An error occured! Please check your internet connection."),
                  );
                } else {
                  return const Center(
                    child: Text("Say hi to your new friend"),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.targetUser.profilePic!),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.targetUser.fullName}',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                Text(
                  '${widget.targetUser.phoneNumber}',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontSize: 12, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 4,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chattingrooms')
                      .doc(widget.chattingRoom.chattingroomId)
                      .collection('messages')
                      .orderBy('createdon', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot datasnapshot =
                            snapshot.data as QuerySnapshot;
                        return ListView.builder(
                          reverse: true,
                          itemCount: datasnapshot.docs.length,
                          itemBuilder: (context, index) {
                            MessageModel currentMessage = MessageModel.fromMap(
                                datasnapshot.docs[index].data()
                                    as Map<String, dynamic>);
                            if (currentMessage.sender !=
                                widget.userModel.phoneNumber) {
                              currentMessage.seen = true;
                              FirebaseFirestore.instance
                                  .collection('chattingrooms')
                                  .doc(widget.chattingRoom.chattingroomId)
                                  .collection('messages')
                                  .doc(currentMessage.messageId)
                                  .update(currentMessage.toMap());
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: Row(
                                mainAxisAlignment: (currentMessage.sender ==
                                        widget.userModel.phoneNumber)
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Container(
                                      constraints: BoxConstraints(
                                          maxWidth: Ui.width! / 2),
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 2,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: (currentMessage.sender ==
                                                widget.userModel.phoneNumber)
                                            ? Theme.of(context).primaryColor
                                            : Colors.black,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Flexible(
                                            child: Column(
                                              children: [
                                                Text(
                                                  maxLines: null,
                                                  currentMessage.text
                                                      .toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          (currentMessage.sender ==
                                                  widget.userModel.phoneNumber)
                                              ? Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    (currentMessage.seen ==
                                                            true)
                                                        ? const Icon(
                                                            Icons.done_all,
                                                            color: Colors.white,
                                                            size: 15,
                                                          )
                                                        : const Icon(
                                                            Icons.done,
                                                            color: Colors.white,
                                                            size: 15,
                                                          ),
                                                  ],
                                                )
                                              : Container(),
                                        ],
                                      )),
                                ],
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                              "An error occured! Please check your internet connection."),
                        );
                      } else {
                        return const Center(
                          child: Text("Say hi to your new friend"),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: messageController,
                      maxLines: null,
                      decoration: InputDecoration(
                          hintText: 'Enter message...',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  fontSize: 15,
                                  color: const Color.fromARGB(
                                      172, 119, 119, 119))),
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(fontSize: 15),
                      keyboardType: TextInputType.name,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Icon(
                      Icons.send,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
