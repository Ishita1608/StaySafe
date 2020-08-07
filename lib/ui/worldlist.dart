import 'dart:convert';
import 'package:covd19/ui/colors.dart';
import 'package:covd19/ui/sceensize.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:covd19/service/Apimode.dart';
import 'package:covd19/ui/countrydetail.dart';
import 'package:line_icons/line_icons.dart';

 class Worldlist extends StatefulWidget {
   @override
   _WorldlistState createState() => _WorldlistState();
 }
 
 class _WorldlistState extends State<Worldlist> {
  List<Corona> test, sample, _dat1;

  var jsondata;
  Details d, temp, a;
  String s = "https://api-corona.herokuapp.com/";
  Future<void> getData() async {
    final response = await http.get(s);
    jsondata = json.decode(response.body);
    d = Details.fromJson(jsondata);
    test = d.corona;
    setState(() {
      sample = test;
      _dat1 = sample;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      //backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
      //backgroundColor:Color(0xFFFF3B4254),
      backgroundColor: Bgcolor,
      body: d == null
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: new AlwaysStoppedAnimation<Color>(Fgcolor),
              ),
            )
          : RefreshIndicator(
              onRefresh: getData,
              child: Column(
                children: <Widget>[
                  Container(
                    width: screenAwareSize(300, context),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    height: screenAwareSize(40, context),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15.0),
                            bottomLeft: Radius.circular(15.0),
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0))),
                    child: TextField(
                      style: new TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search Here...',
                        hintStyle:
                            TextStyle(color: Colors.white, fontSize: 18.0),
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                      ),
                      onChanged: (text) {
                        setState(() {
                          _dat1 = sample
                              .where((r) => (r.country
                                  .toLowerCase()
                                  .contains(text.trim().toLowerCase())))
                              .toList();
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: _dat1
                          .map((pointer) => Padding(
                                padding: const EdgeInsets.all(3),
                                child: Container(
                                  padding: EdgeInsets.only(left: 7),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Coronad(
                                                    corona: pointer,
                                                  )));
                                    },
                                    child: Card(
                                      elevation: 5,
                                      margin: new EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 8.0),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: AssetImage(
                                              "assests/coronadetails.png"),
                                        ),
                                        title: Text(
                                          pointer.totalCases,
                                          style: TextStyle(
                                            color: Colors.cyan,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "Active Cases : " +
                                              pointer.activeCases.toString(),
                                          style: TextStyle(color: Colors.cyan),
                                        ),
                                        trailing: IconButton(
                                          icon: Icon(
                                            LineIcons.arrow_circle_o_right,
                                            color: Colors.black,
                                          ),
                                          iconSize: 31,
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Coronad(
                                                          corona: pointer,
                                                        )));
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
