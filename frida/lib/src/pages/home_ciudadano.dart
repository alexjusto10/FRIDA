import 'dart:developer';

import 'package:FRIDA/models/recomendacion_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sendsms/sendsms.dart';
import 'package:geolocator/geolocator.dart';
import 'package:android_intent/android_intent.dart';
import 'package:geocoding/geocoding.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tweet_webview/tweet_webview.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HomeCiudadano extends StatefulWidget {
  @override
  _HomeCiudadanoState createState() => _HomeCiudadanoState();
}

class _HomeCiudadanoState extends State<HomeCiudadano> {
  final String _recordarTodoBienPrefs = "recordarTodoBien",
      _recordarAuxilioPrefs = "recordarAuxilio",
      _recordarTelefono1 = "recordarTelefono1",
      _recordarTelefono2 = "recordarTelefono2",
      _recordarTelefono3 = "recordarTelefono3";
  String _todoBien = '', _auxilio = '', _consejo;
  List<String> _numerosContactos;
  int _idRecomendacion = 1;
  List<RecomendacionModel> _recomendacionModel;

  @override
  void initState() {
    super.initState();
    _numerosContactos = List<String>();
    _recuperarContactos();
    _obtenerRecomendaciones().then((valor) {
      _obtenerRecomendacion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Inicio'),
          leading: IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, 'perfil');
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.help),
              onPressed: () {
                _mostrarAlertaTips(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(context, 'mensaje');
              },
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(
                    right: 15.0, left: 15.0, top: 20.0, bottom: 5.0),
                child: Container(
                    height: 600,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TweetWebView.tweetUrl(
                            "https://twitter.com/SismologicoMX"),
                      ),
                    ))),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'notificar');
                    },
                    child: Container(
                      height: 130.0,
                      width: (MediaQuery.of(context).size.width - 40.0) / 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        shape: BoxShape.rectangle,
                        color: Color(0xffd8a500),
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(20.0),
                        child: Center(
                          child: ListBody(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.business,
                                    size: 60.0,
                                    color: Colors.white,
                                  ),
                                  Icon(
                                    Icons.priority_high,
                                    size: 35.0,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                              Center(
                                child: Text(
                                  'Notificar daño',
                                  style: TextStyle(
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'centro_acopio_ciudadano');
                    },
                    child: Container(
                      height: 130.0,
                      width: (MediaQuery.of(context).size.width - 40.0) / 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        shape: BoxShape.rectangle,
                        color: Color(0xffd8a500),
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(20.0),
                        child: Center(
                          child: ListBody(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    size: 60.0,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              Center(
                                child: Text(
                                  'Centros de acopio',
                                  style: TextStyle(
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      _showToast("Enviando mensaje...");
                      _revisarMensajes().then((valor) {
                        setState(() {
                          _enviarMensaje(_todoBien);
                        });
                      });
                    },
                    child: Container(
                      height: 130.0,
                      width: (MediaQuery.of(context).size.width - 40.0) / 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        shape: BoxShape.rectangle,
                        color: Colors.blue,
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(20.0),
                        child: Center(
                          child: ListBody(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.notifications,
                                    size: 60.0,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              Center(
                                child: Text(
                                  'Me encuentro bien',
                                  style: TextStyle(
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  GestureDetector(
                    onTap: () async {
                      _revisarMensajes().then((valor) {
                        setState(() {
                          _obtenerPosicionActual();
                        });
                      });
                    },
                    child: Container(
                      height: 130.0,
                      width: (MediaQuery.of(context).size.width - 40.0) / 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        shape: BoxShape.rectangle,
                        color: Color(0xff8c2500),
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(20.0),
                        child: Center(
                          child: ListBody(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.notification_important,
                                    size: 60.0,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              Center(
                                child: Text(
                                  'Auxilio',
                                  style: TextStyle(
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _recuperarContactos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _numerosContactos.add(prefs.getString(_recordarTelefono1));
    _numerosContactos.add(prefs.getString(_recordarTelefono2));
    _numerosContactos.add(prefs.getString(_recordarTelefono3));
  }

  void _enviarMensaje(String mensaje) async {
    await Sendsms.onGetPermission();
    if (await Sendsms.hasPermission()) {
      _numerosContactos.forEach((element) async {
        await Sendsms.onSendSMS(element, mensaje);
        _showToast("Mensaje enviado\n\n\"$mensaje\"");
      });
    }
  }

  Future<Position> _obtenerPosicionActual() async {
    bool serviceEnabled;
    LocationPermission permission;
    String _error;
    _showToast("Enviando mensaje...");

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _error = 'Favor de activar los servicios de GPS.';
      _mostrarAlertaErrorLocalizacion(context, _error);
      return Future.error(_error);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      _error =
          'Los permisos de localización están como siempre desactivados.\n\n' +
              'Favor de activarlos para usar esta función';
      _mostrarAlertaErrorLocalizacion(context, _error);
      return Future.error(_error);
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Los permisos de localización están como desactivados.');
      }
    }

    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _obtenerDireccionConLatLng(position);
      });
    }).catchError((e) {
      print(e);
    });
  }

  void _obtenerDireccionConLatLng(Position _localizacion) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _localizacion.latitude, _localizacion.longitude);
      Placemark _direccion = placemarks[0];
      setState(() {
        _enviarMensaje("$_auxilio ${_direccion.street}, " +
            "${_direccion.subLocality}, ${_direccion.postalCode} (${_localizacion.latitude}," +
            " ${_localizacion.longitude})");
      });
    } catch (e) {
      print(e);
    }
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

  void _mostrarAlertaTips(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: Text('¿Sabías qué?'),
              content: Container(
                child: Text(
                  _consejo,
                  style: TextStyle(
                    fontSize: 17,
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
                      child: Text('Salir'),
                      onPressed: () {
                        _obtenerRecomendacion();
                        Navigator.of(context).pop();
                      },
                    )),
              ],
            );
          });
        });
  }

  void _showToast(String mensaje) {
    Fluttertoast.showToast(
        msg: mensaje,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  Future<bool> _obtenerRecomendaciones() async {
    var url = 'http://13.84.215.39:8080/listar/recomendaciones';
    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    if (response.statusCode == 200) {
      _recomendacionModel = recomendacionModelFromJson(response.body);
      return true;
    }
    return false;
  }

  Future<void> _obtenerRecomendacion() async {
    if (_idRecomendacion > _recomendacionModel.length) _idRecomendacion = 1;
    var url = 'http://13.84.215.39:8080/listar/recomendacion/' +
        _idRecomendacion.toString();
    log(_recomendacionModel.length.toString() +
        ' ' +
        _idRecomendacion.toString());
    _idRecomendacion = _idRecomendacion + 1;
    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json; charset=utf-8"
      },
    );
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        _consejo = jsonResponse['texto_recomendacion'];
      });
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text('Cerrar la aplicación'),
            content: Container(
              child: Text(
                '¿Desea salir de la aplicación?',
                style: TextStyle(
                  fontSize: 17,
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
                    child: Text('Salir'),
                    onPressed: () => SystemNavigator.pop(),
                  )),
            ],
          );
        });
  }

  Future<bool> _revisarMensajes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_recordarAuxilioPrefs) == null)
      prefs.setString(
          _recordarAuxilioPrefs, 'Necesito ayuda, me encuentro en: ');
    _auxilio = prefs.getString(_recordarAuxilioPrefs);

    if (prefs.getString(_recordarTodoBienPrefs) == null)
      prefs.setString(
          _recordarTodoBienPrefs, 'Me encuentro bien, no te preocupes.');
    _todoBien = prefs.getString(_recordarTodoBienPrefs);

    return true;
  }
}
