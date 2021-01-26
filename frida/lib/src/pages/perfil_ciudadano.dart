import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

var jsonResponse,
    _nombre = '',
    _apellido_paterno = '',
    _apellido_materno = '',
    _fecha = '',
    _calle_numero = '',
    _colonia = '',
    _cp = '',
    _alcaldia_municipio = '',
    _estado = '',
    _email = '',
    _password = '',
    _temp,
    _usuarioActivo = '',
    _sesionActivaPrefs = "sesionActiva",
    _usuarioActivoPrefs = "usuarioActivo",
    _passwordActivaPrefs = "passwordActiva";

int _id_usuario, _id_ciudadano;

class PerfilCiudadano extends StatefulWidget {
  PerfilCiudadano({Key key}) : super(key: key);

  @override
  _PerfilCiudadanoState createState() => _PerfilCiudadanoState();
}

class _PerfilCiudadanoState extends State<PerfilCiudadano> {
  @override
  void initState() {
    super.initState();
    _revisarUsuarioActivo().then((valor) {
      _recuperarCiudadanos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        backgroundColor: Color(0xffffd54f),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 5.0,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Color(0xffd8a500),
                    ),
                    title: Text(
                      'Datos personales',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
                    child: Column(
                      children: <Widget>[
                        _elementoCard('Nombre(s)', _nombre),
                        Divider(),
                        _elementoCard('Apellido Paterno', _apellido_paterno),
                        Divider(),
                        _elementoCard('Apellido Materno', _apellido_materno),
                        Divider(),
                        _elementoCard('Fecha de Nacimiento', _fecha),
                      ],
                    ),
                  ),
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
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.home,
                      color: Color(0xffd8a500),
                    ),
                    title: Text(
                      'Domicilio',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
                    child: Column(
                      children: <Widget>[
                        _elementoCard('Calle y número', _calle_numero),
                        Divider(),
                        _elementoCard('Colonia', _colonia),
                        Divider(),
                        _elementoCard('Código Postal', _cp),
                        Divider(),
                        _elementoCard(
                            'Alcaldía o Municipio', _alcaldia_municipio),
                        Divider(),
                        _elementoCard('Estado', _estado),
                      ],
                    ),
                  ),
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
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.email,
                      color: Color(0xffd8a500),
                    ),
                    title: Text(
                      'Credenciales de acceso',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
                    child: Column(
                      children: <Widget>[
                        _elementoCard('Correo', _email),
                        Divider(),
                        _elementoCard('Contraseña', _password),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            ButtonTheme(
              height: 45.0,
              minWidth: MediaQuery.of(context).size.width - 40,
              child: RaisedButton(
                child: Text(
                  'Actualizar datos',
                  style: TextStyle(fontSize: 17),
                ),
                color: Color(0xffffd54f),
                textColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                onPressed: () {
                  setState(() {
                    _actualizarCiudadano().then((valor) {
                      if (valor)
                        _showToast('Perfil actualizado');
                      else
                        _showToast('Error al actualizar perfil');
                    });
                  });
                },
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            ButtonTheme(
              height: 45.0,
              minWidth: MediaQuery.of(context).size.width - 40,
              child: RaisedButton(
                child: Text(
                  'Cerrar sesión',
                  style: TextStyle(fontSize: 17),
                ),
                color: Color(0xffd8a500),
                textColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                onPressed: () {
                  _cerrarSesion().then((valor) {
                    Navigator.pushNamed(context, 'login');
                  });
                },
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _recuperarCiudadanos() async {
    log(_usuarioActivo);
    var url =
        'http://13.84.215.39:8080/usuarios/nombreUsuario/' + _usuarioActivo;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        _nombre = jsonResponse['nombre'];
        _apellido_paterno = jsonResponse['apellido_paterno'];
        _apellido_materno = jsonResponse['apellido_materno'];
        _email = jsonResponse['email'];
        _fecha = jsonResponse['fecha_nacimiento'];
        _calle_numero = jsonResponse['calle_numero'];
        _colonia = jsonResponse['colonia'];
        _cp = jsonResponse['cp'];
        _alcaldia_municipio = jsonResponse['alcaldia_municipio'];
        _estado = jsonResponse['estado'];
        _id_usuario = jsonResponse['idUsuario'];
        _id_ciudadano = jsonResponse['idCiudadano'];
      });
      return true;
    } else {
      log('${response.statusCode}');
    }
  }

  Future<bool> _actualizarCiudadano() async {
    var url = 'http://13.84.215.39:8080/actualizar/uciudadano/' +
        _id_usuario.toString();
    var response = await http.put(url,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: convert.jsonEncode(
          {
            "nombre": _nombre,
            "apellido_paterno": _apellido_paterno,
            "apellido_materno": _apellido_materno,
            "email": _email,
            "nombreUsuario": _email,
            "password": _password,
            "fecha_nacimiento": _fecha,
            "calle_numero": _calle_numero,
            "colonia": _colonia,
            "cp": _cp,
            "alcaldia_municipio": _alcaldia_municipio,
            "estado": _estado,
            "id_recomendacion": "1",
            "idUsuario": _id_usuario.toString()
          },
        ));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Widget _elementoCard(String _campo, String _valor) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_campo,
                    style: TextStyle(fontSize: 17, color: Colors.black87)),
                Text(_valor,
                    style: TextStyle(fontSize: 16, color: Colors.black54)),
              ],
            ),
            Container(
                child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  log(_campo);
                  _mostrarCuadroModificacion(context, _campo);
                });
              },
            )),
          ],
        ),
      ],
    );
  }

  void _mostrarCuadroModificacion(BuildContext context, String campo) {
    if (campo == "Fecha de Nacimiento")
      showDatePicker(
              context: context,
              initialDate: DateTime(1980),
              firstDate: DateTime(1910),
              lastDate: DateTime.now())
          .then((fecha) {
        setState(() {
          _fecha = fecha.year.toString();
          if (fecha.month.toString().length == 1)
            _fecha = _fecha + "-0" + fecha.month.toString();
          else
            _fecha = _fecha + "-" + fecha.month.toString();
          if (fecha.day.toString().length == 1)
            _fecha = _fecha + "-0" + fecha.day.toString();
          else
            _fecha = _fecha + "-" + fecha.day.toString();
        });
      });
    else {
      _temp = '';
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: Text('Modificar ${campo.toLowerCase()}'),
              content: Container(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      hintText: campo,
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
                      switch (campo) {
                        case "Nombre(s)":
                          _nombre = _temp;
                          break;
                        case "Apellido Paterno":
                          _apellido_paterno = _temp;
                          break;
                        case "Apellido Materno":
                          _apellido_materno = _temp;
                          break;
                        case "Calle y número":
                          _calle_numero = _temp;
                          break;
                        case "Colonia":
                          _colonia = _temp;
                          break;
                        case "Código Postal":
                          _cp = _temp;
                          break;
                        case "Alcaldía o Municipio":
                          _alcaldia_municipio = _temp;
                          break;
                        case "Estado":
                          _estado = _temp;
                          break;
                        case "Correo":
                          _email = _temp;
                          break;
                        case "Contraseña":
                          _password = _temp;
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

  Future<void> _cerrarSesion() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_sesionActivaPrefs, null);
    prefs.setString(_usuarioActivoPrefs, null);
    prefs.setString(_passwordActivaPrefs, null);
  }

  Future<void> _revisarUsuarioActivo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _usuarioActivo = prefs.getString(_usuarioActivoPrefs);
    _password = prefs.getString(_passwordActivaPrefs);
    return true;
  }

  void _showToast(String mensaje) {
    Fluttertoast.showToast(
        msg: mensaje,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }
}
