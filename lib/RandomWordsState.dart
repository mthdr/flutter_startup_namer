import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/rendering.dart';
import 'package:tuple/tuple.dart';

import 'dart:developer' as developer;

import 'RandomWords.dart';
import 'SavedWords.dart';


class RandomWordsState extends State <RandomWords> {

  final _biggerFont = const TextStyle(fontSize: 18.0);
  final List<Tuple2 <WordPair, bool>> _saved = [];
  final List<WordPair>_suggestions = <WordPair>[];

  Widget _buildRow (WordPair pair) {
    final Tuple2 <WordPair, bool> tuple = Tuple2 (pair,  true);
    final bool alreadySaved = _saved.contains(tuple);

    return ListTile (
      title: Text (
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon (
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          alreadySaved ? _saved.remove (tuple) : _saved.add (tuple);
          _saved.sort(savedWordPairComparator);
        });
      },
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder (
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) {
          return Divider();
        }

        final index = i ~/ 2;
        if (index >= _suggestions.length){
          _suggestions.addAll (generateWordPairs().take(10));
        }
        return _buildRow (_suggestions[index]);
      },
    );
  }
  @override
  Widget build (BuildContext context) {

    return Scaffold (
      appBar: AppBar (
        title: Text ('Startup Name Generator'),
        actions: <Widget>[
          IconButton (
            icon: Icon(Icons.list),
            onPressed: _pushedSaved
          ),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  /// callback for Iconbutton
  Future<void> _pushedSaved() async {

    await Navigator.of(context).push (
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold (
            appBar: AppBar (
              title: Text ("Saved Suggestions"),
            ),
            body: SavedWords(_saved),
          );
        },
      ),
    );

    developer.log ('back from navigation');
    // remove any items from the saved list that are set false
    setState(() {
      for (var word in _saved.toList()) {
        if (word.item2 == false) {
          _saved.remove(word);
        }
      }
      _saved.sort(savedWordPairComparator);
    }); // force list refresh

  }
}

