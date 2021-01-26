import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModificarMensaje extends StatefulWidget {
  ModificarMensaje({Key key}) : super(key: key);

  @override
  _ModificarMensajeState createState() => _ModificarMensajeState();
}

class _ModificarMensajeState extends State<ModificarMensaje> {
  final String _recordarTodoBienPrefs = "recordarTodoBien",
      _recordarAuxilioPrefs = "recordarAuxilio";
  String _todoBien = '', _auxilio = '';

  @override
  void initState() {
    super.initState();
    _revisarMensajes().then((valor) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar mensajes'),
        backgroundColor: Color(0xffffd54f),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Mensaje todo bien',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      leading: Icon(
                        Icons.check,
                        color: Color(0xffd8a500),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          bottom: 15.0, left: 15.0, right: 15.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Text(
                                _todoBien,
                                style: TextStyle(fontSize: 17),
                              )),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _mostrarCuadroModificacion(
                                      context, "todo bien");
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Mensaje de auxilio',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      leading: Icon(
                        Icons.warning,
                        color: Color(0xffd8a500),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(
                            bottom: 15.0, left: 15.0, right: 15.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                '*La dirección actual y las coordenadas no se pueden modificar.',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                  _auxilio +
                                      '*dirección actual* (*coordenadas actuales*)',
                                  style: TextStyle(fontSize: 17),
                                )),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _mostrarCuadroModificacion(
                                        context, "auxilio");
                                  },
                                )
                              ],
                            ),
                          ],
                        )),
                  ],
                )),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(),
                ButtonTheme(
                  height: 45.0,
                  child: RaisedButton(
                    child: Text(
                      'Confirmar cambios',
                      style: TextStyle(fontSize: 17),
                    ),
                    color: Color(0xffd8a500),
                    textColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    onPressed: () {
                      _recordarTodoBien();
                      _recordarAuxilio();
                      _showToast("Cambios realizados correctamente");
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _recordarTodoBien() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_recordarTodoBienPrefs, _todoBien);
  }

  Future<void> _recordarAuxilio() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_recordarAuxilioPrefs, _auxilio);
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

  void _showToast(String mensaje) {
    Fluttertoast.showToast(
        msg: mensaje,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  void _mostrarCuadroModificacion(BuildContext context, String campo) {
    var _temp = '';
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text('Modificar mensaje \"${campo.toLowerCase()}\".'),
            content: Container(
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  maxLength: 70,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                  onChanged: (valor) {
                    _temp = valor;
                  },
                )),
            actions: <Widget>[
              ButtonTheme(
                height: 45.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Color(0xffd8a500),
                  child: Text('Aceptar'),
                  onPressed: () => setState(() {
                    log(campo);
                    switch (campo) {
                      case "todo bien":
                        _todoBien = _temp;
                        break;
                      case "auxilio":
                        _auxilio = _temp;
                        break;
                    }
                    Navigator.of(context).pop();
                  }),
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
  }
}
