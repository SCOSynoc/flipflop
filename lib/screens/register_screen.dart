import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipflop/firebase/firestore_collections.dart';
import 'package:flipflop/screens/home_screen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
    late TextEditingController _emailController ;
    late TextEditingController _passwordContoller;
    late TextEditingController _nameController;
    late TextEditingController _confirmPasswordController;

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordContoller = TextEditingController(text: "");
    _nameController = TextEditingController(text: "");
    _confirmPasswordController = TextEditingController(text: "");
    
  }


  void registerUser() {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.createUserWithEmailAndPassword(email:_emailController.text, password: _passwordContoller.text)
    .then((signedUser) {
      usercollections.doc(signedUser.user!.uid).set({
            "fullname": _nameController.text,
            "email": _emailController.text,
            "password": _confirmPasswordController.text,
            "uuid": signedUser.user!.uid,      
      }
      );
    });


  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.cyan,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: Container(
            width: MediaQuery.of(context).size.width*0.90,
            
            child: Card(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(height: 20.0,),
                  Expanded(
                       flex: 1,
                       child: Padding(
                         padding: EdgeInsets.all(10.0) ,
                         child: TextField(
                           controller: _nameController ,
                           decoration: const InputDecoration(
                           prefixIcon: Icon(Icons.perm_identity),
                           border: OutlineInputBorder(
                             borderRadius: BorderRadius.all(Radius.circular(20.0))
                           ),
                           hintText: "Enter full name"
                         ),
                         ),
                       ),
                     ),
                      Expanded(
                       flex: 1,
                       child: Padding(
                         padding: EdgeInsets.all(10.0) ,
                         child: TextField(
                           controller: _emailController,
                           decoration: const InputDecoration(
                           prefixIcon: Icon(Icons.mail),
                           border: OutlineInputBorder(
                             borderRadius: BorderRadius.all(Radius.circular(20.0))
                           ),
                           hintText: "Enter mail"
                         ),
                         ),
                       ),
                     ),
                       Expanded(
                       flex: 1,
                       child: Padding(
                         padding: EdgeInsets.all(10.0),
                         child: TextField(
                          controller: _passwordContoller,
                          decoration: const InputDecoration(
                           prefixIcon: Icon(Icons.password),
                            border: OutlineInputBorder(
                             borderRadius: BorderRadius.all(Radius.circular(20.0))
                           ),
                           
                           hintText: "Enter password"
                         ),
                         ),
                       ),
                     ),
                    Expanded(
                       flex: 1,
                       child: Padding(
                         padding: EdgeInsets.all(10.0),
                         child: TextField(
                          controller: _confirmPasswordController,
                          decoration: const InputDecoration(
                           prefixIcon: Icon(Icons.password_outlined),
                            border: OutlineInputBorder(
                             borderRadius: BorderRadius.all(Radius.circular(20.0))
                           ),
                           hintText: "confirm password"
                         ),
                         ),
                       ),
                     ),
                     Center(
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [const Text("Already have an account?"), 
                         TextButton(
                           onPressed: (){
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                           },
                           child: const Text("Login"))
                           ],
                       ),
                     ),
                     Expanded(
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () { 
                              registerUser();
                           },
                          child: const Text("Register"),),
                        )
                      )
                   ],
                 ) 
            ),
          ),
        ),
      ),
    );
  }
}

