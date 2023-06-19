

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipflop/firebase/firestore_collections.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  ProfilePage({required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "";
  String onlineuser = "";
  String profilepic = "";
  int likes = 0;
  late int followers;
  late int following;
  bool isfollowing = false;

  late Future myvideos;
  bool isdata = false;
  TextEditingController usernamecontroller = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getalluserData();
  }

  followuser()async{
    var document = await usercollections
        .doc(widget.uid)
        .collection('followers')
        .doc(onlineuser)
        .get();
    if(!document.exists){
       usercollections.doc(widget.uid)
          .collection('followers')
          .doc(onlineuser)
          .set({});
       usercollections.doc(onlineuser)
          .collection('following')
          .doc(widget.uid)  
          .set({});
       setState(() {
            isfollowing = true;
            followers++;
        });

    } else{
       usercollections
          .doc(widget.uid)
          .collection('followers')
          .doc(onlineuser)
          .delete();
      usercollections
          .doc(onlineuser)
          .collection('followers')
          .doc(widget.uid)
          .delete();
      setState(() {
            isfollowing = false;
            followers--;
      });    
    }   
  }


  

  getalluserData()async{
    
    myvideos = videocollections.where('uid', isEqualTo: widget.uid).get();
    onlineuser = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userdoc = await usercollections.doc(widget.uid).get();
    username = userdoc.get("fullname");
    var documents = await videocollections.where('uid', isEqualTo: widget.uid).get();
    for( var item in documents.docs){
      likes = item.get("likes").length + likes;
    }

    var getfollowersdocuments= await usercollections.doc(widget.uid).collection('followers').get();

    var getfollowingdocuments = await usercollections.doc(widget.uid).collection('following').get();

    followers = getfollowersdocuments.docs.length;
    following = getfollowingdocuments.docs.length;

    usercollections
    .doc(widget.uid)
    .collection('followers')
    .doc(FirebaseAuth.instance.currentUser!.uid).get().then((document) {
       if (!document.exists) {
        setState(() {
          isfollowing = false;
        });
      } else {
        setState(() {
          isfollowing = true;
        });
      }
    });


    setState(() {
      isdata = true;
    });
    
  }

  editprofile(BuildContext context) {
   return showDialog(context: context, builder: (context) {
    return Dialog(
        child: Container(
          height: 250, 
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Edit profile"),
                SizedBox(height: 20,),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                      controller: usernamecontroller,
                      decoration: InputDecoration(
                        hintText: "Give new username",
                      ),
                    ),
                ),
                 SizedBox(
                    height: 20,
                  ),
                 InkWell(
                  onTap: (){
                    usercollections
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .update({'username':usernamecontroller.text});

                    setState(() {
                      username = usernamecontroller.text;
                    });
                    usernamecontroller.clear();
                    Navigator.pop(context);
                    
                    

                  },
                   child: Container(
                    width: MediaQuery.of(context).size.width/2,
                    height: 50,
                    color: Colors.pink,
                    child: Center(child: Text("Update now")),
                   ),
                 ) 

              ],
          ),
        ),
    );
   });


}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:!isdata ? Center(child: CircularProgressIndicator(),)
      :SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(top: 50.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 64,
                child: Icon(Icons.person),
              ),
              SizedBox(height: 20),
              Text("$username"),
              SizedBox(height: 20,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "${following.toString()}",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "${followers.toString()}",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "$likes",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
              SizedBox(height: 7,),
              Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Following",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "Fans",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "Hearts",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
             SizedBox( height: 30),
             onlineuser == widget.uid ? InkWell(
              onTap: () => editprofile(context),
               child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 40,
                color: Colors.pink,
                child: Center(
                  child: Text(
                    "Edit profile",
                  ),
                ),
               ),
             ):InkWell(
               onTap: () => followuser(),
               child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 40,
                color: Colors.pink,
                child: Center(
                  child: Text(
                    isfollowing ? "Unfollow" : "Follow",
                  ),
                ),
               ),
             ),
            SizedBox(height: 20),
            Text(
                "My Videos",
            ),
            SizedBox( height: 10,),
            FutureBuilder(
              future: myvideos, 
              builder: (context, AsyncSnapshot snapshot){
              if(!snapshot.hasData){
                  return Center(
                            child: CircularProgressIndicator(),
                          );
              }else{
                return GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, 
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 5), 
                itemBuilder: (BuildContext context, int index){
                  DocumentSnapshot video = snapshot.data.docs[index];
                  return Container(
                    child: Image(image: NetworkImage(
                      "${video.get("previewimage")}"
                    ),
                    fit: BoxFit.cover,
                    ),
                  );
  
                }
                
                );
              }
            },)


                
            ]
        ),
        ),
        ) ,
    );
  }
}

