
import 'package:flutter/material.dart';
import 'package:photo_bay/api_key.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FirstPage(),
  ));
}

class FirstPage extends StatelessWidget {
  final _CategoryNameController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: Colors.white,
        child: Center(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(30.0),
              ),
              Image.asset(
                'images/photobay.png',
                width: 200.0,
                height: 200.0,
              ),
              ListTile(
                title: TextFormField(
                  controller: _CategoryNameController,
                  decoration: InputDecoration(
                    labelText: 'Enter a Category',
                    hintText: 'Search Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
              ListTile(
                title: Material(
                  color: Colors.lightBlue,
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(25.0),
                  child: MaterialButton(
                    height: 47.0,
                    onPressed: () => {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return SecondPage(category: _CategoryNameController.text,);
                      }))
                    },
                    child: Text(
                      'Search',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text('By FLUCTRON',
                    style: TextStyle(
                      color:Colors.grey,
                      fontSize: 16.0,
                    ),
                  ),
                ]
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class SecondPage extends StatefulWidget {
 final String category;

  SecondPage({this.category});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blue,
        title: Text('Photo Bay',style:TextStyle(
          color:Colors.white,
        )),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getPics(widget.category),
        builder: (context,snapShot){
            Map data = snapShot.data;
            if(snapShot.hasError){
              print(snapShot.error);
              return Text('Failed to load Images!!',style: TextStyle(color:Colors.red,fontSize:20.0),);
            }else if(snapShot.hasData){
              return Center(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context,index){
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(5.0),),
                          Container(
                            child: InkWell(
                              onTap:(){},
                              child: Image.network('${data['hits'][index]['largeImageURL']}'),
                            ),
                          )
                      ],
                    );
                  },
                  ),
                );
            }else if(!snapShot.hasData){
              return Center(child: CircularProgressIndicator(),);
            }
        },
        ),
    );
  }
}

Future<Map> getPics(String category) async{
  String URL = "https://pixabay.com/api/?key=$key&q=$category&image_type=photo&pretty=true";
  http.Response response = await http.get(URL);
  return json.decode(response.body);
}