import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

var jsonResponse,
    _nombre = '',
    _apellido_paterno = '',
    _apellido_materno = '',
    _edad = '',
    _calle_numero = '',
    _colonia = '',
    _cp = '',
    _alcaldia_municipio = '',
    _estado = '',
    _email = '',
    _password = '•••••••••••••',
    _temp;

bool _bandera = true;

class PerfilCiudadano extends StatefulWidget {
  PerfilCiudadano({Key key}) : super(key: key);

  @override
  _PerfilCiudadanoState createState() => _PerfilCiudadanoState();
}

class _PerfilCiudadanoState extends State<PerfilCiudadano> {
  @override
  Widget build(BuildContext context) {
    if (_bandera) _recuperarCiudadanos();
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
                        _elementoCard('Edad', _edad),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(),
                ButtonTheme(
                  height: 45.0,
                  child: RaisedButton(
                    child: Text(
                      'Actualizar datos',
                      style: TextStyle(fontSize: 17),
                    ),
                    color: Color(0xffd8a500),
                    textColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    onPressed: () {
                      setState(() {
                        _bandera = true;
                      });
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
      ),
    );
  }

  Future<String> _recuperarCiudadanos() async {
    log("holis");
    var url = 'http://192.168.0.26:8080/appCiudadano/ciudadanos';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      _bandera = false;
      jsonResponse = convert.jsonDecode(response.body);
      _obtenerEdad(DateTime.parse(jsonResponse[0]['fecha_nacimiento']));
      _nombre = jsonResponse[0]['nombre'];
      _apellido_paterno = jsonResponse[0]['apellido_paterno'];
      _apellido_materno = jsonResponse[0]['apellido_materno'];
      _calle_numero = jsonResponse[0]['calle_numero'];
      _colonia = jsonResponse[0]['colonia'];
      _cp = jsonResponse[0]['cp'];
      _alcaldia_municipio = jsonResponse[0]['alcaldia_municipio'];
      _estado = jsonResponse[0]['estado'];
      _email = jsonResponse[0]['email'];
      setState(() {});
      return "Correcto";
    } else {
      log('${response.statusCode}');
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
                  _mostrarAlertaTips(context, _campo);
                });
              },
            )),
          ],
        ),
      ],
    );
  }

  void _obtenerEdad(DateTime fechaNacimiento) {
    DateTime now = new DateTime.now();
    var years = now.year - fechaNacimiento.year;
    var months = now.month - fechaNacimiento.month;
    var days = now.day - fechaNacimiento.day;

    if (months < 0 || (months == 0 && days < 0)) {
      years--;
      months += (days < 0 ? 11 : 12);
    }

    if (days < 0) {
      final monthAgo =
          new DateTime(now.year, now.month - 1, fechaNacimiento.day);
      days = now.difference(monthAgo).inDays + 1;
    }

    _edad = years.toString();
  }

  void _mostrarAlertaTips(BuildContext context, String campo) {
    log(campo);
    if (campo == "Edad")
      showDatePicker(
              context: context,
              initialDate: DateTime(1980),
              firstDate: DateTime(1910),
              lastDate: DateTime.now())
          .then((fecha) {
        log(fecha.day.toString() +
            fecha.month.toString() +
            fecha.year.toString());
        setState(() {
          _obtenerEdad(fecha);
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
                    maxLength: 10,
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      hintText: campo,
                    ),
                    //labelText: 'holisx2'),
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
}
