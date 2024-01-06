import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
/*
This database posts created by the user in the app.
It is stored in a collection called "posts" in Firebase.

Each post contains:
- a message
- email of user
- timestamp
*/

class FirestoreDatabase {
  // current user
  User? user = FirebaseAuth.instance.currentUser;

  // get collection of posts from firebase
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('posts');

  // post a message
  Future<void> addPost(String message) {
    return posts.add({
      'UserEmail': user!.email,
      'Message': message,
      'Timestamp': Timestamp.now(),
    });
  }

  // read message from firebase
  Stream<QuerySnapshot> getPostsStream() {
    final postsStream = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('Timestamp', descending: true)
        .snapshots();

    return postsStream;
  }
}
