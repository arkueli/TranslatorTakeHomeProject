import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator/Models/history.dart';
import 'package:translator/Models/language.dart';
import 'package:translator/Pages/history.dart';
import 'package:translator/Services/Db.dart';
import 'package:translator/Services/translate.dart';
import '../Widgets/arc.dart';

class TranslateHome extends StatefulWidget {
  const TranslateHome({super.key});

  @override
  State<TranslateHome> createState() => _TranslateHomeState();
}

class _TranslateHomeState extends State<TranslateHome> {
  @override
  void initState() {
    super.initState();
  }

  Language languageTo =
      Language.fromJson({"language": "auto", "name": "Auto Detect"});
  Language languageFrom =
      Language.fromJson({"language": "auto", "name": "Auto Detect"});
  String result = "Nothing here...";
  @override
  Widget build(BuildContext context) {
    TranslateService translateService = Provider.of(context);
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.grey.shade400,
        floatingActionButton: FloatingActionButton.small(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const HistoryPage()));
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.receipt)),
        body: LayoutBuilder(
            builder: (ctx, contraints) => Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: screenSize.height / 5,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: const Text(
                        'Translate',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                height: screenSize.height / 3,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: TextField(
                                    onSubmitted: (value) async {
                                      String translatedText =
                                          await translateService.translateText(
                                              value.trim(),
                                              languageTo.language.toString(),
                                              languageFrom.language);
                                      setState(() {
                                        result = translatedText;
                                      });
                                      DbService().invokeDb();

                                      DbService().insertHistory(History(
                                          input: value,
                                          inputLanguage:
                                              languageFrom.name.toString(),
                                          output: translatedText,
                                          outputLanguage:
                                              languageFrom.name.toString()));
                                    },
                                    maxLines: 20,
                                    decoration: InputDecoration.collapsed(
                                        hintText: "Input your text here")),
                              ),
                              Container(
                                  padding:
                                      const EdgeInsets.only(top: 34, left: 20),
                                  width: screenSize.width,
                                  height: screenSize.height / 3,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: SelectableText(result)),
                            ]),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      // top: screenSize.height / 6.8,
                      // left: screenSize.width / 2.9,
                      child: FutureBuilder(
                          future:
                              translateService.getListOfLanguagesSupported(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Language>> snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                padding: const EdgeInsets.all(6),
                                width: screenSize.width,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton2(
                                          hint: Text(
                                              languageFrom.language.toString()),
                                          items: snapshot.data!
                                              .map((eachCategory) =>
                                                  DropdownMenuItem(
                                                    value:
                                                        eachCategory.language,
                                                    child: Text(eachCategory
                                                        .name
                                                        .toString()),
                                                  ))
                                              .toList(),
                                          onChanged: (value) {
                                            var result = snapshot.data!.where(
                                                (element) =>
                                                    element.language == value);
                                            setState(() {
                                              languageFrom = result.first;
                                            });
                                          }),
                                    ),
                                    SizedBox(width: 6),
                                    const Text('To',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    SizedBox(width: 6),
                                    DropdownButtonHideUnderline(
                                        child: DropdownButton2(
                                            buttonWidth: 20,
                                            hint: Text(
                                                languageTo.language.toString()),
                                            items: snapshot.data!
                                                .map((eachCategory) =>
                                                    DropdownMenuItem(
                                                      value:
                                                          eachCategory.language,
                                                      child: Text(
                                                          eachCategory.name
                                                              .toString(),
                                                          style: TextStyle()),
                                                    ))
                                                .toList(),
                                            onChanged: (value) {
                                              Iterable<Language> result =
                                                  snapshot.data!.where(
                                                (element) =>
                                                    element.language == value,
                                              );
                                              setState(() {
                                                languageTo = result.first;
                                              });
                                            }))
                                  ],
                                ),
                              );
                            }
                            return const CircularProgressIndicator();
                          }),
                    ),
                  ],
                )));
  }
}
