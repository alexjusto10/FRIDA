import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginBrigadista extends StatefulWidget {
  @override
  _LoginBrigadistaState createState() => _LoginBrigadistaState();
}

class _LoginBrigadistaState extends State<LoginBrigadista> {
  String _password = '';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
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
                SizedBox(height: 20.0,), 
                _crearPassword(),
                SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                    child:Container(
                        padding: EdgeInsets.only(left: 3.0),
                        child:ButtonTheme(
                          height: 45.0,
                          child:  RaisedButton(
                            child: Text(
                              'Iniciar sesión',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black
                              ),
                            ),
                            color: Color(0xffffd54f),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            onPressed: () {Navigator.pushNamed(context, 'home_brigadista');},
                          )
                        )
                      ),
                    ),
                  ],
                )
              ],
            )
          ),
        ),
      ),
    );
  }

  Widget _crearEmail() {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        hintText: 'Introduce tu usuario',
        labelText: 'Usuario',
        suffixIcon: Icon(Icons.person),
      ),
    );
  }

  Widget _crearPassword() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        counter: Text('Letras ${_password.length}'),
        hintText: 'Introduce tu contraseña',
        labelText: 'Contraseña',
        helperText: '8 caracteres mínimo',
        suffixIcon: Icon(Icons.lock),
      ),
      onChanged: (valor){
        setState(() {
          _password = valor;
        });
      },
    );
  }
}