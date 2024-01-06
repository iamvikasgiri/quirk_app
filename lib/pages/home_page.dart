import 'package:flutter/material.dart';
import 'package:quirk_app/components/my_drawer.dart';
import 'package:quirk_app/components/my_textfield.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // text controller
  final TextEditingController newPostController = TextEditingController();

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
            child: MyTextField(
                hintText: "Say something...",
                obscureText: false,
                controller: newPostController),
          )

          // posts
        ],
      ),
    );
  }
}
