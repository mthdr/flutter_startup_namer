import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

Comparator <Tuple2 <WordPair, bool>> savedWordPairComparator = (a, b) {
  return a.item1.toString().compareTo(b.item1.toString());
};

class SavedWords extends StatefulWidget {

  //final Set <Tuple2 <WordPair, bool>> _words;
  final List <Tuple2<WordPair, bool>> _words;

  SavedWords (this._words) {
    //this._words = words;
  }

  @override
  SavedWordsState createState() {
    return SavedWordsState(this._words);
  }

}

class SavedWordsState extends State <SavedWords>{
  final _biggerFont = const TextStyle(fontSize: 18.0);

  final List <Tuple2 <WordPair, bool>> _words;

  SavedWordsState (this._words) {

  }

  Widget _buildRow (Tuple2 <WordPair, bool> pair) {
    final bool saved = pair.item2;

    return ListTile (

      title: Text (
        pair.item1.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon (
        saved ? Icons.favorite : Icons.favorite_border,
        color: saved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          Tuple2 <WordPair, bool> togglePair = Tuple2 (pair.item1, !pair.item2);
          this._words.remove(pair);
          this._words.add(togglePair);
          this._words.sort(savedWordPairComparator);
        });
      }
    );
  }

  Widget _buildSaved() {
    return ListView.builder (
      itemCount: (this._words.length * 2) - (this._words.length > 1 ? 1 : 0), // divider, but not after the last
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) {
          return Divider();
        }

        final index = i ~/ 2;
        return _buildRow(this._words.toList()[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSaved();
  }

}