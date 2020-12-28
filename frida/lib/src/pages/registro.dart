import 'package:flutter/material.dart';

class Registro extends StatefulWidget {
  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  String _nombre = '';
  String _email = '';
  String _password = '';
  String _fecha = '';

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
                  onPressed: () {
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
              _nombre = valor;
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
            labelText: 'Código Postal',
          )),
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
        ));
  }

  Widget _crearPassword(String _nombreCampo, String _pista, String _ayuda) {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: TextField(
          obscureText: true,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              //counter: Text('Letras ${_password.length}'),
              hintText: _pista,
              labelText: _nombreCampo,
              helperText: _ayuda,
              suffixIcon: Icon(Icons.lock)),
          onChanged: (valor) {
            setState(() {
              _password = valor;
            });
          },
        ));
  }

  void _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1930),
        lastDate: new DateTime.now(),
        locale: Locale('es', 'ES'));
    if (picked != null) {
      setState(() {
        _fecha = picked.day.toString() +
            '/' +
            picked.month.toString() +
            '/' +
            picked.year.toString();
        _inputFieldDateController.text = _fecha;
      });
    }
  }
}
