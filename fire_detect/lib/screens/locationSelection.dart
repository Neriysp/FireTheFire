import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:location/location.dart' as cl;
import 'auth.dart';
import 'dart:convert';

const API_KEY = "AIzaSyCASHtcPBdRd4tXej_Ld3h7gCOaoDtEpRE";

class LocationSelection extends StatefulWidget{
  @override
  State createState() => new LocationSelectionState();
}

class LocationSelectionState extends State<LocationSelection>{
  MapView mapView = new MapView();
  var _provider = StaticMapProvider(API_KEY);
  CameraPosition cp;
  Uri staticMapUri;
  Map<String,double> currLoc;
  String latToSend;
  String lonToSend;

  @override
  initState(){
    super.initState();
    getLocation();
  }


  getLocation() async{
    cp = new CameraPosition(Locations.portland, 5.0);
    var loc = cl.Location();
    currLoc =  await loc.getLocation();
    staticMapUri = _provider.getStaticUri(new Location(currLoc['latitude'], currLoc['longitude']), 12,
        width: 400, height: 800, mapType: StaticMapViewType.roadmap);
    print(currLoc['latitude']);
    latToSend = currLoc['latitude'].toString();
    lonToSend = currLoc['longitude'].toString();
    setState(() {
          
    });
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      backgroundColor: Colors.redAccent,
      body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children : <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      child: Center(
                      child: Container(
                        child : new InkWell(
                          child: new Center(
                            child: staticMapUri == null ? new Text(""): Image.network(staticMapUri.toString()),
                          ),
                        onTap: (){
                          if(staticMapUri != null)
                            showMap();
                        },
                        )
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children : <Widget>[
                  Expanded(
                    child: Center(
                      child: Container(
                        child : InkWell(
                          child : Text("Send Location", style: TextStyle(
                            fontSize : 30.0,
                            fontWeight : FontWeight.bold,
                            color : Colors.white
                          ),),
                          onTap: (){
                            ajaxPost("", {"latitude":latToSend,"longitude":lonToSend});
                          }
                        )
                      ),
                    ),
                  )
                ]
              )
            ] 
          ),
      )
    );
  }

showMap() async {
  mapView.show(new MapOptions(
    mapViewType: MapViewType.normal,
            showUserLocation: true,
            showMyLocationButton: true,
            showCompassButton: true,
            initialCameraPosition: new CameraPosition(
                new Location(currLoc['latitude'], currLoc['longitude']), 15.0),
            hideToolbar: false,
            title: "Recently Visited"),
        toolbarActions: [new ToolbarAction("Close", 1)]
        );
    Marker markerMap = new Marker(
      "1",
      "Fire Location",
      currLoc['latitude'], currLoc['longitude'],
      draggable: true, //Allows the user to move the marker.
    );  

    mapView.onAnnotationDragEnd.listen((markerMap) {
      var marker = markerMap.keys.first;
      var location = markerMap[marker]; // The actual position of the marker after finishing the dragging.
      latToSend = currLoc['latitude'].toString();
      lonToSend = currLoc['longitude'].toString();
      print("Annotation ${marker.id} dragging ended ${location.latitude},${location.longitude}");
    });

  }


}
