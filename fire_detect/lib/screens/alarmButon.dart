import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:location/location.dart' as cl;
import 'locationSelection.dart';

class AlarmButton extends StatefulWidget{
  @override
  State createState() => new AlarmButtonState();
}

class AlarmButtonState extends State<AlarmButton>{
  String latToSend;
  String lonToSend;
  Map<String,double> currLoc;
  
  getLocation() async{
    var loc = cl.Location();
    currLoc =  await loc.getLocation();
    latToSend = currLoc['latitude'].toString();
    lonToSend = currLoc['longitude'].toString();
  }
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      backgroundColor: Colors.redAccent,
      body: Container(
          child : Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                  child: InkWell(
                  onTap : () async{
                  await getLocation();
                   var response= await ajaxPost("fire",
                   {
                      "longtitude":latToSend,
                      "latitude":lonToSend
                    });

                  },
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Center(
                        child: new Text("Alert", style: new TextStyle(
                          color : Colors.white,
                          fontSize : 50.0,
                          fontWeight : FontWeight.bold,
                          
                        ),),
                      )
                    ],
                  )
                ),
              ),
              Expanded(
                child: Container(
                color: Colors.red,          
                child: InkWell(
                    onTap : (){
                    Navigator.of(context).push(
                    new MaterialPageRoute<Map>(builder: (BuildContext context){
                      return new LocationSelection();
                    }));
                    },
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Center(
                          child: new Text("Report", style: new TextStyle(
                            color : Colors.white,
                            fontSize : 50.0,
                            fontWeight : FontWeight.bold,
                            
                          ),),
                        )
                      ],
                    )
                  ),
                ),
              )
            ],
          )
      )
    );
  }

}
