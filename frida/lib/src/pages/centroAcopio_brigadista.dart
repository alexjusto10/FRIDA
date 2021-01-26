import 'dart:developer';
import 'dart:io';
import 'package:FRIDA/models/articulos_existencia_model.dart';
import 'package:FRIDA/models/articulos_model.dart';
import 'package:FRIDA/models/centro_acopio_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place/search_map_place.dart';
import 'dart:convert' as convert;

class CentroAcopioBrigadista extends StatefulWidget {
  @override
  _CentroAcopioBrigadistaState createState() => _CentroAcopioBrigadistaState();
}

class _CentroAcopioBrigadistaState extends State<CentroAcopioBrigadista> {
  Geolocation _geolocalizacion;
  CameraPosition _initialPosition =
      CameraPosition(target: LatLng(99.0, 99.0), zoom: 15.0);
  Position _localidad;
  GoogleMapController _controller;
  LatLng _lugarMarcador;
  List<CentroAcopioModel> _centroAcopioModel;
  List<ArticulosExistenciaModel> _articulosExistenciaModel;
  List<ArticulosModel> _articulosModel;
  final Set<Marker> _markers = Set();
  String _calleNumeroCentro = null,
      _colonia,
      _cp,
      _alcaldiaMunicipio,
      _estado,
      _idCentroAcopio,
      _nombreArticulo,
      _existenciaArticulo,
      _cantReqArticulo,
      _actualizacionCampo;
  String _nuevoCalleNumeroCentro,
      _nuevoColonia,
      _nuevoCp,
      _nuevoAlcaldiaMunicipio,
      _nuevoEstado,
      _nuevoIdCentroAcopio,
      _nuevoLat,
      _nuevoLng;

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
        title: Text('Centro de acopio'),
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
                      'Selecciona un centro o crea uno introduciendo la dirección',
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                    child: SearchMapPlaceWidget(
                      strictBounds: true,
                      language: 'spanish',
                      apiKey: 'AIzaSyAiLownwA4ulwVdglsmEve2TGdAvdZAbt0',
                      placeholder:
                          'Introducir la dirección donde se encuentra el daño.',
                      hasClearButton: true,
                      placeType: PlaceType.address,
                      onSelected: (Place lugar) async {
                        _geolocalizacion = await lugar.geolocation;
                        _controller.animateCamera(CameraUpdate.newLatLng(
                            _geolocalizacion.coordinates));
                        _controller.animateCamera(CameraUpdate.newLatLngBounds(
                            _geolocalizacion.bounds, 0));
                        _lugarMarcador = _geolocalizacion.coordinates;
                        _actualizarMapa();
                      },
                    ),
                  ),
                  _mapas(),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.transparent,
                    ),
                    child: ButtonTheme(
                      height: 45.0,
                      child: RaisedButton(
                        elevation: 5.0,
                        child: Text(
                          'Crear centro de acopio',
                          style: TextStyle(fontSize: 17),
                        ),
                        color: Color(0xffffd54f),
                        textColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        onPressed: () {
                          _obtenerDireccionConLatLng(
                                  _geolocalizacion.coordinates)
                              .then((valor) {
                            _nuevoCentroAcopio().then((valor) {
                              Marker marker = _markers.firstWhere(
                                  (marker) => marker.markerId.value == "nuevo",
                                  orElse: () => null);
                              setState(() {
                                _markers.remove(marker);
                                _recuperarCentrosDeAcopio().then((valor) {
                                  _colocarCentros();
                                  _obtenerArticulos();
                                });
                              });
                            });
                          });
                        },
                      ),
                    ),
                  )
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
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Artículo'),
                                  Text('Existencia'),
                                  Text('Cantidad requerida'),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height -
                                              800,
                                      child: ListView.builder(
                                        itemCount:
                                            _articulosExistenciaModel.length,
                                        itemBuilder: (context, index) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: Text(
                                                  _articulosModel[
                                                          _articulosExistenciaModel[
                                                                      index]
                                                                  .idArticulo -
                                                              1]
                                                      .nombre,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                      _articulosExistenciaModel[
                                                              index]
                                                          .existencia
                                                          .toString()),
                                                  IconButton(
                                                    icon: Icon(Icons.edit),
                                                    onPressed: () {
                                                      _dialogActualizarArticulo(
                                                          context,
                                                          'existencia',
                                                          _articulosExistenciaModel[
                                                                  index]
                                                              .idExistenciaArticuloCentro);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                      _articulosExistenciaModel[
                                                              index]
                                                          .cantReq
                                                          .toString()),
                                                  IconButton(
                                                    icon: Icon(Icons.edit),
                                                    onPressed: () {
                                                      _dialogActualizarArticulo(
                                                          context,
                                                          'cantidad',
                                                          _articulosExistenciaModel[
                                                                  index]
                                                              .idExistenciaArticuloCentro);
                                                    },
                                                  )
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Añadir nuevo artículo',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add_box),
                                    onPressed: () {
                                      _dialogNuevoArticulo(context);
                                    },
                                  ),
                                ],
                              )
                            ],
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

  Future<bool> _nuevoCentroAcopio() async {
    var url = 'http://13.84.215.39:8080/crear/centro';
    var response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: convert.jsonEncode(
          {
            "nombre": "Centro " + _nuevoColonia,
            "calle_numero": _nuevoCalleNumeroCentro,
            "colonia": _nuevoColonia,
            "cp": _nuevoCp,
            "alcaldia_municipio": _nuevoAlcaldiaMunicipio,
            "estado": _nuevoEstado,
            "lat": _nuevoLat,
            "lng": _nuevoLng,
            "id_sismo": "1",
          },
        ));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _obtenerDireccionConLatLng(LatLng _localizacion) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _localizacion.latitude, _localizacion.longitude);
      Placemark _direccion = placemarks[0];
      log(_direccion.toString());
      _nuevoCalleNumeroCentro = _direccion.street;
      _nuevoColonia = _direccion.subLocality;
      _nuevoCp = _direccion.postalCode;
      _nuevoAlcaldiaMunicipio = _direccion.locality;
      _nuevoEstado = _direccion.administrativeArea;
      _nuevoLat = _localizacion.latitude.toString();
      _nuevoLng = _localizacion.longitude.toString();
      return true;
    } catch (e) {
      print(e);
    }
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
          height: 250.0,
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

  _actualizarMapa() {
    setState(() {
      _markers.add(
        Marker(
          draggable: true,
          markerId: MarkerId("nuevo"),
          position: _lugarMarcador,
          onDragEnd: ((newPosition) {
            _lugarMarcador = newPosition;
          }),
        ),
      );
    });
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

  _dialogNuevoArticulo(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text('Agregar artículo'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        hintText: 'Introduce el nombre del artículo a añadir',
                        labelText: 'Nombre del artículo',
                        suffixIcon: Icon(Icons.font_download)),
                    onChanged: (valor) {
                      _nombreArticulo = valor;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        hintText: 'Introduce la cantidad actual',
                        labelText: 'Cantidad actual',
                        suffixIcon: Icon(Icons.check)),
                    onChanged: (valor) {
                      _existenciaArticulo = valor;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        hintText: 'Introduce la cantidad necesaria',
                        labelText: 'Cantidad necesaria',
                        suffixIcon: Icon(Icons.priority_high)),
                    onChanged: (valor) {
                      _cantReqArticulo = valor;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ButtonTheme(
                height: 45.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Color(0xffd8a500),
                  child: Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              ButtonTheme(
                  height: 45.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Color(0xffffd54f),
                    child: Text('Confirmar'),
                    onPressed: () {
                      _anadirNuevoArticulo().then((valor) {
                        if (valor) {
                          _showToast('Articulo añadido correctamente');
                          _obtenerArticulos().then((articulos) {
                            _recuperarArticulosCentro().then((valor) {
                              setState(() {});
                            });
                          });
                        } else {
                          _showToast('Articulo ya existente');
                        }
                        Navigator.of(context).pop();
                      });
                    },
                  )),
            ],
          );
        });
  }

  _dialogActualizarArticulo(
      BuildContext context, String campo, int idArticulo) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text('Actualizar ' + campo),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      hintText: 'Introduce la nueva cantidad',
                      labelText: 'Nueva cantidad',
                    ),
                    onChanged: (valor) {
                      _actualizacionCampo = valor;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ButtonTheme(
                height: 45.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Color(0xffd8a500),
                  child: Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              ButtonTheme(
                  height: 45.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Color(0xffffd54f),
                    child: Text('Confirmar'),
                    onPressed: () {
                      _actualizarArticulo(campo, idArticulo).then((valor) {
                        if (valor) {
                          _showToast('Articulo actualizado');
                          _obtenerArticulos().then((articulos) {
                            _recuperarArticulosCentro().then((valor) {
                              setState(() {});
                            });
                          });
                        }
                        Navigator.of(context).pop();
                      });
                    },
                  )),
            ],
          );
        });
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

  Future<bool> _anadirNuevoArticulo() async {
    var url = 'http://13.84.215.39:8080/crear/articuloExistencia';
    var response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: convert.jsonEncode(
          {
            "nombre": _nombreArticulo,
            "existencia": _existenciaArticulo,
            "cant_req": _cantReqArticulo,
            "id_centro_acopio": _idCentroAcopio
          },
        ));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _actualizarArticulo(String campo, int idArticulo) async {
    if (campo == 'existencia') {
      _existenciaArticulo = _actualizacionCampo;
      _cantReqArticulo =
          _articulosExistenciaModel[idArticulo - 1].cantReq.toString();
    } else {
      _cantReqArticulo = _actualizacionCampo;
      _existenciaArticulo =
          _articulosExistenciaModel[idArticulo - 1].existencia.toString();
    }
    log(idArticulo.toString() +
        _existenciaArticulo +
        _cantReqArticulo +
        _idCentroAcopio);
    var url = 'http://13.84.215.39:8080/actualizar/existencia-articulo/' +
        _idCentroAcopio;
    var response = await http.put(url,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: convert.jsonEncode(
          {
            "idArticulo": idArticulo,
            "existencia": _existenciaArticulo,
            "urgencia": "1",
            "cant_req": _cantReqArticulo,
            "idCentro": _idCentroAcopio
          },
        ));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
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

  void _showToast(String mensaje) {
    Fluttertoast.showToast(
        msg: mensaje,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }
}
