import 'dart:developer';
import 'dart:io';
import 'package:FRIDA/models/caso_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:search_map_place/search_map_place.dart';
import 'dart:convert' as convert;
import 'package:intl/intl.dart';

class NotificarDanio extends StatefulWidget {
  @override
  _NotificarDanioState createState() => _NotificarDanioState();
}

class _NotificarDanioState extends State<NotificarDanio> {
  GoogleMapController _controller;
  LatLng _lugarMarcador = LatLng(9.4312068, -99.1444799);
  File _imagen1, _imagen2, _imagen3, _imagen4, _imagen5;
  String _idCiudadano = '1', _prioridad, _tipoDanio;
  double _calificacion;
  final picker = ImagePicker();
  double _pregunta1Valor = 0.0,
      _pregunta2Valor = 1.0,
      _pregunta3Valor = 1.0,
      _pregunta4Valor = 2.0,
      _pregunta5Valor = 5.0,
      _pregunta61Valor = 1.0,
      _pregunta62Valor = 1.0,
      _pregunta63Valor = 1.0,
      _pregunta64Valor = 1.0,
      _pregunta7Valor = 10.0,
      _pregunta8Valor = 5.0,
      _pregunta9Valor = 5.0,
      _pregunta10Valor = 1.0;
  bool _ubicacionFotos = true,
      _pregunta1 = true,
      _pregunta2 = false,
      _pregunta3 = false,
      _pregunta4 = false,
      _pregunta5 = false,
      _pregunta6 = false,
      _pregunta7 = false,
      _pregunta8 = false,
      _pregunta9 = false,
      _pregunta10 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reporte de daño',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: _ubicacionFotos
          ? Container(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                children: <Widget>[
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    elevation: 5.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0),
                          child: Text(
                            'Selecciona la ubicación del inmueble.',
                            style: TextStyle(
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0),
                          child: SearchMapPlaceWidget(
                            strictBounds: true,
                            language: 'spanish',
                            apiKey: 'AIzaSyAiLownwA4ulwVdglsmEve2TGdAvdZAbt0',
                            placeholder:
                                'Introducir la dirección donde se encuentra el daño.',
                            hasClearButton: true,
                            placeType: PlaceType.address,
                            onSelected: (Place lugar) async {
                              Geolocation geolocalizacion =
                                  await lugar.geolocation;
                              _controller.animateCamera(CameraUpdate.newLatLng(
                                  geolocalizacion.coordinates));
                              _controller.animateCamera(
                                  CameraUpdate.newLatLngBounds(
                                      geolocalizacion.bounds, 0));

                              _lugarMarcador = geolocalizacion.coordinates;
                              _actualizarMapa();
                            },
                          ),
                        ),
                        _mapas(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    elevation: 5.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0),
                          child: Text(
                            'Añadir fotos del inmueble',
                            style: TextStyle(
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(20.0),
                          height: 240,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              _imagen1 == null
                                  ? _crearCamposFotos(1)
                                  : _crearBotonCancelarFoto(1),
                              SizedBox(
                                width: 20.0,
                              ),
                              _imagen2 == null
                                  ? _crearCamposFotos(2)
                                  : _crearBotonCancelarFoto(2),
                              SizedBox(
                                width: 20.0,
                              ),
                              _imagen3 == null
                                  ? _crearCamposFotos(3)
                                  : _crearBotonCancelarFoto(3),
                              SizedBox(
                                width: 20.0,
                              ),
                              _imagen4 == null
                                  ? _crearCamposFotos(4)
                                  : _crearBotonCancelarFoto(4),
                              SizedBox(
                                width: 20.0,
                              ),
                              _imagen5 == null
                                  ? _crearCamposFotos(5)
                                  : _crearBotonCancelarFoto(5),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(),
                      ButtonTheme(
                        height: 45.0,
                        child: RaisedButton(
                          child: Text(
                            'Continuar con el cuestionario',
                            style: TextStyle(fontSize: 17),
                          ),
                          color: Color(0xffd8a500),
                          textColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          onPressed: () {
                            _ubicacionFotos = false;
                            setState(() {});
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            )
          : Column(
              children: [
                _pregunta1
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 30.0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 670,
                        child: Card(
                          elevation: 5.0,
                          child: ListView(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 75.0,
                                          height: 75.0,
                                          decoration: BoxDecoration(
                                              color: Colors.blue[700],
                                              shape: BoxShape.circle),
                                          child: (Text(
                                            '1',
                                            style: TextStyle(
                                              fontSize: 40,
                                              color: Colors.white,
                                            ),
                                          )),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: Container(
                                          alignment: Alignment.topCenter,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                          child: (Expanded(
                                              child: Text(
                                            '¿Se puede acceder al inmueble?',
                                            style: TextStyle(fontSize: 25.0),
                                            textAlign: TextAlign.start,
                                          ))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Card(
                                    child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('Sí'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 0.0,
                                        groupValue: _pregunta1Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta1Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('No'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 1.0,
                                        groupValue: _pregunta1Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta1Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(),
                                    ButtonTheme(
                                        height: 45.0,
                                        child: RaisedButton(
                                          child: Text(
                                            'Siguiente',
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          onPressed: () {
                                            setState(() {
                                              _pregunta1 = false;
                                              _pregunta2 = true;
                                            });
                                          },
                                        )),
                                  ],
                                ),
                              ]),
                        ),
                      )
                    : Container(),
                _pregunta2
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 30.0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 670,
                        child: Card(
                          elevation: 5.0,
                          child: ListView(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 75.0,
                                          height: 75.0,
                                          decoration: BoxDecoration(
                                              color: Colors.blue[700],
                                              shape: BoxShape.circle),
                                          child: (Text(
                                            '2',
                                            style: TextStyle(
                                              fontSize: 40,
                                              color: Colors.white,
                                            ),
                                          )),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: Container(
                                          alignment: Alignment.topCenter,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                          child: (Expanded(
                                              child: Text(
                                            'Numero de pisos',
                                            style: TextStyle(fontSize: 25.0),
                                            textAlign: TextAlign.start,
                                          ))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Card(
                                    child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('3 o más.'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 1.0,
                                        groupValue: _pregunta2Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta2Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('Menos de 3'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 0.0,
                                        groupValue: _pregunta2Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta2Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    ButtonTheme(
                                        height: 45.0,
                                        child: RaisedButton(
                                          child: Text(
                                            'Anterior',
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          onPressed: () {
                                            setState(() {
                                              _pregunta1 = true;
                                              _pregunta2 = false;
                                            });
                                          },
                                        )),
                                    ButtonTheme(
                                        height: 45.0,
                                        child: RaisedButton(
                                          child: Text(
                                            'Siguiente',
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          onPressed: () {
                                            setState(() {
                                              _pregunta2 = false;
                                              _pregunta3 = true;
                                            });
                                          },
                                        )),
                                  ],
                                ),
                              ]),
                        ),
                      )
                    : Container(),
                _pregunta3
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 30.0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 670,
                        child: Card(
                          elevation: 5.0,
                          child: ListView(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 75.0,
                                          height: 75.0,
                                          decoration: BoxDecoration(
                                              color: Colors.blue[700],
                                              shape: BoxShape.circle),
                                          child: (Text(
                                            '3',
                                            style: TextStyle(
                                              fontSize: 40,
                                              color: Colors.white,
                                            ),
                                          )),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: Container(
                                          alignment: Alignment.topCenter,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                          child: (Expanded(
                                              child: Text(
                                            'Numero ocupantes o residentes',
                                            style: TextStyle(fontSize: 25.0),
                                            textAlign: TextAlign.start,
                                          ))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Card(
                                    child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('5 o más.'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 1.0,
                                        groupValue: _pregunta3Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta3Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('Menos de 5'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 0.0,
                                        groupValue: _pregunta3Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta3Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    ButtonTheme(
                                        height: 45.0,
                                        child: RaisedButton(
                                          child: Text(
                                            'Anterior',
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          onPressed: () {
                                            setState(() {
                                              _pregunta2 = true;
                                              _pregunta3 = false;
                                            });
                                          },
                                        )),
                                    ButtonTheme(
                                        height: 45.0,
                                        child: RaisedButton(
                                          child: Text(
                                            'Siguiente',
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          onPressed: () {
                                            setState(() {
                                              _pregunta3 = false;
                                              _pregunta4 = true;
                                            });
                                          },
                                        )),
                                  ],
                                ),
                              ]),
                        ),
                      )
                    : Container(),
                _pregunta4
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 30.0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 120,
                        child: Card(
                          elevation: 5.0,
                          child: ListView(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 75.0,
                                          height: 75.0,
                                          decoration: BoxDecoration(
                                              color: Colors.blue[700],
                                              shape: BoxShape.circle),
                                          child: (Text(
                                            '4',
                                            style: TextStyle(
                                              fontSize: 40,
                                              color: Colors.white,
                                            ),
                                          )),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: Container(
                                          alignment: Alignment.topCenter,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                          child: (Expanded(
                                              child: Text(
                                            'Uso del inmueble',
                                            style: TextStyle(fontSize: 25.0),
                                            textAlign: TextAlign.start,
                                          ))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Card(
                                    child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('Estacionamiento'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 2.0,
                                        groupValue: _pregunta4Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta4Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('Casa habitación'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 1.5,
                                        groupValue: _pregunta4Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta4Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('Educación'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 2.9,
                                        groupValue: _pregunta4Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta4Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('Comercio'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 2.8,
                                        groupValue: _pregunta4Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta4Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('Salud'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 3.0,
                                        groupValue: _pregunta4Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta4Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('Departamentos'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 1.6,
                                        groupValue: _pregunta4Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta4Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('Industrias u oficinas'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 2.1,
                                        groupValue: _pregunta4Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta4Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text(
                                          'Centro de reunión o recreativo'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 1.0,
                                        groupValue: _pregunta4Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta4Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    ButtonTheme(
                                        height: 45.0,
                                        child: RaisedButton(
                                          child: Text(
                                            'Anterior',
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          onPressed: () {
                                            setState(() {
                                              _pregunta3 = true;
                                              _pregunta4 = false;
                                            });
                                          },
                                        )),
                                    ButtonTheme(
                                        height: 45.0,
                                        child: RaisedButton(
                                          child: Text(
                                            'Siguiente',
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          onPressed: () {
                                            setState(() {
                                              _pregunta4 = false;
                                              _pregunta5 = true;
                                            });
                                          },
                                        )),
                                  ],
                                ),
                              ]),
                        ),
                      )
                    : Container(),
                _pregunta5
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 30.0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 670,
                        child: Card(
                          elevation: 5.0,
                          child: ListView(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 75.0,
                                          height: 75.0,
                                          decoration: BoxDecoration(
                                              color: Colors.blue[700],
                                              shape: BoxShape.circle),
                                          child: (Text(
                                            '5',
                                            style: TextStyle(
                                              fontSize: 40,
                                              color: Colors.white,
                                            ),
                                          )),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: Container(
                                          alignment: Alignment.topCenter,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                          child: (Expanded(
                                              child: Text(
                                            '¿Estado actual del inmueble?',
                                            style: TextStyle(fontSize: 25.0),
                                            textAlign: TextAlign.start,
                                          ))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Card(
                                    child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('Ocupado'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 5.0,
                                        groupValue: _pregunta5Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta5Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('Desocupado'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 0.0,
                                        groupValue: _pregunta5Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta5Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    ButtonTheme(
                                        height: 45.0,
                                        child: RaisedButton(
                                          child: Text(
                                            'Anterior',
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          onPressed: () {
                                            setState(() {
                                              _pregunta4 = true;
                                              _pregunta5 = false;
                                            });
                                          },
                                        )),
                                    ButtonTheme(
                                        height: 45.0,
                                        child: RaisedButton(
                                          child: Text(
                                            'Siguiente',
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          onPressed: () {
                                            setState(() {
                                              _pregunta5 = false;
                                              _pregunta6 = true;
                                            });
                                          },
                                        )),
                                  ],
                                ),
                              ]),
                        ),
                      )
                    : Container(),
                _pregunta6
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 30.0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 380,
                        child: Card(
                          elevation: 5.0,
                          child: ListView(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 75.0,
                                          height: 75.0,
                                          decoration: BoxDecoration(
                                              color: Colors.blue[700],
                                              shape: BoxShape.circle),
                                          child: (Text(
                                            '6',
                                            style: TextStyle(
                                              fontSize: 40,
                                              color: Colors.white,
                                            ),
                                          )),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: Container(
                                          alignment: Alignment.topCenter,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                          child: (Expanded(
                                              child: Text(
                                            'Tipos de estructuras',
                                            style: TextStyle(fontSize: 25.0),
                                            textAlign: TextAlign.start,
                                          ))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Card(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 20.0, top: 10.0),
                                      child: Text(
                                        'Columnas',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                              child: Column(
                                            children: [
                                              ListTile(
                                                contentPadding:
                                                    EdgeInsets.all(10.0),
                                                title: Text('Concreto'),
                                                leading: Radio(
                                                  activeColor: Colors.blue[700],
                                                  value: 1.0,
                                                  groupValue: _pregunta61Valor,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta61Valor = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            child: ListTile(
                                              contentPadding:
                                                  EdgeInsets.all(10.0),
                                              title: Text('Acero'),
                                              leading: Radio(
                                                activeColor: Colors.blue[700],
                                                value: 0.0,
                                                groupValue: _pregunta61Valor,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _pregunta61Valor = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 20.0, top: 10.0),
                                      child: Text(
                                        'Muros',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                              child: Column(
                                            children: [
                                              ListTile(
                                                contentPadding:
                                                    EdgeInsets.all(10.0),
                                                title: Text('Concreto'),
                                                leading: Radio(
                                                  activeColor: Colors.blue[700],
                                                  value: 1.0,
                                                  groupValue: _pregunta62Valor,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta62Valor = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            child: ListTile(
                                              contentPadding:
                                                  EdgeInsets.all(10.0),
                                              title: Text('Ladrillo'),
                                              leading: Radio(
                                                activeColor: Colors.blue[700],
                                                value: 0.0,
                                                groupValue: _pregunta62Valor,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _pregunta62Valor = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 20.0, top: 10.0),
                                      child: Text(
                                        'Trabes',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                              child: Column(
                                            children: [
                                              ListTile(
                                                contentPadding:
                                                    EdgeInsets.all(10.0),
                                                title: Text('Concreto'),
                                                leading: Radio(
                                                  activeColor: Colors.blue[700],
                                                  value: 1.0,
                                                  groupValue: _pregunta63Valor,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta63Valor = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            child: ListTile(
                                              contentPadding:
                                                  EdgeInsets.all(10.0),
                                              title: Text('Acero'),
                                              leading: Radio(
                                                activeColor: Colors.blue[700],
                                                value: 0.0,
                                                groupValue: _pregunta63Valor,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _pregunta63Valor = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 20.0, top: 10.0),
                                      child: Text(
                                        'Entrepiso',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                              child: Column(
                                            children: [
                                              ListTile(
                                                contentPadding:
                                                    EdgeInsets.all(10.0),
                                                title: Text('Lámina'),
                                                leading: Radio(
                                                  activeColor: Colors.blue[700],
                                                  value: 1.0,
                                                  groupValue: _pregunta64Valor,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta64Valor = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            child: ListTile(
                                              contentPadding:
                                                  EdgeInsets.all(10.0),
                                              title: Text('Concreto'),
                                              leading: Radio(
                                                activeColor: Colors.blue[700],
                                                value: 0.0,
                                                groupValue: _pregunta64Valor,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _pregunta64Valor = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    ButtonTheme(
                                        height: 45.0,
                                        child: RaisedButton(
                                          child: Text(
                                            'Anterior',
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          onPressed: () {
                                            setState(() {
                                              _pregunta5 = true;
                                              _pregunta6 = false;
                                            });
                                          },
                                        )),
                                    ButtonTheme(
                                        height: 45.0,
                                        child: RaisedButton(
                                          child: Text(
                                            'Siguiente',
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          onPressed: () {
                                            setState(() {
                                              _pregunta6 = false;
                                              _pregunta7 = true;
                                            });
                                          },
                                        )),
                                  ],
                                ),
                              ]),
                        ),
                      )
                    : Container(),
                _pregunta7
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 30.0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 490,
                        child: Card(
                          elevation: 5.0,
                          child: ListView(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 75.0,
                                          height: 75.0,
                                          decoration: BoxDecoration(
                                              color: Colors.blue[700],
                                              shape: BoxShape.circle),
                                          child: (Text(
                                            '7',
                                            style: TextStyle(
                                              fontSize: 40,
                                              color: Colors.white,
                                            ),
                                          )),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: Container(
                                          alignment: Alignment.topCenter,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                          child: (Expanded(
                                              child: Text(
                                            '¿Se presenta en el inmueble...?',
                                            style: TextStyle(fontSize: 25.0),
                                            textAlign: TextAlign.start,
                                          ))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Card(
                                    child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('Colapso o derrumbe total'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 10.0,
                                        groupValue: _pregunta7Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta7Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('Derrumbe parcial'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 5.0,
                                        groupValue: _pregunta7Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta7Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('Desplome o inclinación'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 3.0,
                                        groupValue: _pregunta7Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta7Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('Ninguno'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 0.0,
                                        groupValue: _pregunta7Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta7Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    ButtonTheme(
                                        height: 45.0,
                                        child: RaisedButton(
                                          child: Text(
                                            'Anterior',
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          onPressed: () {
                                            setState(() {
                                              _pregunta6 = true;
                                              _pregunta7 = false;
                                            });
                                          },
                                        )),
                                    ButtonTheme(
                                        height: 45.0,
                                        child: RaisedButton(
                                          child: Text(
                                            'Siguiente',
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          onPressed: () {
                                            setState(() {
                                              _pregunta7 = false;
                                              _pregunta8 = true;
                                            });
                                          },
                                        )),
                                  ],
                                ),
                              ]),
                        ),
                      )
                    : Container(),
                _pregunta8
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 30.0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 490,
                        child: Card(
                          elevation: 5.0,
                          child: ListView(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 75.0,
                                          height: 75.0,
                                          decoration: BoxDecoration(
                                              color: Colors.blue[700],
                                              shape: BoxShape.circle),
                                          child: (Text(
                                            '8',
                                            style: TextStyle(
                                              fontSize: 40,
                                              color: Colors.white,
                                            ),
                                          )),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: Container(
                                          alignment: Alignment.topCenter,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                          child: (Expanded(
                                              child: Text(
                                            'Daño en inmuebles cercanos',
                                            style: TextStyle(fontSize: 25.0),
                                            textAlign: TextAlign.start,
                                          ))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Card(
                                    child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('Daños estructurales'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 5.0,
                                        groupValue: _pregunta8Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta8Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('Desplomos o recargamiento'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 3.0,
                                        groupValue: _pregunta8Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta8Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('Asentamientos'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 1.5,
                                        groupValue: _pregunta8Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta8Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('Ninguno'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 0.0,
                                        groupValue: _pregunta8Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta8Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    ButtonTheme(
                                        height: 45.0,
                                        child: RaisedButton(
                                          child: Text(
                                            'Anterior',
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          onPressed: () {
                                            setState(() {
                                              _pregunta7 = true;
                                              _pregunta8 = false;
                                            });
                                          },
                                        )),
                                    ButtonTheme(
                                        height: 45.0,
                                        child: RaisedButton(
                                          child: Text(
                                            'Siguiente',
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          onPressed: () {
                                            setState(() {
                                              _pregunta8 = false;
                                              _pregunta9 = true;
                                            });
                                          },
                                        )),
                                  ],
                                ),
                              ]),
                        ),
                      )
                    : Container(),
                _pregunta9
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 30.0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 405,
                        child: Card(
                          elevation: 5.0,
                          child: ListView(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 75.0,
                                          height: 75.0,
                                          decoration: BoxDecoration(
                                              color: Colors.blue[700],
                                              shape: BoxShape.circle),
                                          child: (Text(
                                            '9',
                                            style: TextStyle(
                                              fontSize: 40,
                                              color: Colors.white,
                                            ),
                                          )),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: Container(
                                          alignment: Alignment.topCenter,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                          child: (Expanded(
                                              child: Text(
                                            'Tipo de grieta encontrada',
                                            style: TextStyle(fontSize: 25.0),
                                            textAlign: TextAlign.start,
                                          ))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Card(
                                    child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('Forma de X en muro'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 5.0,
                                        groupValue: _pregunta9Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta9Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('Diagonal en una columna'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 4.9,
                                        groupValue: _pregunta9Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta9Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('Daño en trabe'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 4.8,
                                        groupValue: _pregunta9Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta9Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('Grieta diagonal en muro'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 4.7,
                                        groupValue: _pregunta9Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta9Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('Ninguno'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 0.0,
                                        groupValue: _pregunta9Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta9Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    ButtonTheme(
                                        height: 45.0,
                                        child: RaisedButton(
                                          child: Text(
                                            'Anterior',
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          onPressed: () {
                                            setState(() {
                                              _pregunta8 = true;
                                              _pregunta9 = false;
                                            });
                                          },
                                        )),
                                    ButtonTheme(
                                        height: 45.0,
                                        child: RaisedButton(
                                          child: Text(
                                            'Siguiente',
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          onPressed: () {
                                            setState(() {
                                              _pregunta9 = false;
                                              _pregunta10 = true;
                                            });
                                          },
                                        )),
                                  ],
                                ),
                              ]),
                        ),
                      )
                    : Container(),
                _pregunta10
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 30.0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 670,
                        child: Card(
                          elevation: 5.0,
                          child: ListView(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 75.0,
                                          height: 75.0,
                                          decoration: BoxDecoration(
                                              color: Colors.blue[700],
                                              shape: BoxShape.circle),
                                          child: (Text(
                                            '10',
                                            style: TextStyle(
                                              fontSize: 40,
                                              color: Colors.white,
                                            ),
                                          )),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: Container(
                                          alignment: Alignment.topCenter,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                          child: (Expanded(
                                              child: Text(
                                            '¿Cristales fracturados?',
                                            style: TextStyle(fontSize: 25.0),
                                            textAlign: TextAlign.start,
                                          ))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Card(
                                    child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('Sí'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 1.0,
                                        groupValue: _pregunta10Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta10Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Text('No'),
                                      leading: Radio(
                                        activeColor: Colors.blue[700],
                                        value: 0.0,
                                        groupValue: _pregunta10Valor,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta10Valor = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    ButtonTheme(
                                        height: 45.0,
                                        child: RaisedButton(
                                          child: Text(
                                            'Anterior',
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          onPressed: () {
                                            setState(() {
                                              _pregunta9 = true;
                                              _pregunta10 = false;
                                            });
                                          },
                                        )),
                                    ButtonTheme(
                                        height: 45.0,
                                        child: RaisedButton(
                                          child: Text(
                                            'Enviar caso',
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          onPressed: () {
                                            setState(() {
                                              _crearCaso().then((casoCreado) {
                                                final _idCaso =
                                                    casoCreado.idCaso;
                                                _subir(_idCaso.toString());
                                                _showToast(
                                                    'Caso subido correctamente');
                                                Navigator.pushNamed(
                                                    context, 'home_ciudadano');
                                              });
                                            });
                                          },
                                        )),
                                  ],
                                ),
                              ]),
                        ),
                      )
                    : Container(),
              ],
            ),
    );
  }

  CameraPosition _initialPosition =
      CameraPosition(target: LatLng(19.4516892, -99.1375919), zoom: 15.0);
  final Set<Marker> _markers = Set();

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });
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
          height: 350.0,
          alignment: Alignment.center,
          child: ClipRRect(
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: <Widget>[
                    GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: _initialPosition,
                        markers: _markers),
                  ],
                )),
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ],
    );
  }

  void _actualizarMapa() {
    setState(() {
      _markers.add(
        Marker(
          draggable: true,
          markerId: MarkerId("1"),
          position: _lugarMarcador,
          onDragEnd: ((newPosition) {
            _lugarMarcador = newPosition;
          }),
        ),
      );
    });
  }

  Widget _crearCamposFotos(int numeroFoto) {
    return Container(
      height: 200.0,
      width: 150.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[300],
        shape: BoxShape.rectangle,
      ),
      child: IconButton(
        icon: Icon(
          Icons.add_box,
          size: 30.0,
        ),
        onPressed: () {
          _camaraOGaleria(numeroFoto);
        },
      ),
    );
  }

  void _camaraOGaleria(int numeroFoto) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text('Añadir foto'),
            content: Container(
                child: Row(
              children: [
                Container(
                    height: 150.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[300],
                      shape: BoxShape.rectangle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            size: 30.0,
                          ),
                          onPressed: () {
                            _seleccionarFoto(numeroFoto, true);
                            Navigator.of(context).pop();
                          },
                        ),
                        Text('Abrir cámara')
                      ],
                    )),
                SizedBox(
                  width: 20.0,
                ),
                Container(
                    height: 150.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[300],
                      shape: BoxShape.rectangle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.insert_photo,
                            size: 30.0,
                          ),
                          onPressed: () {
                            _seleccionarFoto(numeroFoto, false);
                            Navigator.of(context).pop();
                          },
                        ),
                        Text('Abrir galería')
                      ],
                    )),
              ],
            )),
            actions: <Widget>[
              ButtonTheme(
                  height: 45.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Color(0xffffd54f),
                    child: Text('Cancelar'),
                    onPressed: () => Navigator.of(context).pop(),
                  )),
            ],
          );
        });
  }

  Future _seleccionarFoto(int numeroFoto, bool tipoFoto) async {
    var pickedFile;
    tipoFoto == true
        ? pickedFile =
            await picker.getImage(source: ImageSource.camera, imageQuality: 30)
        : pickedFile = await picker.getImage(
            source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        switch (numeroFoto) {
          case 1:
            _imagen1 = File(pickedFile.path);
            break;
          case 2:
            _imagen2 = File(pickedFile.path);
            break;
          case 3:
            _imagen3 = File(pickedFile.path);
            break;
          case 4:
            _imagen4 = File(pickedFile.path);
            break;
          case 5:
            _imagen5 = File(pickedFile.path);
            break;
        }
      } else {
        print('No se seleccionó foto.');
      }
    });
  }

  Future _subir(String _idCaso) async {
    final uri = Uri.parse("http://13.84.215.39:8080/crear/imagen");
    if (_imagen1 != null) {
      var request1 = http.MultipartRequest('POST', uri);
      var foto1 = await http.MultipartFile.fromPath("imageFile", _imagen1.path);
      request1.files.add(foto1);
      request1.fields['idCaso'] = _idCaso;
      var response = await request1.send();
      if (response.statusCode == 201) {
        log('Imagen 1 subida');
      } else {
        log('Error en la subida 1 ' + response.statusCode.toString());
      }
    }
    if (_imagen2 != null) {
      var request2 = http.MultipartRequest('POST', uri);
      var foto2 = await http.MultipartFile.fromPath("imageFile", _imagen2.path);
      request2.files.add(foto2);
      request2.fields['idCaso'] = _idCaso;
      var response = await request2.send();
      if (response.statusCode == 201) {
        log('Imagen 2 subida');
      } else {
        log('Error en la subida 2 ' + response.statusCode.toString());
      }
    }
    if (_imagen3 != null) {
      var request3 = http.MultipartRequest('POST', uri);
      var foto3 = await http.MultipartFile.fromPath("imageFile", _imagen3.path);
      request3.files.add(foto3);
      request3.fields['idCaso'] = _idCaso;
      var response = await request3.send();
      if (response.statusCode == 201) {
        log('Imagen 3 subida');
      } else {
        log('Error en la subida 3 ' + response.statusCode.toString());
      }
    }
    if (_imagen4 != null) {
      var request4 = http.MultipartRequest('POST', uri);
      var foto4 = await http.MultipartFile.fromPath("imageFile", _imagen4.path);
      request4.files.add(foto4);
      request4.fields['idCaso'] = _idCaso;
      var response = await request4.send();
      if (response.statusCode == 201) {
        log('Imagen 4 subida');
      } else {
        log('Error en la subida 4 ' + response.statusCode.toString());
      }
    }
    if (_imagen5 != null) {
      var request5 = http.MultipartRequest('POST', uri);
      var foto5 = await http.MultipartFile.fromPath("imageFile", _imagen5.path);
      request5.files.add(foto5);
      request5.fields['idCaso'] = _idCaso;
      var response = await request5.send();
      if (response.statusCode == 201) {
        log('Imagen 5 subida');
      } else {
        log('Error en la subida 5 ' + response.statusCode.toString());
      }
    }
    log(_idCaso);
  }

  void _obtenerPrioridad() {
    _calificacion = _pregunta1Valor +
        _pregunta2Valor +
        _pregunta3Valor +
        _pregunta4Valor +
        _pregunta5Valor +
        _pregunta61Valor +
        _pregunta62Valor +
        _pregunta63Valor +
        _pregunta64Valor +
        _pregunta7Valor +
        _pregunta8Valor +
        _pregunta9Valor +
        _pregunta10Valor;
    _calificacion = _calificacion * 10 / 36;
    if (_calificacion < 2.5) {
      _tipoDanio = 'Riesgo ligero';
      _prioridad = "3";
    } else if (_calificacion < 5.0) {
      _tipoDanio = 'Riesgo medio';
      _prioridad = "2";
    } else if (_calificacion < 7.5) {
      _tipoDanio = 'Riesgo alto';
      _prioridad = "1";
    } else {
      _tipoDanio = 'Colapso / Derrumbe';
      _prioridad = "1";
    }
  }

  Future<CasoModel> _crearCaso() async {
    _obtenerPrioridad();
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String fecha = formatter.format(now);
    List<Placemark> placemarks = await placemarkFromCoordinates(
        _lugarMarcador.latitude, _lugarMarcador.longitude);
    Placemark _direccion = placemarks[0];
    final String url = "http://13.84.215.39:8080/nuevo/caso";
    final response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: convert.jsonEncode(
          {
            "prioridad": _prioridad,
            "tipo_danio": _tipoDanio,
            "calle_numero": _direccion.street,
            "colonia": _direccion.subLocality,
            "cp": _direccion.postalCode,
            "alcaldia_municipio": _direccion.locality,
            "estado": _direccion.administrativeArea,
            "status_caso": "1",
            "fecha_reportado": fecha,
            "fecha_evaluado": null,
            "idCiudadano": _idCiudadano,
            "lat": _lugarMarcador.latitude,
            "lng": _lugarMarcador.longitude,
            "calificacion": _calificacion
          },
        ));
    if (response.statusCode == 201 || response.statusCode == 200) {
      final String responseString = response.body;
      return casoModelFromJson(responseString);
    } else {
      return null;
    }
  }

  Widget _crearBotonCancelarFoto(int numeroFoto) {
    File _imagenSeleccionada;
    switch (numeroFoto) {
      case 1:
        _imagenSeleccionada = _imagen1;
        break;
      case 2:
        _imagenSeleccionada = _imagen2;
        break;
      case 3:
        _imagenSeleccionada = _imagen3;
        break;
      case 4:
        _imagenSeleccionada = _imagen4;
        break;
      case 5:
        _imagenSeleccionada = _imagen5;
        break;
    }
    return Container(
      width: 150.0,
      child: FlatButton(
          padding: EdgeInsets.all(0.0),
          child: Image.file(_imagenSeleccionada),
          onPressed: () {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    title: Text('¿Borrar foto?'),
                    content: Container(
                      child: Text(
                        '¿Deseas eliminar la foto adjunta?',
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
                          child: Text('Eliminar'),
                          onPressed: () {
                            setState(() {
                              switch (numeroFoto) {
                                case 1:
                                  _imagen1 = null;
                                  break;
                                case 2:
                                  _imagen2 = null;
                                  break;
                                case 3:
                                  _imagen3 = null;
                                  break;
                                case 4:
                                  _imagen4 = null;
                                  break;
                                case 5:
                                  _imagen5 = null;
                                  break;
                              }
                              Navigator.of(context).pop();
                            });
                          },
                        ),
                      ),
                      ButtonTheme(
                          height: 45.0,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            color: Color(0xffffd54f),
                            child: Text('Cancelar'),
                            onPressed: () => Navigator.of(context).pop(),
                          )),
                    ],
                  );
                });
          }),
    );
  }

  void _showToast(String mensaje) {
    Fluttertoast.showToast(
        msg: mensaje,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }
}
