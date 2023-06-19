import 'dart:io';

import 'package:flipflop/screens/confirm_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddVideoPage extends StatefulWidget {
  const AddVideoPage({ Key? key }) : super(key: key);

  @override
  State<AddVideoPage> createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {

  pickvideo(ImageSource src)async {
      Navigator.pop(context);
      final video = await ImagePicker().getVideo(source: src);
      Navigator.push(context, MaterialPageRoute(builder: (context) => 
      ConfirmPage(imageSource: src, videofile: File(video!.path), videopath_aString:video.path ))
      );
  }


  showOptionsDialog() {
  return showDialog(context: context, builder:(context){
    return SimpleDialog(
      children: [
        SimpleDialogOption(
          child: Text("Gallery"),
          onPressed: () {
            pickvideo(ImageSource.gallery);
          },
        ),
        SimpleDialogOption(
          child: Text("Camera"),
          onPressed: (){
            pickvideo(ImageSource.camera);
          },
        ),
        SimpleDialogOption(
          child: Text("Gallery"),
          onPressed: (){
             pickvideo(ImageSource.gallery);
          },
          )
      ],
    );
  } );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: InkWell(
          onTap: () => showOptionsDialog(),
          child: Center(
            child: Container(
              width: 180,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.redAccent
              ),
              child: Center(child: Text("Add Video", style: TextStyle(fontSize: 25.0),)),
              ),
          ),
        ),
    );
  }
}

