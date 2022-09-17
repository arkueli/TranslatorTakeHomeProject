import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator/Pages/translate.dart';
import 'package:translator/Services/Db.dart';
import 'package:translator/Services/translate.dart';

void main() {
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TranslateService>(
          create: (_) => TranslateService(),
        ),
        ChangeNotifierProvider(create: (_) => DbService())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TranslateHome(),
      ),
    );
  }
}
