// ignore_for_file: file_names, use_build_context_synchronously

import 'package:chattingroom/firebase/sign_in_up.dart';
import 'package:chattingroom/models/chattingroom_model.dart';
import 'package:chattingroom/pages/room/chatting_room_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../models/user_model.dart';
import '../../provider/search_page_provider.dart';
import '../../ui/theme.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  const SearchPage({super.key, required this.userModel});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<ChattingRoomModel?> getchattingroomModel(UserModel targetUser) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chattingrooms")
        .where("participants.${widget.userModel.phoneNumber}", isEqualTo: true)
        .where("participants.${targetUser.phoneNumber}", isEqualTo: true)
        .get();
    ChattingRoomModel? chattingroom;

    if (snapshot.docs.isNotEmpty) {
      var docData = snapshot.docs[0].data();
      ChattingRoomModel existingchattingroom =
          ChattingRoomModel.fromMap(docData as Map<String, dynamic>);

      chattingroom = existingchattingroom;
    } else {
      ChattingRoomModel newchattingroom = ChattingRoomModel(
        chattingroomId: uuid.v1(),
        lastMessage: "",
        participants: {
          widget.userModel.phoneNumber.toString(): true,
          targetUser.phoneNumber.toString(): true,
        },
      );

      await FirebaseFirestore.instance
          .collection("chattingrooms")
          .doc(newchattingroom.chattingroomId)
          .set(newchattingroom.toMap());

      chattingroom = newchattingroom;
    }

    return chattingroom;
  }

  TextEditingController searchName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.chat,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: searchName,
                    onChanged: (value) {
                      context.read<SearchPageProvider>().setValue(value.trim());
                    },
                    decoration: InputDecoration(
                        hintText: 'Search Name...',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(
                                fontSize: 18,
                                color:
                                    const Color.fromARGB(172, 119, 119, 119))),
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(fontSize: 18),
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Consumer<SearchPageProvider>(
                      builder: (context, value, child) {
                    if (value.value == "") {
                      return const Text("No results found!");
                    } else {
                      return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .where("fullname",
                                isGreaterThanOrEqualTo: value.value,
                                isNotEqualTo: widget.userModel.fullName)
                            .where('fullname', isLessThan: '${value.value}z')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            if (snapshot.hasData) {
                              QuerySnapshot dataSnapshot =
                                  snapshot.data as QuerySnapshot;
                              List<QueryDocumentSnapshot> docs =
                                  dataSnapshot.docs;

                              if (docs.isNotEmpty) {
                                return SizedBox(
                                  height: Ui.height,
                                  width: Ui.width,
                                  child: ListView.builder(
                                    itemCount: docs.length,
                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> userMap = docs[index]
                                          .data() as Map<String, dynamic>;
                                      UserModel searchedUser =
                                          UserModel.fromMap(userMap);

                                      return Container(
                                        margin: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black,
                                                blurRadius: 2,
                                                spreadRadius: 2,
                                                blurStyle: BlurStyle.outer,
                                              )
                                            ]),
                                        width: Ui.width! / 1.1,
                                        child: ListTile(
                                          onTap: () async {
                                            ChattingRoomModel?
                                                chattingroomModel =
                                                await getchattingroomModel(
                                                    searchedUser);
                                            if (chattingroomModel != null) {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (context) =>
                                                          ChattingRoom(
                                                            userModel: widget
                                                                .userModel,
                                                            targetUser:
                                                                searchedUser,
                                                            firebaseUser:
                                                                FirebaseMethods
                                                                    .user!,
                                                            chattingRoom:
                                                                chattingroomModel,
                                                          )));
                                            }
                                          },
                                          leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                searchedUser.profilePic!),
                                            backgroundColor: Colors.grey[500],
                                          ),
                                          title: Text(searchedUser.fullName!),
                                          subtitle: Text(searchedUser.bio!),
                                          trailing:
                                              const Icon(Icons.send_rounded),
                                        ),
                                      );
                                    },
                                  ),
                                );

                                // return Text("No results found!");
                              } else {
                                return const Text("No results found!");
                              }
                            } else if (snapshot.hasError) {
                              return const Text("An error occurred!");
                            } else {
                              return const Text("No results found!");
                            }
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      );
                    }
                  }),
                ],
              ),
            )),
      ),
    );
  }
}
