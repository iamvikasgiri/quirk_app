import 'package:flutter/material.dart';
import 'package:quirk_app/components/my_drawer.dart';
import 'package:quirk_app/components/my_list_tile.dart';
import 'package:quirk_app/components/my_post_button.dart';
import 'package:quirk_app/components/my_textfield.dart';
import 'package:quirk_app/database/firestore.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // firestore database
  final FirestoreDatabase database = FirestoreDatabase();

  // text controller
  final TextEditingController newPostController = TextEditingController();

  // post message
  void postMessage() {
    // only post if there's something in the textfield
    if (newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      database.addPost(message);
    }

    // clear the textfield
    newPostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Q U I R K"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          // text field for users to type
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                // textfield
                Expanded(
                  child: MyTextField(
                    hintText: "Say something...",
                    obscureText: false,
                    controller: newPostController,
                  ),
                ),

                // post button
                PostButton(
                  onTap: postMessage,
                )
              ],
            ),
          ),

          // posts
          StreamBuilder(
            stream: database.getPostsStream(),
            builder: (context, snapshot) {
              // show loading circle while waiting for data
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // get posts from database
              final posts = snapshot.data!.docs;

              // no data
              if (snapshot.data == null || posts.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text("No Posts... Post Something!!"),
                  ),
                );
              }

              // return as listview
              return Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    // get each individual post
                    final post = posts[index];

                    // get data from post
                    String message = post["Message"];
                    String userEmail = post["UserEmail"];
                    // Timestamp timestamp = post["Timestamp"];

                    // convert timestamp to date
                    // DateTime date = timestamp.toDate();

                    // return as a list tile
                    return MyListTile(
                      title: message,
                      subTitle: userEmail,
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
