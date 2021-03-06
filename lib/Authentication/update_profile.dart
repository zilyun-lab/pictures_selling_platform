// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

// Project imports:
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/DialogBox/error_dialog.dart';
import 'package:selling_pictures_platform/DialogBox/loading_dialog.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'my_page.dart';

class ChangeProfile extends StatefulWidget {
  @override
  _ChangeProfileState createState() => _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {
  final TextEditingController _nameEditingController = TextEditingController(
      text: EcommerceApp.sharedPreferences
          .getString(EcommerceApp.userName)
          .trim()
          .toString());
  final TextEditingController _descriptionEditingController =
      TextEditingController(
          text: EcommerceApp.sharedPreferences
              .getString(EcommerceApp.userDescription)
              .toString());
  final TextEditingController _facebookEditingController =
      TextEditingController(
          text: EcommerceApp.sharedPreferences
              .getString(EcommerceApp.FaceBookURL)
              .toString());
  final TextEditingController _instagramEditingController =
      TextEditingController(
          text: EcommerceApp.sharedPreferences
              .getString(EcommerceApp.InstagramURL)
              .toString());
  final TextEditingController _twitterEditingController = TextEditingController(
      text: EcommerceApp.sharedPreferences
          .getString(EcommerceApp.TwitterURL)
          .toString());
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String userImageUrl =
      EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl);
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: bgColor,
        title: Text(
          '????????????????????????',
          style: TextStyle(
            color: mainColorOfLEEWAY,
            fontSize: 20,
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              InkWell(
                onTap: _selectAndPickImage,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                  ),
                  child: CircleAvatar(
                    radius: _screenWidth * 0.15,
                    backgroundImage: _imageFile == null
                        ? NetworkImage(userImageUrl)
                        : FileImage(_imageFile),
                    child: _imageFile == null ? null : null,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Neumorphic(
                        style: NeumorphicStyle(
                            depth: NeumorphicTheme.embossDepth(context),
                            boxShape: const NeumorphicBoxShape.stadium(),
                            color: bgColor),
                        child: TextFormField(
                          obscureText: false,
                          controller:
                              _nameEditingController, //..text = nameData,

                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '?????????????????????',
                              prefixIcon: Icon(
                                Icons.perm_identity,
                                color: Colors.black,
                              )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Neumorphic(
                        style: NeumorphicStyle(
                            depth: NeumorphicTheme.embossDepth(context),
                            boxShape: const NeumorphicBoxShape.stadium(),
                            color: bgColor),
                        child: TextFormField(
                          obscureText: false,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller:
                              _descriptionEditingController, //..text = descriptionData,

                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '????????????',
                              prefixIcon: Icon(
                                Icons.article_outlined,
                                color: Colors.black,
                              )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Neumorphic(
                        style: NeumorphicStyle(
                            depth: NeumorphicTheme.embossDepth(context),
                            boxShape: const NeumorphicBoxShape.stadium(),
                            color: bgColor),
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: TextFormField(
                            obscureText: false,
                            controller: _facebookEditingController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'FaceBook',
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(
                                      top: 8,
                                      bottom: 8,
                                      right: 8,
                                      left: 14),
                                  child: FaIcon(
                                    FontAwesomeIcons.facebookSquare,
                                    color: Colors.black,
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Neumorphic(
                        style: NeumorphicStyle(
                            depth: NeumorphicTheme.embossDepth(context),
                            boxShape: const NeumorphicBoxShape.stadium(),
                            color: bgColor),
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: TextFormField(
                            obscureText: false,
                            controller: _twitterEditingController,
                            onChanged: (text) => {},
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Twitter',
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(
                                    top: 8,
                                    bottom: 8,
                                    right: 8,
                                    left: 14,
                                  ),
                                  child: FaIcon(
                                    FontAwesomeIcons.twitterSquare,
                                    color: Colors.black,
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Neumorphic(
                        style: NeumorphicStyle(
                            depth: NeumorphicTheme.embossDepth(context),
                            boxShape: const NeumorphicBoxShape.stadium(),
                            color: bgColor),
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: TextFormField(
                            obscureText: false,
                            controller:
                                _instagramEditingController, //..text = descriptionData,
                            onChanged: (text) => {},
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Instagram',
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(
                                    top: 8,
                                    bottom: 8,
                                    right: 8,
                                    left: 14,
                                  ),
                                  child: FaIcon(
                                    FontAwesomeIcons.instagramSquare,
                                    color: Colors.black,
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Wrap(
                children: [
                  NeumorphicButton(
                    style: NeumorphicStyle(color: Colors.grey.withOpacity(0.5)),
                    onPressed: () {
                      final Route route = MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (c) => MyPage(),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text(
                      '???????????????',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  NeumorphicButton(
                    style: const NeumorphicStyle(color: Colors.blueAccent),
                    onPressed: () {
                      print(EcommerceApp.sharedPreferences
                          .getString(EcommerceApp.FaceBookURL));
                      uploadAndSaveImage();
                    },
                    child: const Text(
                      '  ????????????  ',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getData(subcollection) async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    return data.data()[subcollection];
  }

  //todo:!?
  Future<void> _selectAndPickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    //todo:????????????????????????????????????
    setState(
      () {
        _imageFile = File(pickedFile.path);
      },
    );
  }

  Future<void> uploadAndSaveImage() async {
    if (_nameEditingController.text.isEmpty) {
      await showDialog(
        context: context,
        builder: (c) {
          return const ErrorAlertDialog(
            message: '????????????????????????????????????',
          );
        },
      );
    }

    _imageFile == null ? saveUserInfoToFirestore() : uploadToStorage();
  }

  dynamic displayDialog(String msg) {
    showDialog(
      context: context,
      builder: (c) {
        return ErrorAlertDialog(
          message: msg,
        );
      },
    );
  }

  dynamic uploadToStorage() async {
    await showDialog(
      context: context,
      builder: (c) {
        return const LoadingAlertDialog(
          message: '??????????????????\n??????????????????????????????',
        );
      },
    );
    final imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    final storage = FirebaseStorage.instance;
    final storageReference = storage.ref().child(imageFileName);
    final storageUploadTask = storageReference.putFile(_imageFile);
    final taskSnapshot = await storageUploadTask;
    await taskSnapshot.ref.getDownloadURL().then(
      (urlImage) {
        userImageUrl = urlImage;
        saveUserInfoToFirestore();
      },
    );
  }

  Future saveUserInfoToFirestore() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(EcommerceApp.auth.currentUser.uid)
        .update(
      {
        'name': _nameEditingController.text.trim(),
        'url': userImageUrl,
        'description': _descriptionEditingController.text.trim(),
        'InstagramURL': _instagramEditingController.text.trim(),
        'FaceBookURL': _facebookEditingController.text.trim(),
        'TwitterURL': _twitterEditingController.text.trim(),
      },
    );

    await EcommerceApp.sharedPreferences.setString(
      EcommerceApp.userName,
      _nameEditingController.text,
    );
    await EcommerceApp.sharedPreferences.setString(
      EcommerceApp.userAvatarUrl,
      userImageUrl,
    );
    await EcommerceApp.sharedPreferences.setString(
      'description',
      _descriptionEditingController.text,
    );
    await EcommerceApp.sharedPreferences.setString(
      'TwitterURL',
      _twitterEditingController.text,
    );
    await EcommerceApp.sharedPreferences.setString(
      'InstagramURL',
      _instagramEditingController.text,
    );
    await EcommerceApp.sharedPreferences.setString(
      'FaceBookURL',
      _facebookEditingController.text,
    );

    Navigator.pop(context);
  }
}
