import 'dart:developer';

import 'package:FRIDA/models/login_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';

class LoginBrigadista extends StatefulWidget {
  @override
  _LoginBrigadistaState createState() => _LoginBrigadistaState();
}

class _LoginBrigadistaState extends State<LoginBrigadista> {
  TextEditingController _controllerUsername, _controllerPassword;
  String _password = '',
      _username = '',
      _token = '',
      _recordarUsuarioPrefs = "recordarUsuario",
      _recordarPasswordPrefs = "recordarPassword",
      _recordarCheckPrefs = "recordarCheck",
      _sesionActivaPrefs = "sesionActiva",
      _usuarioActivoPrefs = "usuarioActivo",
      _passwordActivaPrefs = "passwordActiva";
  bool _check = true;

  @override
  void initState() {
    super.initState();
    _revisarSesionActiva().then((valor) {
      if (valor) {
        Navigator.pushNamed(context, 'home_brigadista');
      }
    });
    _revisarRecordarLogin().then((valor) {
      setState(() {
        _controllerUsername = new TextEditingController(text: _username);
        _controllerPassword = new TextEditingController(text: _password);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: Container(
                  padding: EdgeInsets.all(70.0),
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sistema Auxiliar Post-Sísmico',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'FRIDA',
                        style: TextStyle(
                          fontSize: 35.0,
                        ),
                      ),
                      Text(
                        'Brigadista',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(60.0),
                        child: FadeInImage(
                          image: AssetImage('assets/Logo.png'),
                          placeholder: AssetImage('assets/original.gif'),
                          fadeInDuration: Duration(milliseconds: 200),
                        ),
                      ),
                      _crearEmail(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _crearPassword(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Checkbox(
                            value: _check,
                            onChanged: (nuevoValor) {
                              setState(() {
                                _check = nuevoValor;
                              });
                            },
                          ),
                          Text('¿Recordar credenciales?'),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.only(left: 3.0),
                                child: ButtonTheme(
                                    height: 45.0,
                                    child: RaisedButton(
                                      child: Text(
                                        'Iniciar sesión',
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.black),
                                      ),
                                      color: Color(0xffffd54f),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      onPressed: () {
                                        _verificarLogin().then((autenticacion) {
                                          if (autenticacion != null) {
                                            if (autenticacion.authorities.first
                                                    .authority ==
                                                'ROLE_BRIGADISTA') {
                                              _recordarLogin(_check);
                                              _token = autenticacion.token;
                                              _recordarSesionActiva();
                                              Navigator.pushNamed(
                                                  context, 'home_brigadista');
                                            } else
                                              _crearDialog();
                                          } else
                                            _crearDialog();
                                        });
                                      },
                                    ))),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
          ),
        ));
  }

  Widget _crearEmail() {
    return TextField(
      controller: _controllerUsername,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        hintText: 'Introduce tu usuario',
        labelText: 'Usuario',
        suffixIcon: Icon(Icons.person),
      ),
      onChanged: (valor) {
        setState(() {
          _username = valor;
        });
      },
    );
  }

  Widget _crearPassword() {
    return TextField(
      controller: _controllerPassword,
      obscureText: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        counter: Text('Letras ${_password.length}'),
        hintText: 'Introduce tu contraseña',
        labelText: 'Contraseña',
        helperText: '8 caracteres mínimo',
        suffixIcon: Icon(Icons.lock),
      ),
      onChanged: (valor) {
        setState(() {
          _password = valor;
        });
      },
    );
  }

  Future<LoginModel> _verificarLogin() async {
    final String url = "http://13.84.215.39:8080/login";
    final response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: convert.jsonEncode(
          {
            "nombreUsuario": _username,
            "password": _password,
          },
        ));
    if (response.statusCode == 200) {
      final String responseString = response.body;
      return loginModelFromJson(responseString);
    } else {
      return null;
    }
  }

  Future<void> _recordarLogin(bool valor) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (valor) {
      prefs.setString(_recordarUsuarioPrefs, _username);
      prefs.setString(_recordarPasswordPrefs, _password);
    } else {
      prefs.setString(_recordarUsuarioPrefs, '');
      prefs.setString(_recordarPasswordPrefs, '');
    }
    prefs.setBool(_recordarCheckPrefs, valor);
  }

  Future<bool> _revisarRecordarLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_recordarUsuarioPrefs) == null)
      prefs.setString(_recordarUsuarioPrefs, '');
    _username = prefs.getString(_recordarUsuarioPrefs);

    if (prefs.getString(_recordarPasswordPrefs) == null)
      prefs.setString(_recordarPasswordPrefs, '');
    _password = prefs.getString(_recordarPasswordPrefs);

    if (prefs.getBool(_recordarCheckPrefs) == null)
      prefs.setBool(_recordarCheckPrefs, false);
    _check = prefs.getBool(_recordarCheckPrefs);

    return true;
  }

  Future<void> _recordarSesionActiva() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_sesionActivaPrefs, _token);
    prefs.setString(_usuarioActivoPrefs, _username);
    prefs.setString(_passwordActivaPrefs, _password);
  }

  Future<bool> _revisarSesionActiva() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_sesionActivaPrefs) == null)
      return false;
    else {
      _token = prefs.getString(_sesionActivaPrefs);
      return true;
    }
  }

  void _crearDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text('Error'),
            content: Container(
              child: Text(
                'Credenciales incorrectas.',
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
                    onPressed: () => Navigator.of(context).pop(),
                  )),
            ],
          );
        });
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
}
