import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(new RealWorldApp());

class RealWorldApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RealWorldState();
  }
}

class RealWorldState extends State<RealWorldApp> {
  var _isLoading = false;
  var states;

  _fetchData() async {
    //print("geting data");

    final url = "https://api.covid19india.org/v2/state_district_wise.json";
    final response = await http.get(url);

    if (response.statusCode == 200) {
      //print(response.body);

      final data = json.decode(response.body);
      final districtJson = data[0]["districtData"];

      setState(() {
        //print("api call ended");
        _isLoading = false;
        this.states = districtJson;
      });
    } else {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: new AppBar(
          title: Text(
            'Covid19 In Kerala',
            style: TextStyle(fontSize: 25.0),
          ),
          backgroundColor: Colors.teal.shade800,
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.refresh),
              onPressed: () {
                //print('reloading');
                setState(() {
                  _isLoading = true;
                });
                _fetchData();
              },
            )
          ],
        ),
        body: new Center(
          child: _isLoading
              ? new CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                )
              : new ListView.builder(
                  itemCount: this.states != null ? this.states.length : 0,
                  itemBuilder: (context, i) {
                    final state = this.states[i];
                    return new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 15.0),
                          child: ListTile(
                            title: Text(
                              state["district"],
                              style: TextStyle(
                                fontFamily: "BalooBhaina2",
                                fontSize: 20.0,
                              ),
                            ),
                            trailing: Text(
                              state["confirmed"].toString(),
                              style: TextStyle(
                                fontFamily: "BalooBhaina2",
                                color: Colors.red.shade800,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }
}
