import 'package:flutter/material.dart';
import 'package:learneur/components/search.dart';

PreferredSizeWidget appBarMain(BuildContext context) {
  return AppBar(title: Image.asset('images/appbar.png',height: 25,),
          centerTitle: true,
          backgroundColor: Colors.orange,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search),onPressed: (){
              showSearch(context: context, delegate: Search());
            })
          ],
          elevation: 6,
  );
}
