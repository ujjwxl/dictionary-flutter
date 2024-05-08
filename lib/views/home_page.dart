// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dict/models/dictionary_model.dart';
import 'package:dict/services/dictionary_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DictionaryModel dictionaryModel = DictionaryModel(
    word: "",
    phonetics: [],
    meanings: [],
    license: License(name: "license name", url: "license url"),
    sourceUrls: [],
  );

  bool isLoading = false;
  String noDataFound = "Search a word";

  DictionaryService dictionaryService = DictionaryService();

  searchContain(String word) async {
    setState(() {
      isLoading = true;
    });

    try {
      dictionaryModel = await dictionaryService.getMeaning(word);
      setState(() {});
    } catch (e) {
      // noDataFound = "Meaning can't be found";
      setState(() {
        noDataFound = "The meaning could not be found";
        dictionaryModel = DictionaryModel(
          word: "",
          phonetics: [],
          meanings: [],
          license: License(name: "license name", url: "license url"),
          sourceUrls: [],
        );
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Text(
            'DefiniFind',
            style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6C63FF)),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: SearchBar(
                hintText: 'Search the word here',
                onSubmitted: (value) {
                  searchContain(value);
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (isLoading)
              const LinearProgressIndicator()
            else if (dictionaryModel.meanings.isNotEmpty)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(dictionaryModel.word,
                        style: GoogleFonts.poppins(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            color: Colors.black)),
                    Row(
                      children: [
                        Icon(Icons.volume_up),
                        Text(
                          dictionaryModel.phonetics.isNotEmpty
                              ? dictionaryModel.phonetics[0].text ?? ""
                              : "",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                        child: ListView.builder(
                            itemCount: dictionaryModel.meanings.length,
                            itemBuilder: (context, index) {
                              return showMeaning(
                                  dictionaryModel.meanings[index]);
                            }))
                  ],
                ),
              )
            else
              Center(
                child: Text(
                  noDataFound,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
          ],
        ),
      ),
    );
  }

  showMeaning(Meaning meaning) {
    String definition = "";

    for (var element in meaning.definitions) {
      int index = meaning.definitions.indexOf(element);
      definition += "\n${index + 1}.${element.definition}\n";
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meaning.partOfSpeech,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.blue,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "Definitions : ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              ),
              Text(
                definition,
                style: TextStyle(fontSize: 16, height: 1),
              )
            ],
          ),
        ),
      ),
    );
  }
}
