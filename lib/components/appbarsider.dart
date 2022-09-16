import 'package:flutter/material.dart';
import 'package:learneur/components/search.dart';

PreferredSizeWidget appBarsider(BuildContext context) {
  return AppBar(
    title: Image.asset('images/appbar.png',height: 25,),
    centerTitle: true,
    backgroundColor: Colors.orange,
    leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back)),
    actions: <Widget>[
      IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(context: context, delegate: Search());
          })
    ],
    elevation: 6,
  );
}