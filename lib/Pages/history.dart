import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:translator/Models/history.dart';
import 'package:translator/Services/Db.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("History"),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: DbService().translateHistory(),
          builder: (context, AsyncSnapshot<List<History>> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data!
                    .map((e) => Card(
                        margin: EdgeInsets.all(4),
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Input: ${e.input}"),
                                  Text("Output: ${e.output}")
                                ]))))
                    .toList(),
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text('Loading'),
              ],
            );
          },
        ));
  }
}
