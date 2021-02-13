import 'dart:io';
import 'package:blog_app/services/crud.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  bool _isLoading = false;
  String authorName, title, desc;
  CrudMethods crudMethods = new CrudMethods();
  File selectedImage;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  //
  uploadBlog() async {
    if (selectedImage != null) {
      setState(() {
        _isLoading = true;
      });

      /// uploading image to firebase storage
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("blogImages")
          .child("${randomAlphaNumeric(9)}.jpg");

      final UploadTask task = firebaseStorageRef.putFile(selectedImage);

      task.whenComplete(() async {
        try {
          var downloadURL = await firebaseStorageRef.getDownloadURL();
          print("this is url $downloadURL");
        } catch (onError) {
          print("Error");
        }
      });
      // var downloadUrl =
      //     await (await task.whenComplete(() => null)).ref.getDownloadURL();

      // Map<String, String> blogMap = {
      //   "imgUrl": //downloadURL,
      //   "authorName": authorName,
      //   "title": title,
      //   "desc": desc
      // };
      Navigator.pop(context);
      // crudMethods.addData(blogMap).then((result) {
      //
      // });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Flutter",
              style: TextStyle(fontSize: 22),
            ),
            Text(
              "Blog",
              style: TextStyle(fontSize: 22, color: Colors.blue),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              uploadBlog();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.file_upload),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: selectedImage != null
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            height: 170,
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.file(
                                selectedImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            height: 170,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.black,
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(hintText: "Author Name"),
                          onChanged: (val) {
                            authorName = val;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(hintText: "Title"),
                          onChanged: (val) {
                            title = val;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(hintText: "Desc"),
                          onChanged: (val) {
                            desc = val;
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
