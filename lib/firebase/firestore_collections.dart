import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';



var usercollections = FirebaseFirestore.instance.collection("users");
var videocollections = FirebaseFirestore.instance.collection("videos");

final videosbucket = FirebaseStorage.instance.ref('videobucket');
final imagebucket = FirebaseStorage.instance.ref('imagebucket');

