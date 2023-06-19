import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipflop/firebase/firestore_collections.dart';
import 'package:flutter/material.dart';


class CommentsPage extends StatefulWidget {
  final String id;

  CommentsPage({required this.id});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController commentcontroller = TextEditingController();
  late String uid;



  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
  }


  publishcomment()async {
    DocumentSnapshot userdoc = await usercollections.doc(uid).get();
    var alldocs = await videocollections.doc(widget.id).collection("comments").get();
    int length = alldocs.docs.length;
    videocollections
        .doc(widget.id)
        .collection('comments')
        .doc('Comment $length')
        .set({
          'username': userdoc.get('fullname'),
          'uid': uid,
          'comment': commentcontroller.text,
          'likes': [],
          'time': DateTime.now(),
          'id': 'Comment $length'
        });

        commentcontroller.clear();
        DocumentSnapshot doc =  await videocollections.doc(widget.id).get();
        videocollections
        .doc(widget.id)
        .update({'commentscount': doc.get('commentscount') + 1});


  }

  likeComment(String id) async{
        String uid = FirebaseAuth.instance.currentUser!.uid;
        DocumentSnapshot doc = await videocollections.doc(widget.id).collection("comments").doc(id).get();
       if(doc.get('likes').contains(uid)){
        videocollections.doc(widget.id).collection("comments").doc(id).update({
            "likes": FieldValue.arrayRemove([uid])
          });
       }else{
         videocollections.doc(widget.id).collection("comments").doc(id).update({
            "likes": FieldValue.arrayUnion([uid])
          });
       }


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
               Expanded(
                child: 
                StreamBuilder(
                  stream: videocollections.doc(widget.id).collection('comments').snapshots(),
                  builder: (context , AsyncSnapshot snapshot) {
                         if(!snapshot.hasData){
                          return CircularProgressIndicator();
                         }else{
                          return ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index)  {
                              DocumentSnapshot comment = snapshot.data.docs[index];
                               return ListTile(
                                leading: CircleAvatar(
                                  child: Icon(Icons.person),
                                  backgroundColor: Colors.white
                                  ),
                                title: Row(
                                  children: [
                                  Text('${comment.get('username')}'),
                                  SizedBox(width: 5.0),
                                  Text('${comment.get('comment')}')
                                ],),
                                subtitle: Row(children: [
                                  //Text("${comment.get('time')}"),
                                  SizedBox(width: 5.0),
                                  Text("${comment.get('likes').length} likes"),
                                ]),

                                trailing: InkWell(
                                  onTap: () => likeComment(comment.get('id')),
                                  child: comment.get('likes').contains(uid)? Icon(Icons.favorite,color: Colors.red):
                                  Icon(Icons.favorite_border_outlined),
                                ),  
                               );

                          });
                         }
                  },

                  )
                  ),
               Divider(),
               ListTile( 
                  title: TextFormField(
                  controller: commentcontroller,
                  decoration: const InputDecoration(
                    labelText: 'Comment',
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
                trailing: TextButton(
                  onPressed: () => publishcomment(),
                  child: const Text(
                    "Publish",
                  ),
                ),
                )
               

            ]
          ),
        ),
      ),
    );
  }
}


