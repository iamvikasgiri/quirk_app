import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  // current logged in user
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // feature to fetch user details
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.email)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          // loading...
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          //error
          else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }

          //data received
          else if (snapshot.hasData) {
            // extract data
            Map<String, dynamic>? user = snapshot.data!.data();

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // profile picture
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.all(25),
                    child: const Icon(
                      Icons.person,
                      size: 64,
                    ),
                  ),
                  //username
                  Text(user!['username']),

                  //email
                  Text(user['email']),
                ],
              ),
            );
          } else {
            return const Text("No Data");
          }
        },
      ),
    );
  }
}
