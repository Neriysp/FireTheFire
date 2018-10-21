import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'dart:io';
import './screens/alarmButon.dart';
import './screens/locationSelection.dart';
import './screens/alarmButon.dart';
import 'package:map_view/map_view.dart';
import './screens/alertValidation.dart';
import './screens/auth.dart';


const API_KEY = "AIzaSyCASHtcPBdRd4tXej_Ld3h7gCOaoDtEpRE";



void main(){
  MapView.setApiKey(API_KEY);
  runApp(new MyApp());
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: new MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  FirebaseMessaging _fm = new FirebaseMessaging();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");
  final TextEditingController _nameController= new TextEditingController();
  final TextEditingController _passwordController=new TextEditingController();

  String defaultText="";
  String usernameFieldTooltip="Name";
  String emailFieldTooltip="Name";
  String passwordFieldTooltip="Password";
  String token_;
  @override
  void initState(){
    super.initState();
    print("here");
    _fm.configure(
      onMessage: (Map<String, dynamic> message){
        Navigator.push(navigatorKey.currentContext, MaterialPageRoute(builder : (context) => new AlarmButton()));
      },
      onResume: (Map<String, dynamic> message){
        Navigator.push(navigatorKey.currentContext, MaterialPageRoute(builder : (context) => new AlarmButton()));
      },
      onLaunch: (Map<String, dynamic> message){
        Navigator.push(context, MaterialPageRoute(builder : (context) => new AlarmButton()));
      }
    );
    _fm.getToken().then((token){
      token_=token;
    });
    
  }

  void _register () async{
    
     if(_nameController.text.isEmpty){
   
   setState(() {
           emailFieldTooltip="This field can't be empty";
        });
          return;
    }
    if(_passwordController.text.isEmpty){
     
   setState(() {
           passwordFieldTooltip="This field can't be empty";
        });
          return;
    }

    
    var longtitude="123.5";
    var latitude="123.5";

    var result= await register(_nameController.text,_passwordController.text,token_,longtitude,latitude);

    if(result!=null){
     Navigator.of(context).push(
      new MaterialPageRoute<Map>(builder: (BuildContext context){
        return new AlarmButton();
      }));
    }
 }
 
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      navigatorKey: navigatorKey,
      home: new Scaffold(
      appBar: new AppBar(
        title: new Text("Fire the Fire"),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        alignment:  Alignment.topCenter,
        child:  ListView(
          children: <Widget>[
            //image profile
             
             Container(
              color: Colors.white,
              child:  Column(
                children: <Widget>[
                Image.asset(
                      'assets/logo.png',
                    ),
                    TextField(
                    controller: _nameController,
                    decoration:  InputDecoration(
                      hintText: "Name",
                      icon:  Icon(Icons.person_outline)
                    ),
                  ),
                   TextField(
                    controller: _passwordController,
                    decoration:  InputDecoration(
                        hintText: passwordFieldTooltip,
                        icon:  Icon(Icons.lock)
                    ),
                    obscureText: true,
                  ),
                   TextField(
                    controller: null,
                    decoration:  InputDecoration(
                      hintText: "Nationality",
                      icon:  Icon(Icons.explore)
                    ),
                  ),
                   Container(
                    padding: EdgeInsets.only(top: 20.0),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                         FlatButton(onPressed: _register,
                          color: Theme.of(context).primaryColor,
                          child:  Text("Register",
                              style: TextStyle(fontSize:19.0)
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            ],
          ),
      )
    )
    );
  }
}
