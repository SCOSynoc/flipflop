import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipflop/firebase/firestore_collections.dart';
import 'package:flipflop/screens/pages/profile.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({ Key? key }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  Future<QuerySnapshot>? searchResults;

  searchUser(String typedUser){
      var user = usercollections.where('fullname', isGreaterThanOrEqualTo: typedUser).get();
      setState(() {
        searchResults = user;
      });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffECE5DA),
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: TextField(
          decoration: InputDecoration(
            filled: true,
            hintText: "Search for flopers...."
          ),
          onChanged: searchUser,
        ),
      ),
      body: searchResults == null ? Center(
                child: Text(
                  "Search for flik tokers....",
                ),
              ): FutureBuilder(
                future: searchResults,
                builder: (BuildContext context, AsyncSnapshot snapshot){
                    if(!snapshot.hasData){
                      return Center(child: CircularProgressIndicator(),);
                    }else{
                      return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder:  (context, index) {
                          DocumentSnapshot user = snapshot.data.docs[index];
                        return InkWell(
                          onTap: () => ProfilePage(uid: user.get('uid')),
                          child: ListTile(
                            leading: Icon(Icons.search),
                            title: Text(user.get("fullname")),
                            trailing: CircleAvatar(
                              backgroundColor: Colors.white, child: Icon(Icons.person),
                            ),
                          ),
                        );
                      }
                      );
                    }
                }
                )
    );
  }
}