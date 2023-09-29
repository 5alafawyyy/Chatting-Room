import 'package:chattingroom/firebase/sign_in_up.dart';
import 'package:chattingroom/models/chattingroom_model.dart';
import 'package:chattingroom/pages/search/search_page.dart';
import 'package:chattingroom/pages/user/user_detail_update_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../ui/theme.dart';
import '../room/chatting_room_page.dart';

class HomePage extends StatefulWidget {
  final UserModel? userModel;
  const HomePage({
    super.key,
    required this.userModel,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 8,
          toolbarHeight: 150,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Ui.mainColor, // Set the desired ring color
                    width: 4.0, // Set the desired ring width
                  ),
                ),
                child: CircleAvatar(
                  radius: Ui.width! / 9,
                  backgroundColor: Colors.black,
                  backgroundImage:
                      NetworkImage('${widget.userModel!.profilePic}'),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.userModel!.fullName}',
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  Text(
                    '${widget.userModel!.phoneNumber}',
                    maxLines: 1,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${widget.userModel!.bio}',
                    maxLines: 1,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(fontSize: 17),
                  ),
                ],
              ),
              const Expanded(
                child: SizedBox(),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (_) => UserDetailUpdatePage(
                                userModel: widget.userModel,
                              )));
                },
                child: const Icon(
                  Icons.settings,
                  size: 40,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (_) => SearchPage(
                          userModel: widget.userModel!,
                        )));
          },
          child: const Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chattingrooms")
                  .where("participants.${widget.userModel!.phoneNumber}",
                      isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot chattingroomSnapshot =
                        snapshot.data as QuerySnapshot;

                    return ListView.builder(
                      itemCount: chattingroomSnapshot.docs.length,
                      itemBuilder: (context, index) {
                        ChattingRoomModel chattingroomModel =
                            ChattingRoomModel.fromMap(
                                chattingroomSnapshot.docs[index].data()
                                    as Map<String, dynamic>);

                        Map<String, dynamic> participants =
                            chattingroomModel.participants!;

                        List<String> participantKeys =
                            participants.keys.toList();
                        participantKeys.remove(widget.userModel!.phoneNumber);

                        return FutureBuilder(
                          future: FirebaseMethods.getUserModelById(
                              participantKeys[0]),
                          builder: (context, userData) {
                            if (userData.connectionState ==
                                ConnectionState.done) {
                              if (userData.data != null) {
                                UserModel targetUser =
                                    userData.data as UserModel;

                                return Container(
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black,
                                          blurRadius: 2,
                                          spreadRadius: 2,
                                          blurStyle: BlurStyle.outer,
                                        )
                                      ]),
                                  child: ListTile(
                                    onLongPress: () async {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: Text(
                                                  'Delete Chat',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayLarge!
                                                      .copyWith(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                ),
                                                content: Text(
                                                  'Are You Sure You Want to Delete this Chat ?',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall!
                                                      .copyWith(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      await FirebaseAuth
                                                          .instance
                                                          .signOut()
                                                          .then((value) async {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'chattingrooms')
                                                            .doc(chattingroomModel
                                                                .chattingroomId)
                                                            .delete()
                                                            .then((value) {
                                                          return Navigator.pop(
                                                              context);
                                                        });
                                                      });
                                                    },
                                                    child: Text(
                                                      'Yes',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displayMedium!
                                                          .copyWith(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Colors
                                                                  .deepPurple),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      'No',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displayMedium!
                                                          .copyWith(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Colors
                                                                  .deepPurple),
                                                    ),
                                                  ),
                                                ],
                                              ));
                                    },
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return ChattingRoom(
                                            chattingRoom: chattingroomModel,
                                            firebaseUser: FirebaseMethods.user!,
                                            userModel: widget.userModel!,
                                            targetUser: targetUser,
                                          );
                                        }),
                                      );
                                    },
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          targetUser.profilePic.toString()),
                                      backgroundColor: Ui.mainColor,
                                    ),
                                    title: Text(targetUser.fullName.toString()),
                                    subtitle: (chattingroomModel.lastMessage
                                                .toString() !=
                                            "")
                                        ? Text(
                                            chattingroomModel.lastMessage
                                                .toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        : Text(
                                            "Say hi to your new friend!",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            } else {
                              return Container();
                            }
                          },
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    return const Center(
                      child: Text("No Chats"),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }
}

class UserDetailUpdatePageProvider {}
