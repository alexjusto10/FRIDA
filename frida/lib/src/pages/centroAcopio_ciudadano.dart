import 'dart:developer';
import 'dart:io';

import 'package:FRIDA/models/articulos_existencia_model.dart';
import 'package:FRIDA/models/articulos_model.dart';
import 'package:FRIDA/models/centro_acopio_model.dart';
import 'package:android_intent/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:http/http.dart' as http;

class CentroAcopioCiudadano extends StatefulWidget {
  @override
  _CentroAcopioCiudadanoState createState() => _CentroAcopioCiudadanoState();
}

class _CentroAcopioCiudadanoState extends State<CentroAcopioCiudadano> {
  String _idCentroAcopio,
      _calleNumeroCentro = null,
      _colonia,
      _cp,
      _alcaldiaMunicipio,
      _estado;
  List<ArticulosExistenciaModel> _articulosExistenciaModel;
  List<CentroAcopioModel> _centroAcopioModel;
  List<ArticulosModel> _articulosModel;
  Position _localidad;
  LatLng _lugarMarcador;
  Geolocation _geolocalizacion;

  @override
  void initState() {
    super.initState();
    _obtenerPosicionActual();
    _recuperarCentrosDeAcopio().then((valor) {
      _colocarCentros();
      _obtenerArticulos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Centros de acopio'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 5.0,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                    child: Text(
                      'Mapa de centros de acopio cercanos',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                    child: Text(
                      'Selecciona el marcador en el mapa para desplegar la información del centro de acopio',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
                    child: SearchMapPlaceWidget(
                      strictBounds: true,
                      language: 'spanish',
                      apiKey: 'AIzaSyAiLownwA4ulwVdglsmEve2TGdAvdZAbt0',
                      placeholder: 'Introducir tu localización.',
                      hasClearButton: true,
                      placeType: PlaceType.address,
                      onSelected: (Place lugar) async {
                        _geolocalizacion = await lugar.geolocation;
                        _controller.animateCamera(CameraUpdate.newLatLng(
                            _geolocalizacion.coordinates));
                        _controller.animateCamera(CameraUpdate.newLatLngBounds(
                            _geolocalizacion.bounds, 0));
                        _lugarMarcador = _geolocalizacion.coordinates;
                      },
                    ),
                  ),
                  _mapas(),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          _calleNumeroCentro != null
              ? Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 5.0,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            'Centro de acopio seleccionado:',
                            style: TextStyle(
                              fontSize: 17.0,
                            ),
                          ),
                          subtitle: Text(
                            _calleNumeroCentro +
                                ', ' +
                                _colonia +
                                ', CP ' +
                                _cp +
                                ', ' +
                                _alcaldiaMunicipio +
                                ', ' +
                                _estado,
                            style: TextStyle(
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: Card(
                            elevation: 5.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        'Artículos requeridos',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        'Cantidad solicitada',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height -
                                                850,
                                        child: ListView.builder(
                                          itemCount:
                                              _articulosExistenciaModel.length,
                                          itemBuilder: (context, index) {
                                            var _diferenciaExistencias =
                                                _articulosExistenciaModel[index]
                                                        .cantReq -
                                                    _articulosExistenciaModel[
                                                            index]
                                                        .existencia;
                                            return _diferenciaExistencias > 0
                                                ? Column(
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.all(
                                                            10.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                _articulosModel[
                                                                        _articulosExistenciaModel[index].idArticulo -
                                                                            1]
                                                                    .nombre,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ),
                                                            Text(
                                                              _diferenciaExistencias
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 16),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Divider()
                                                    ],
                                                  )
                                                : Container();
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: Card(
                            elevation: 5.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        'Artículos suficientes',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height -
                                                850,
                                        child: ListView.builder(
                                          itemCount:
                                              _articulosExistenciaModel.length,
                                          itemBuilder: (context, index) {
                                            var _diferenciaExistencias =
                                                _articulosExistenciaModel[index]
                                                        .cantReq -
                                                    _articulosExistenciaModel[
                                                            index]
                                                        .existencia;
                                            return _diferenciaExistencias < 0
                                                ? Column(
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.all(
                                                            10.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                _articulosModel[
                                                                        _articulosExistenciaModel[index].idArticulo -
                                                                            1]
                                                                    .nombre,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Divider()
                                                    ],
                                                  )
                                                : Container();
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }

  Widget _articulos(String _articulo, String _cantidad) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          child: Text(
            _articulo,
            style: TextStyle(fontSize: 16),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          child: Text(
            _cantidad,
            style: TextStyle(fontSize: 16),
          ),
        )
      ],
    );
  }

  CameraPosition _initialPosition =
      CameraPosition(target: LatLng(19.4516892, -99.1375919), zoom: 15.0);
  GoogleMapController _controller;
  final Set<Marker> _markers = Set();

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  Widget _mapas() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(
            10.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.transparent,
          ),
          height: 400.0,
          alignment: Alignment.center,
          child: ClipRRect(
            child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: <Widget>[
                    GoogleMap(
                      scrollGesturesEnabled: true,
                      zoomGesturesEnabled: true,
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: _initialPosition,
                      markers: _markers,
                      gestureRecognizers: Set()
                        ..add(Factory<PanGestureRecognizer>(
                            () => PanGestureRecognizer())),
                    ),
                  ],
                )),
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ],
    );
  }

  Future<bool> _recuperarArticulosCentro() async {
    var url = 'http://13.84.215.39:8080/listar/existencia-articulos/' +
        _idCentroAcopio;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      _articulosExistenciaModel =
          articulosExistenciaModelFromJson(response.body);
      log(_articulosExistenciaModel.length.toString());
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _recuperarCentrosDeAcopio() async {
    var url = 'http://13.84.215.39:8080/listar/centros';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      _centroAcopioModel = centroAcopioModelFromJson(response.body);
      return true;
    } else {
      return false;
    }
  }

  _colocarCentros() {
    setState(() {
      _centroAcopioModel.forEach((centro) {
        _markers.add(Marker(
          draggable: false,
          markerId: MarkerId(centro.idCentro.toString()),
          position: LatLng(double.parse(centro.lat), double.parse(centro.lng)),
          onTap: () {
            _colonia = centro.colonia;
            _cp = centro.cp;
            _alcaldiaMunicipio = centro.alcaldiaMunicipio;
            _estado = centro.estado;
            _idCentroAcopio = centro.idCentro.toString();
            _recuperarArticulosCentro().then((valor) {
              setState(() {
                _calleNumeroCentro = centro.calleNumero;
              });
            });
          },
        ));
      });
    });
  }

  Future<bool> _obtenerArticulos() async {
    var url = 'http://13.84.215.39:8080/listar/articulos';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      _articulosModel = articulosModelFromJson(response.body);
      return true;
    } else {
      log(response.statusCode.toString());
      return false;
    }
  }

  Future<bool> _obtenerPosicionActual() async {
    bool serviceEnabled;
    LocationPermission permission;
    String _error;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _error = 'Favor de activar los servicios de GPS.';
      _mostrarAlertaErrorLocalizacion(context, _error);
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      _error =
          'Los permisos de localización están como siempre desactivados.\n\n' +
              'Favor de activarlos para usar esta función';
      _mostrarAlertaErrorLocalizacion(context, _error);
      return false;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        _error = ('Los permisos de localización están como desactivados.');
        _mostrarAlertaErrorLocalizacion(context, _error);
        return false;
      }
    }
    _localidad = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    _controller.animateCamera(CameraUpdate.newLatLng(
        LatLng(_localidad.latitude, _localidad.longitude)));
    _lugarMarcador = LatLng(_localidad.latitude, _localidad.longitude);
    return true;
  }

  void _activarLocalizacion() async {
    if (Platform.isAndroid) {
      final AndroidIntent intent = AndroidIntent(
        action: 'android.settings.LOCATION_SOURCE_SETTINGS',
      );
      await intent.launch();
    }
  }

  void _mostrarAlertaErrorLocalizacion(BuildContext context, String error) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text('Error de localización'),
            content: Container(
              child: Text(
                error,
                style: TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            actions: <Widget>[
              ButtonTheme(
                  height: 45.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Color(0xffffd54f),
                    child: Text('Abrir configuración'),
                    onPressed: () {
                      _activarLocalizacion();
                      Navigator.of(context).pop();
                    },
                  )),
              ButtonTheme(
                  height: 45.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Color(0xffffd54f),
                    child: Text('Salir'),
                    onPressed: () => Navigator.of(context).pop(),
                  )),
            ],
          );
        });
  }
}
