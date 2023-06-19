
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flipflop/firebase/firestore_collections.dart';
import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ConfirmPage extends StatefulWidget {
  final File videofile;
  final String videopath_aString;
  final ImageSource imageSource;

  ConfirmPage({required this.imageSource, required this.videofile,required this.videopath_aString});

  @override
  State<ConfirmPage> createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {

  late VideoPlayerController controller;
  late TextEditingController musicController;
  late TextEditingController captionController;
  var videocompress = VideoCompress;

  String video = "";
  String image = "";
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    
    musicController = TextEditingController();
    captionController = TextEditingController();

    setState(() {
      controller = VideoPlayerController.file(widget.videofile); 
       
      
    });

    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
    
  }


previewImage() async{
  final previewimage = await videocompress.getFileThumbnail(widget.videopath_aString);
  return previewimage;
}  

uploadimagetostorage(String id)async {
  /*var firebaseuid = FirebaseAuth.instance.currentUser!.uid;
  DocumentSnapshot userdoc = await usercollections.doc(firebaseuid).get();
  var alldoc = await videocollections.get();
  int length = alldoc.docs.length;*/
  final uploadTask = imagebucket.child(id).putFile(await previewImage());
  String downloadurl = "";
  final uploadTasksnapShot = uploadTask.snapshotEvents.listen((taskSnapShot) async {
  switch (taskSnapShot.state) {
       case TaskState.running:
        final progress =
          100.0 * (taskSnapShot.bytesTransferred / taskSnapShot.totalBytes);
      print("Upload is $progress% complete.");
      break;
    case TaskState.paused:
       print("Upload is paused.");
      break;
    case TaskState.canceled:
      print("Upload is cancelled.");
      break;
    case TaskState.error:
      // ...
      break;  
    case TaskState.success:
      String downloadurl = await taskSnapShot.ref.getDownloadURL();
      image = downloadurl;
      print("This is the rhythm of the night with $image");
       setState(() {
          _isLoading = false;
       });
      break;

     } 
   });

   print("we'll take our leave and go $downloadurl");
   return downloadurl;

  
}

compressVideo() async{
    if (widget.imageSource == ImageSource.gallery){
      return widget.videofile;
    }else {
      final compressedVideo = await videocompress.compressVideo(
        widget.videopath_aString,
        quality: VideoQuality.MediumQuality);
       print("check what is null in $compressedVideo");
      return compressedVideo ; 
    }
}

uploadvideotostorage (String id) async{
  /*var firebaseuid = FirebaseAuth.instance.currentUser!.uid;
  DocumentSnapshot userdoc = await usercollections.doc(firebaseuid).get();
  var alldoc = await videocollections.get();
  int length = alldoc.docs.length;*/
final uploadTask = videosbucket.child(id).putFile(await compressVideo());
String downloadurl = "";
final uploadTasksnapShot = uploadTask.snapshotEvents.listen((taskSnapShot) async {
  switch (taskSnapShot.state) {
    case TaskState.running:
    setState(() {
      _isLoading = true;
      final progress =
          100.0 * (taskSnapShot.bytesTransferred / taskSnapShot.totalBytes);
      print("Upload is $progress% complete.");
    });
      break;
    case TaskState.paused:
       print("Upload is paused.");
      break;
    case TaskState.canceled:
      print("Upload is cancelled.");
      break;
    case TaskState.error:
      // ...
      break;  
    case TaskState.success:
      String downloadurl = await taskSnapShot.ref.getDownloadURL();
        video = downloadurl;
        print(" da da da $video");
        setState(() {
          _isLoading = false;
        });
      break;
     }   
   });
  print("Again master stroke here $downloadurl");
}

uploadvideo() async{
   setState(() {
      _isLoading = true;
    });
  try{
     print("trying to put data in firebase");
  var firebaseuid = FirebaseAuth.instance.currentUser!.uid;
  DocumentSnapshot userdoc = await usercollections.doc(firebaseuid).get();
  var alldoc = await videocollections.get();
  int length = alldoc.docs.length;
  setState(() {
      uploadvideotostorage("Video $length");
      uploadimagetostorage("Video $length");
  });
 
  print("trying to put data in firebase 2");
  //print("Again this good point here $image also ${data['username']}");
  print("one day when toungueing is done we take our leave $video");
  await videocollections.doc("Video $length").set({
    'username': userdoc.get("fullname"),
    'uid': firebaseuid,
    'id': "Video $length",
    'likes':[],
    'commentscount': 0,
    'sharecount':0,
    'songname': musicController.text,
    'caption': captionController.text,
    'videourl': video,
    'previewimage': image,
  }).then((value) {
    print("put data in firebase 3");
    setState(() {
      _isLoading = false;

    });
  }).onError((error, stackTrace) {
    print("here i am in a error $error and what is it $stackTrace");
    setState(() {
      print("fail to put data in firebase 3");
       _isLoading = false;
       print("Whats the error here $error");
     });
  });
  }catch(e){
    print(e);
  }
  
  
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? Center(child: Column(
      children: [
        Text("Uploading....."), 
      CircularProgressIndicator()
      ]
      ),): Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/1.5,              
              child: VideoPlayer(controller),
            ),
            SizedBox(height: 20,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                Container(
                  width: MediaQuery.of(context).size.width/2,
                  margin: EdgeInsets.only(left:10, right: 10 ),
                  child:  TextField(
                    controller: musicController,
                    decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Song Name",
                    prefixIcon: Icon(Icons.music_note),
                    border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                    )
                  ),),
                ),
                 Container(
                  width: MediaQuery.of(context).size.width/2,
                  margin: EdgeInsets.only(left:10, right: 10 ),
                  child:  TextField(
                    controller: captionController,
                    decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Caption",
                    prefixIcon: Icon(Icons.closed_caption),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)
                    )
                    ),
                  ),
                ),
              ],
              ),
            ),
            SizedBox(height: 20,),
            Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
              MaterialButton(
              onPressed: (){
                setState(() {
                    uploadvideo();
                });
              }, 
              color: Colors.lightBlue, 
              child: Text("Upload Video"),
              ),
               MaterialButton(
              onPressed: () => Navigator.pop(context), 
              color: Colors.redAccent, 
              child: Text("Another video"),
              )


             ],
            )
          ],
        )
     ),
    );
  }
}


