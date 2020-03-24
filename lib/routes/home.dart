import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:list_app/main.dart';
import 'package:list_app/models/rayon.model.dart';
import 'package:list_app/widget/rayon-element.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  var dataUrl = "http://djemam.com/epsi/categories.json";

  Future<List> _getData(url) async {
    var data = await http.get(dataUrl);
    var jsondata = json.decode(utf8.decode(data.bodyBytes));
    var items = jsondata["items"];
    print(items[0]["title"]);

    List<RayonModel> rayons = [];
    
    for(var el in items){
      RayonModel rayon = RayonModel(el["id"], el["title"], el["products_url"]);
      print(rayon);
      rayons.add(rayon);
    }

    print(rayons);
    return rayons;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text("Rayons"),
        centerTitle: true,
        elevation: 10.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 10.0,
          left: 15.0,
          right: 15.0,
        ),
        child:  Container(
          child: FutureBuilder(
            future: _getData(dataUrl),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              final data = snapshot.data;
              if(snapshot.hasData){
                print(data.length);
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                    return RayonElement(data[index].id,data[index].title, data[index].productsUrl);
                  },
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        child: CircularProgressIndicator(
                          backgroundColor: secondaryColor,
                        ),
                        width: 60,
                        height: 60,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Chargement des rayons...'),
                      )
                    ],
                  )
                );
              }
            },
          ),
        )
      )
    );
  }
}
