import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipflop/firebase/firestore_collections.dart';
import 'package:flipflop/widget/circle_animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'comments.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({ Key? key }) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late Stream mystream;
  String uid = "";



  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    mystream = videocollections.snapshots();
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: 
      StreamBuilder(
        stream: mystream,
        builder: (context, AsyncSnapshot snapshot) {
          if(snapshot.data == null){
            print("yessss");
            print("the snaphot is $snapshot");
            return Center(
              child: CircularProgressIndicator(),
            );
          }else{
            return PageView.builder(
            itemCount: snapshot.data.docs.length,
            controller: PageController(initialPage: 0,viewportFraction: 1),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              DocumentSnapshot video = snapshot.data.docs[index];
              return Stack(
                children: [
                VideoPlayerItem(videourl: video["videourl"]) , 
                // for you section
                Padding(
                  padding: const EdgeInsets.all(80.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                          Text("Following",style: TextStyle(color: Colors.white)),
                          SizedBox(width: 10.0,),
                          Text("For you",style: TextStyle(color: Colors.white))
                        ],)
                      ],
                    ),
                    ),
                ),
                  // middle section
                 Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                            Container(
                              margin: EdgeInsets.only(top: 250),
                              alignment: Alignment.bottomLeft,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${video["songname"]}",style: TextStyle(color: Colors.white),),
                                     Text(video['caption'], style: TextStyle(color: Colors.white),),
                                    Row(children: const [
                                      Icon(Icons.music_note,color: Colors.white,),
                                      Text("Viva'la gloria",style: TextStyle(color: Colors.white),)
                              ]
                              )
                    ],
                              ),
                            )
                            ,
                               // right section
                
                       Container(
                        alignment: Alignment.bottomRight,
                        width: 100,
                        margin: EdgeInsets.only(top: 150,left: 150),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                                 _buildProfile(video['previewimage']),
                                 Column(
                                  children:  [
                                    InkWell(
                                      onTap:() => _likeButton(video["id"]),
                                      child: Icon(Icons.favorite, size: 55, 
                                      color: video['likes'].contains(uid) ? Colors.redAccent : Colors.white
                                      )
                                      ),
                                    SizedBox(height: 7,),
                                    Text("${video["likes"].length}",style: TextStyle(color: Colors.white),)
                                 ],),
                                 Column(
                                  children: [
                                    InkWell(
                                      onTap: () => Navigator.push(context,
                                       MaterialPageRoute(builder: (context) => CommentsPage(id: video['id'],))),
                                      child: Icon(Icons.comment, size: 55, color: Colors.white)),
                                    SizedBox(height: 7,),
                                    Text("${video['commentscount'].toString()}",style: TextStyle(color: Colors.white))
                                 ],),
                                  Column(
                                  children: [
                                    InkWell(
                                      child: Icon(Icons.share, size: 55, color: Colors.white),
                                      onTap: () => sharevideo(video['videourl'],video["id"]),
                                    ),
                                    SizedBox(height: 7),
                                    Text("5",style: TextStyle(color: Colors.white))
                                 ],),
                                 Column(
                                  children: [
                                          CircleAnimation(child: buildmusicAlbum(video['previewimage']))
                                  ],
                                 )
                          ],
                        ),
                       )
                          ],)
                            
                          ],
                        )
                      ), 
                       ),
              ],);
            }
          );
          
          }
         
        }
      )    ,
    );
  }

  sharevideo(String video,String id) async{
       var request = await HttpClient().getUrl(Uri.parse(video));
       var response = await request.close();
       Uint8List bytes = await consolidateHttpClientResponseBytes(response);
       /*await Share.file("Fliflop", 'viedeo.mp4', bytes, "video/mp4");
       DocumentSnapshot doc = await videocollections.doc(id).get();
       videocollections.doc(id).update({
        "sharecount": doc.get("sharecount") + 1
       });*/
  }

  _likeButton(String id) async{
        String uid = FirebaseAuth.instance.currentUser!.uid;
        DocumentSnapshot doc = await videocollections.doc(id).get();
        if(doc.get('likes').contains(uid)){
            videocollections.doc(id).update({
              'likes': FieldValue.arrayRemove([uid])
            });
        }else{
            videocollections.doc(id).update({
              'likes': FieldValue.arrayUnion([uid])
            });
        }
  }

  _buildProfile(String url) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0,bottom: 18.0),
      child: Container(
        width: 55,
        height: 55,
        child: Stack(children: [
          Positioned(child:Container(
            width: 50,
            height: 50,
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration( 
              color: Colors.white,
              borderRadius: BorderRadius.circular(25)
              ),
            child: ClipRRect(child: Image(image: NetworkImage("$url"), fit: BoxFit.cover,),),  
          )
          ),

          Positioned(
            bottom: 0,
            left: (60/2) - (20/2),
            child: Container(
              width: 20, 
              height: 20,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(15)
              ),
              child: Icon(Icons.add, color: Colors.white, size: 20,),
              )
            
          )

        ],
        ),
      ),
    );
  }

  buildmusicAlbum(String url) {
       return Container(
        width: 60,
        height: 60,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(11.0),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors:[Colors.grey.shade800,Colors.grey.shade900 ])
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(image: NetworkImage("$url")),
                ),
            )
        ]),
       );
  }
}



class VideoPlayerItem extends StatefulWidget {
  final String videourl;
  VideoPlayerItem({required this.videourl});

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videourl)
    ..initialize().then((value){
     videoPlayerController.play();
     videoPlayerController.setVolume(1);
  
    } );
  }


  

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: VideoPlayer(videoPlayerController),
    );
  }


  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }
}