import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flipflop/screens/pages/addvideo.dart';
import 'package:flipflop/screens/pages/messages.dart';
import 'package:flipflop/screens/pages/profile.dart';
import 'package:flipflop/screens/pages/search_page.dart';
import 'package:flipflop/screens/pages/video_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  var pageOptions = [  
    VideoPage(),
    SearchPage(),
    AddVideoPage(),
    Messages(),
    ProfilePage(uid: FirebaseAuth.instance.currentUser!.uid,)
  ];

  int page = 0;

  customIcon() {
     return Container(
      width: 45,
      height:27,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            width: 38,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 250, 45, 108),
              borderRadius: BorderRadius.circular(7)
              ),
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            width: 38,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 32, 211, 234),
              borderRadius: BorderRadius.circular(7)
              ),
          ),
          Center(
            child:Container(
              height: double.infinity,
              width: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7)
              ),
              child: Icon(Icons.add,size: 20,),
            ),
          ),

        
        ],
      ),
    
     );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageOptions[page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: page,
        onTap: (index) {
          setState(() {
            page = index;
          });
        },
        selectedItemColor: Colors.redAccent.shade200,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label:"Home"
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.search ,size: 30),
            label:"search"
            ),
           BottomNavigationBarItem(
            icon: customIcon(),
            label:''
            ),
           BottomNavigationBarItem(
            icon: Icon(Icons.message, size: 30),
            label:"messages"
            ),
           BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30),
            label:"profile"
            )  
        ]
        ),
    );
  }
}