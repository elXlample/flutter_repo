import 'package:flutter/material.dart';
import 'package:playground/playground/http.dart';

class httpUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return httpUIState();
  }
}

class httpUIState extends State<httpUI> {
  bool _httpPost = false;
  bool _httpGet = false;
  bool _httpUpdate = false;
  bool _httpPartUpdate = false;
  bool _httpDelete = false;
  int id = 101;
  late Future<Map<String, dynamic>> postList;
  ApiMethods _apiMethods = ApiMethods();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('http methods')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: FilledButton(
              onPressed: () async {
                setState(() {
                  _httpPost = !_httpPost;
                });
              },
              child: const Text('http post'),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 10,
            width: MediaQuery.of(context).size.width / 1.4,
            decoration: BoxDecoration(color: Colors.grey),
            child: _httpPost
                ? FutureBuilder(
                    future: _apiMethods.postData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final Map<String, dynamic> data = snapshot.data!;
                        id = data['id'];
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(data['title']),
                            Text(data['body']),
                            Text(data['userId'].toString()),
                            Text(data['id'].toString()),
                          ],
                        );
                      }
                      if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  )
                : Container(decoration: BoxDecoration(color: Colors.blueGrey)),
          ),
          OutlinedButton(
            onPressed: () {
              setState(() {
                _httpGet = !_httpGet;
              });
            },
            child: Text('http get'),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 10,
            width: MediaQuery.of(context).size.width / 1.4,
            decoration: BoxDecoration(color: Colors.grey),
            child: _httpGet
                ? FutureBuilder(
                    future: _apiMethods.getData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final List<dynamic> data = snapshot.data!;
                        final Map<String, dynamic> firstPost = data[0];

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[Text(firstPost['title'])],
                        );
                      }
                      if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  )
                : Container(
                    decoration: BoxDecoration(color: Colors.greenAccent),
                  ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: FilledButton.tonal(
              onPressed: () async {
                setState(() {
                  _httpUpdate = !_httpUpdate;
                });
              },
              child: const Text('http update'),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 10,
            width: MediaQuery.of(context).size.width / 1.4,
            decoration: BoxDecoration(color: Colors.grey),
            child: _httpUpdate
                ? FutureBuilder(
                    future: _apiMethods.fullUpdateData(id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final Map<String, dynamic> data = snapshot.data!;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(data['title']),
                            Text(data['body']),
                            Text(data['userId'].toString()),
                            Text(data['id'].toString()),
                          ],
                        );
                      }
                      if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  )
                : Container(decoration: BoxDecoration(color: Colors.blueGrey)),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: InkWell(
              onTap: () async {
                setState(() {
                  _httpPartUpdate = !_httpPartUpdate;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.blue],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "PartUpdate",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 12,
            width: MediaQuery.of(context).size.width / 1.4,
            decoration: BoxDecoration(color: Colors.grey),
            child: _httpPartUpdate
                ? FutureBuilder(
                    future: _apiMethods.partUpdateData(id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final Map<String, dynamic> data = snapshot.data!;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[Text(data['title'])],
                        );
                      }
                      if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 23, 46, 58),
                    ),
                  ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  _httpDelete = !_httpDelete;
                });
              },
              child: const Text('http delete'),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 15,
            width: MediaQuery.of(context).size.width / 1.4,
            decoration: BoxDecoration(color: Colors.grey),
            child: _httpDelete
                ? FutureBuilder(
                    future: _apiMethods.deleteData(id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data == true) {
                        return Text('deleted post with id :$id');
                      }
                      if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 88, 181, 228),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
