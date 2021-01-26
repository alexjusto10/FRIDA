import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Registro extends StatefulWidget {
  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  String _nombre = '',
      _apellido_paterno = '',
      _apellido_materno = '',
      _calle_numero = '',
      _colonia = '',
      _cp = '',
      _alcaldia_municipio = '',
      _estado = '',
      _email = '',
      _password = '',
      _passwordConfirmacion = '',
      _fecha = '',
      _contacto1,
      _contacto2,
      _contacto3;
  final String _recordarTelefono1 = "recordarTelefono1",
      _recordarTelefono2 = "recordarTelefono2",
      _recordarTelefono3 = "recordarTelefono3";

  TextEditingController _inputFieldDateController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10.0,
        ),
        children: <Widget>[
          Card(
            elevation: 2.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              children: <Widget>[
                const ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Color(0xffd8a500),
                  ),
                  title: Text(
                    'Datos personales',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                  ),
                ),
                _crearCampoTexto('Nombre', 'Introduce tu nombre'),
                _crearCampoTexto(
                    'Apellido Paterno', 'Introduce tu apellido paterno'),
                _crearCampoTexto(
                    'Apellido Materno', 'Introduce tu apellido materno'),
                _crearFecha(context),
              ],
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Card(
            elevation: 2.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              children: <Widget>[
                const ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Color(0xffd8a500),
                  ),
                  title: Text(
                    'Domicilio',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                  ),
                ),
                _crearCampoTexto(
                    'Calle y número', 'Introduce tu calle y número'),
                _crearCampoTexto('Colonia', 'Introduce tu colonia'),
                _crearCodigoPostal(),
                _crearCampoTexto('Alcaldía o municipio',
                    'Introduce tu alcaldía o municipio'),
                _crearCampoTexto('Estado', 'Introduce tu estado'),
              ],
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Card(
            elevation: 2.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              children: <Widget>[
                const ListTile(
                  leading: Icon(
                    Icons.person_add,
                    color: Color(0xffd8a500),
                  ),
                  title: Text(
                    'Contactos de confianza',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                  ),
                ),
                _crearCampoTexto('Contacto No.1',
                    'Introduce el teléfono del contacto de confianza'),
                _crearCampoTexto('Contacto No.2',
                    'Introduce el teléfono del contacto de confianza'),
                _crearCampoTexto('Contacto No.3',
                    'Introduce el teléfono del contacto de confianza'),
              ],
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Card(
            elevation: 2.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              children: <Widget>[
                const ListTile(
                  leading: Icon(
                    Icons.email,
                    color: Color(0xffd8a500),
                  ),
                  title: Text(
                    'Credenciales',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                  ),
                ),
                _crearEmail(),
                _crearPassword('Contraseña', 'Introduce tu contraseña',
                    '8 caracteres mínimo'),
                _crearPassword('Confirma tu contraseña',
                    'Introduce de nuevo tu contraseña', ''),
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
                    'Completar Registro',
                    style: TextStyle(fontSize: 17),
                  ),
                  color: Color(0xffd8a500),
                  textColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  onPressed: () async {
                    await crearCiudadano();
                    Navigator.of(context).pop();
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
    );
  }

  Widget _crearCampoTexto(String _nombreCampo, String _pista) {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: TextField(
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              hintText: _pista,
              labelText: _nombreCampo),
          onChanged: (valor) {
            setState(() {
              switch (_nombreCampo) {
                case "Nombre":
                  _nombre = valor;
                  break;
                case "Apellido Paterno":
                  _apellido_paterno = valor;
                  break;
                case "Apellido Materno":
                  _apellido_materno = valor;
                  break;
                case "Calle y número":
                  _calle_numero = valor;
                  break;
                case "Colonia":
                  _colonia = valor;
                  break;
                case "Alcaldía o municipio":
                  _alcaldia_municipio = valor;
                  break;
                case "Estado":
                  _estado = valor;
                  break;
                case "Contacto No.1":
                  _contacto1 = valor;
                  break;
                case "Contacto No.2":
                  _contacto2 = valor;
                  break;
                case "Contacto No.3":
                  _contacto3 = valor;
                  break;
              }
            });
          },
        ));
  }

  Widget _crearFecha(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: TextField(
        enableInteractiveSelection: false,
        controller: _inputFieldDateController,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            hintText: 'Introduce tu fecha de nacimiento',
            labelText: 'Fecha de nacimiento',
            suffixIcon: Icon(Icons.calendar_today)),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDate(context);
        },
        onChanged: (valor) {
          setState(() {
            _fecha = valor;
          });
        },
      ),
    );
  }

  Widget _crearCodigoPostal() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            hintText: 'Introduce el código postal',
            labelText: 'Código Postal'),
        onChanged: (valor) {
          setState(() {
            _cp = valor;
          });
        },
      ),
    );
  }

  Widget _crearEmail() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            hintText: 'Introduce tu correo electrónico',
            labelText: 'Correo electrónico',
            suffixIcon: Icon(Icons.alternate_email)),
        onChanged: (valor) {
          setState(() {
            _email = valor;
          });
        },
      ),
    );
  }

  Widget _crearPassword(String _nombreCampo, String _pista, String _ayuda) {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: TextField(
          obscureText: true,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              hintText: _pista,
              labelText: _nombreCampo,
              helperText: _ayuda,
              suffixIcon: Icon(Icons.lock)),
          onChanged: (valor) {
            setState(() {
              if (_nombreCampo == 'Contraseña')
                _password = valor;
              else
                _passwordConfirmacion = valor;
            });
          },
        ));
  }

  void _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1910),
        lastDate: new DateTime.now(),
        locale: Locale('es', 'ES'));
    if (picked != null) {
      setState(() {
        _fecha = picked.year.toString();
        if (picked.month.toString().length == 1)
          _fecha = _fecha + "-0" + picked.month.toString();
        else
          _fecha = _fecha + "-" + picked.month.toString();

        if (picked.day.toString().length == 1)
          _fecha = _fecha + "-0" + picked.day.toString();
        else
          _fecha = _fecha + "-" + picked.day.toString();
        _inputFieldDateController.text = _fecha;
      });
    }
  }

  Future crearCiudadano() async {
    final String url = "http://13.84.215.39:8080/nuevo/ciudadano";
    final response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: convert.jsonEncode(
          {
            "nombre": _nombre,
            "apellido_paterno": _apellido_paterno,
            "apellido_materno": _apellido_materno,
            "nombreUsuario": _email,
            "email": _email,
            "password": _password,
            "roles": ["ciudadano"],
            "fecha_nacimiento": _fecha,
            "calle_numero": _calle_numero,
            "colonia": _colonia,
            "cp": _cp,
            "alcaldia_municipio": _alcaldia_municipio,
            "estado": _estado,
            "id_recomendacion": "1"
          },
        ));
    if (response.statusCode == 201) {
      Fluttertoast.showToast(
          msg: 'El registro se realizó correctamente',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
      _recordarContactos();
    }
  }

  Future<void> _recordarContactos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_recordarTelefono1, _contacto1);
    prefs.setString(_recordarTelefono2, _contacto2);
    prefs.setString(_recordarTelefono3, _contacto3);
  }
}
