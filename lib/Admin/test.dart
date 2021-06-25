import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Test extends StatefulWidget {
  const Test({Key key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  List<File> _image = [];
  List<String> _imagesURL = [];
  Reference ref;
  bool uploading = false;
  double val = 0;
  final picker = ImagePicker();

  Future uploadFile() async {
    int i = 1;

    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      final Reference storageReference =
          FirebaseStorage.instance.ref().child("Items");
      ref = storageReference.child("product_$i.jpg");
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          _imagesURL.add(value);
          i++;
          print(_imagesURL);
        });
      });
    }
  }

  saveToFB() {
    FirebaseFirestore.instance
        .collection("testImages")
        .doc()
        .collection("itemImages")
        .doc()
        .set({'image': _imagesURL}).whenComplete(() {
      setState(() {
        _imagesURL = [];
      });
    });
  }

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile?.path));
    });
    if (pickedFile.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file.path));
      });
    } else {
      print(response.file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4),
            child: GridView.builder(
                shrinkWrap: true,
                itemCount: _image.length + 1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return index == 0
                      ? Center(
                          child: _image.length <= 4
                              ? IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () =>
                                      !uploading ? chooseImage() : null)
                              : IconButton(
                                  icon: Icon(Icons.add),
                                ),
                        )
                      : Container(
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(_image[index - 1]),
                                  fit: BoxFit.cover)),
                        );
                }),
          ),
          ElevatedButton(
              onPressed: () {
                uploadFile();
                saveToFB();
              },
              child: Text("go"))
        ],
      ),
    );
  }
}
