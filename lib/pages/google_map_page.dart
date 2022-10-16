import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:patient_app/location_service.dart';
import 'package:patient_app/constants//api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';



class GoogleMapPage extends StatefulWidget {
  @override
  State<GoogleMapPage> createState() => MapSampleState();
}

class MapSampleState extends State<GoogleMapPage> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _searchController=TextEditingController();

  Set<Marker> _markers=Set<Marker>();
  Set<Polygon> _polygons= Set<Polygon>();
  List<LatLng> polygonLatLngs=<LatLng>[];
  int _polygonIdCounter=1;


  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  void initState(){
    super.initState();
    _setMarker(LatLng(37.42796133580664, -122.085749655962));

  }
  _setMarker(LatLng point)
  {
    setState(() {
      _markers.add(
        Marker(
            markerId: MarkerId('marker'),
            position: point
        ),
      );
    });
  }
  _setPolygon()
  {
    final String polygonIdVal='polygon_$_polygonIdCounter';
    _polygonIdCounter++;
    _polygons.add(Polygon(polygonId: PolygonId(polygonIdVal),
      points:  polygonLatLngs,
       strokeWidth: 2,
      fillColor: Colors.transparent,

    ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('Request Ambulance'),),
      body: Column(
        children: [
          Row(children: [
            Expanded(child: TextFormField(
              controller: _searchController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(hintText: 'Search by Place Name'),
              onChanged: (value){
                print(value);
              },
            )),
            IconButton(onPressed: () async {
               var place=await LocationService().getPlace(_searchController.text);
               _goToPlace(place);
            },icon: Icon(Icons.search),),
          ],),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              markers: _markers,
              polygons: _polygons,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onTap: (point){
                setState(() {
                  polygonLatLngs.add(point);
                  _setPolygon();
                });
              },
            ),
          ),
        ],
      ),
       floatingActionButton: FloatingActionButton.extended(

         onPressed: () async {
           var place=await LocationService().getPlace(_searchController.text);
           _sendAlert(place);
         },
         label: Text('Send Alert'),
         icon: Icon(Icons.warning),
       ),
    );
  }


  Future<void> _goToPlace(Map<String,dynamic> place) async {
    final double lat=place['geometry']['location']['lat'];
    final double lng=place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat,lng),zoom: 12),
    ));
    _setMarker(LatLng(lat,lng));
  }
  Future<void> _sendAlert(Map<String,dynamic> place) async {
    final double lat=place['geometry']['location']['lat'];
    final double lng=place['geometry']['location']['lng'];
    try {

        final response = await http.post(
          Uri.parse(alert_api),
          body: jsonEncode({
            'user': 3750670034,
            'location': '$lat,$lng',
            'message' : "Hello Emergency need of an Ambulance"
          }),
          // Send authorization headers to the backend.
          headers: {

            HttpHeaders.authorizationHeader: token,
          },

        );
        var code=response.statusCode;
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body.toString());
          print(data);
        } else {
          print('API Failed due to error : $code');
        }


    }catch(e){
      print(e.toString());
    }
  }
}