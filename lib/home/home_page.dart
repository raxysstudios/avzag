import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'language_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String documentId = "languages";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('languages').get(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              "Ævzag",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {},
              ),
            ],
          ),
          body: snapshot.hasError
              ? Text("Something went wrong")
              : snapshot.connectionState == ConnectionState.done
                  ? Column(
                      children: [
                        for (final l in snapshot.data?.docs ?? [])
                          TextButton(
                            onPressed: () {},
                            child: LanguageCard(
                              l.data()["name"]["native"],
                              onTap: () {},
                            ),
                          ),
                      ],
                    )
                  : Text("loading"),
        );
      },
    );
  }
}
