import 'package:citybusters/models/cb_coordinate.dart';
import 'package:citybusters/models/cb_place.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:get/get.dart';
import 'package:mobileapp_utils/resources/party_size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  final LatLng? initPos;
  final List<CBPlace>? places;
  final bool showLines;
  final double zoom;

  final RxList<CBCoordinate>? prefCoord;

  const MapView({
    Key? key,
    this.initPos,
    this.places,
    this.showLines = true,
    this.prefCoord,
    this.zoom = 16,
  }) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late final CameraPosition _initialLocation;
  late GoogleMapController mapController;

  late Position _currentPosition;

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();

  Set<Marker> markers = {};

  late PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    if (widget.initPos == null) {
      _initialLocation = CameraPosition(
          target: LatLng(38.7202492, -9.1457535), zoom: widget.zoom, tilt: 20);
    } else {
      _initialLocation =
          CameraPosition(target: widget.initPos!, zoom: widget.zoom, tilt: 20);
    }

    _getCurrentLocation();

    if (widget.prefCoord != null) {
      widget.prefCoord!.listen((_v) {
        _createPolylines(prefCoord: _v);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.prefCoord != null) {
      _createPolylines(prefCoord: widget.prefCoord);
    } else {
      _createPolylines();
    }
  }

  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  _createPolylines({List<CBCoordinate>? prefCoord}) async {
    polylinePoints = PolylinePoints();
    final _wPoints = <PolylineWayPoint>[];

    late List<CBCoordinate> _coords;

    if (prefCoord != null) {
      _coords = prefCoord;
    } else {
      _coords = widget.places!.map((e) => e.coordinate).toList();
    }

    if (_coords.length > 2) {
      _wPoints.addAll(
        _coords.sublist(1, _coords.length - 1).map(
              (_p) => PolylineWayPoint(
                  location: '${_p.lat},${_p.lng}', stopOver: true),
            ),
      );
    }

    PointLatLng? _st;
    PointLatLng? _end;
    if (_coords.length >= 2 && prefCoord != null) {
      final _l = [_coords[_coords.length - 2], _coords[_coords.length - 1]];
      _st = PointLatLng(_l.first.lat, _l.first.lng);
      _end = PointLatLng(_l.last.lat, _l.last.lng);
    }

    PolylineResult result = _coords.length >= 2
        ? await polylinePoints.getRouteBetweenCoordinates(
            'AIzaSyCLrXNgR7jcJia3EpF0Mf76fWf3kHJ-NdQ',
            _st ?? PointLatLng(_coords.first.lat, _coords.first.lng),
            _end ?? PointLatLng(_coords.last.lat, _coords.last.lng),
            wayPoints: prefCoord != null ? [] : _wPoints,
            travelMode: TravelMode.walking,
          )
        : PolylineResult();

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    final icons = <BitmapDescriptor>[];
    for (int i = 0; i < _coords.length; i++) {
      final icon = await MarkerIcon.circleCanvasWithText(
        size: Size(80, 80),
        text: '${i + 1}',
        fontSize: 35,
        circleColor: Colors.orange,
        fontColor: Colors.white,
      );
      icons.add(icon);
    }

    final _markers = <Marker>[];
    for (int i = 0; i < _coords.length; i++) {
      final e = _coords[i];
      final _m = Marker(
        infoWindow: prefCoord != null
            ? InfoWindow.noText
            : InfoWindow(title: widget.places![i].name),
        markerId: prefCoord != null
            ? MarkerId(i.toString())
            : MarkerId(widget.places![i].id),
        position: LatLng(e.lat, e.lng),
        icon: icons[i],
      );
      _markers.add(_m);
    }

    setState(() {
      if (widget.showLines && result.points.isNotEmpty) {
        polylines.clear();

        PolylineId id = PolylineId('poly');
        Polyline polyline = Polyline(
          polylineId: id,
          color: Color.fromARGB(255, 45, 140, 172),
          points: polylineCoordinates,
          width: 3,
        );
        polylines[id] = polyline;
      }

      markers.clear();
      markers.addAll(_markers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: PSizeConfig.height(450),
      child: GoogleMap(
        markers: Set<Marker>.from(markers),
        initialCameraPosition: _initialLocation,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false,
        polylines: Set<Polyline>.of(polylines.values),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }
}
