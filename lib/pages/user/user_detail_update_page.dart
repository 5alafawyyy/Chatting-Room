// ignore_for_file: file_names, must_be_immutable, use_build_context_synchronously
import 'dart:io';

import 'package:chattingroom/pages/welcome/welcome_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../provider/user_detail_update_page_provider.dart';
import '../../ui/theme.dart';
import '../home/home_page.dart';

class UserDetailUpdatePage extends StatefulWidget {
  UserModel? userModel;
  UserDetailUpdatePage({super.key, required this.userModel});

  @override
  State<UserDetailUpdatePage> createState() => _UserDetailUpdatePageState();
}

class _UserDetailUpdatePageState extends State<UserDetailUpdatePage> {
  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile pickedFile) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20);
    if (croppedImage != null) {
      context
          .read<UserDetailUpdateProvider>()
          .setimageFile(File(croppedImage.path));
    }
  }

  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Upload Profile Picture',
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(fontSize: 15, fontWeight: FontWeight.w400),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  },
                  leading: const Icon(Icons.photo_album),
                  title: Text(
                    'Select From Gallery',
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(fontSize: 13, fontWeight: FontWeight.w200),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  leading: const Icon(Icons.camera_alt),
                  title: Text(
                    'Take a Photo',
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(fontSize: 12, fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          );
        });
  }

  late TextEditingController name;
  late TextEditingController bio;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.userModel!.fullName);
    bio = TextEditingController(text: widget.userModel!.bio);
  }

  void uploadDetails() async {
    String imageURL;
    if (context.read<UserDetailUpdateProvider>().imageFile != null) {
      UploadTask uploadImage = FirebaseStorage.instance
          .ref('profilepictures')
          .child(widget.userModel!.phoneNumber!)
          .putFile(context.read<UserDetailUpdateProvider>().imageFile!);
      TaskSnapshot snapshot = await uploadImage;
      imageURL = await snapshot.ref.getDownloadURL();
    } else {
      imageURL = widget.userModel!.profilePic!;
    }
    String fullname = name.text.trim();
    String ubio = bio.text.trim();
    if (kDebugMode) {
      print(fullname);
    }
    UserModel userModel = UserModel(
      phoneNumber: FirebaseAuth.instance.currentUser!.phoneNumber.toString(),
      fullName: fullname,
      bio: ubio,
      profilePic: imageURL,
    );
    Map<String, dynamic> mp = userModel.toMap();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber.toString())
        .update(mp)
        .then((value) => Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(
                builder: (_) => HomePage(
                      userModel: userModel,
                    )),
            (route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text(
                      'Log Out',
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                    content: Text(
                      'Are You Sure You Want to Log Out ?',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut().then((value) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                CupertinoPageRoute(
                                    builder: (_) => const WelcomePage()),
                                (route) => false);
                          });
                        },
                        child: Text(
                          'Yes',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.deepPurple),
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
                                  fontWeight: FontWeight.w400,
                                  color: Colors.deepPurple),
                        ),
                      ),
                    ],
                  ));
        },
        child: const Icon(
          Icons.logout,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Wrap(
                    children: [
                      Text(
                        'Update ',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(fontSize: 20),
                      ),
                      Text(
                        'Your Details',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(fontSize: 20, color: Colors.deepPurple),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CupertinoButton(
                    onPressed: () {
                      showPhotoOptions();
                    },
                    child: Consumer<UserDetailUpdateProvider>(
                      builder: (context, value, child) => CircleAvatar(
                        backgroundImage: (value.imageFile != null)
                            ? FileImage(value.imageFile!)
                            : (widget.userModel!.profilePic != null)
                                ? NetworkImage(widget.userModel!.profilePic!)
                                    as ImageProvider<Object>?
                                : null,
                        backgroundColor:
                            Theme.of(context).primaryColor.withAlpha(200),
                        radius: Ui.width! / 3.5,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextField(
                    controller: name,
                    decoration: InputDecoration(
                        hintText: 'Full Name',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(
                                fontSize: 18,
                                color: const Color.fromARGB(172, 119, 119, 119))),
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(fontSize: 18),
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: bio,
                    decoration: InputDecoration(
                        hintText: 'Bio...',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(
                                fontSize: 18,
                                color: const Color.fromARGB(172, 119, 119, 119))),
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(fontSize: 18),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (name.text.trim() == '' || bio.text.trim() == '') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Fill all Details'),
                            ),
                          );
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Center(
                                          child: CircularProgressIndicator()),
                                    ],
                                  ),
                                );
                              });
                          uploadDetails();
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.done),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Done',
                            style: Theme.of(context).textTheme.displayMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
