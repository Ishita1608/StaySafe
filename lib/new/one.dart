import 'dart:convert';

import 'package:covd19/new/Tcases.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../charts/wave_progress.dart';
import '../ui/colors.dart';
import '../ui/sceensize.dart';



class One extends StatefulWidget {
  @override
  _OneState createState() => _OneState();
}

class _OneState extends State<One> {

  final String url = "https://corona.lmao.ninja/all";

  @override
  void initState() {
    super.initState();

    this.getJsonData();
  }

  Future <Tcases> getJsonData() async
  {
    var response = await http.get(
      Uri.encodeFull(url),

    );


    if (response.statusCode == 200) {
      final convertDataJson = jsonDecode(response.body);

      return Tcases.fromJson(convertDataJson);
    }
    else {
      throw Exception('Try to  Reload Page');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<Tcases>(
                future: getJsonData(),
                builder: (BuildContext context, SnapShot) {
                  if (SnapShot.hasData) {
                    final covid = SnapShot.data;
                    return Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              colorCard("Total Cases", covid.cases,
                                  context, Color(0xFF765d69)),
                              colorCard("Total Deaths", covid.deaths,
                                  context, Color(0xFFab6ca2)),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              colorCard("Total Recoverd", covid.recovered,
                                  context, Color(0xFF475c78)),
                              colorCard("Total updated", covid.updated,
                                  context, Color(0xFF475c78))
                            ],
                          ),


                        ]);
                  }
                  else if (SnapShot.hasError) {
                    return Text(SnapShot.error.toString());
                  }
                  return CircularProgressIndicator();
                }
            ),
          ],
        ),
      ),
    );
  }


  Widget colorCard(String text, String f, BuildContext context, Color color) {
    final _media = MediaQuery
        .of(context)
        .size;
    return Container(
      margin: EdgeInsets.only(top: 18, right: 12),
      padding: EdgeInsets.all(25),
      height: screenAwareSize(100, context),
      width: _media.width / 2 - 25,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "${f.toString()}",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}