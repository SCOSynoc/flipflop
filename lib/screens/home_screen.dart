import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipflop/screens/home.dart';
import 'package:flipflop/screens/register_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    late TextEditingController _emailController ;
    late TextEditingController _passwordContoller;

    @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text:"");
    _passwordContoller = TextEditingController(text:"");
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.65,
      height: MediaQuery.of(context).size.height*0.65,
      color: Colors.cyan,
      child: Card(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
               Padding(
                 padding: EdgeInsets.all(10.0),
                 child: TextField(
                   controller: _emailController,
                   decoration: const InputDecoration(
                   contentPadding: EdgeInsets.all(20.0),
                   prefixIcon: Icon(Icons.mail),
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.all(Radius.circular(20.0))
                   ),
                   hintText: "Enter mail"
                 ),
                 ),
               ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                   controller: _passwordContoller,
                   decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(20.0),
                    prefixIcon: Icon(Icons.password),
                     border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                    ),
                    
                    hintText: "Enter password"
                  ),
                  ),
                ),
               Center(
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [const Text("Dont have an account?"), 
                   TextButton(
                     onPressed: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                     },
                     child: const Text("Register")
                     )
                     ],
                 ),
               ),
               Center(
                 child: ElevatedButton(
                   onPressed: () {
                         try{
                           FirebaseAuth.instance.signInWithEmailAndPassword(
                           email: _emailController.text, password: _passwordContoller.text);
                           Navigator.push(context,MaterialPageRoute(builder: (context) => HomePage()));
                         }catch (e) {
                            SnackBar snackbar = SnackBar(content: Text("Try again, email or password"));
                            print("here ther was an error in $e");
                         }
                          
                     },
                   child: const Text("Login"),),
                 )
             ],
           ) 
      ),
    );
  }
}