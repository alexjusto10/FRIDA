import 'package:flutter/material.dart';

class PerfilCiudadano extends StatefulWidget {
  PerfilCiudadano({Key key}) : super(key: key);

  @override
  _PerfilCiudadanoState createState() => _PerfilCiudadanoState();
}

class _PerfilCiudadanoState extends State<PerfilCiudadano> {
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              elevation: 5.0,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.person, color: Color(0xffd8a500),),
                    title: Text('Datos personales',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 20.0,left: 20.0,right: 20.0),
                    child: Column(
                      children: <Widget>[
                        _elementoCard('Nombre(s)', 'Jaime Alejandro'),
                        Divider(),
                        _elementoCard('Apellido Paterno', 'Justo'),
                        Divider(),
                        _elementoCard('Apellido Materno', 'Vizcarra'),
                        Divider(),
                        _elementoCard('Edad', '22'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              elevation: 5.0,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.home, color: Color(0xffd8a500),),
                    title: Text('Domicilio',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 20.0,left: 20.0,right: 20.0),
                    child: Column(
                      children: <Widget>[
                        _elementoCard('Calle y número', 'Emiliano Zapata #39'),
                        Divider(),
                        _elementoCard('Colonia', 'San Juan Ixhuatepec'),
                        Divider(),
                        _elementoCard('Código Postal', '54180'),
                        Divider(),
                        _elementoCard('Alcaldía o Municipio', 'Tlalnepantal de Baz'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              elevation: 5.0,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.email, color: Color(0xffd8a500),),
                    title: Text('Credenciales de acceso',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 20.0,left: 20.0,right: 20.0),
                    child: Column(
                      children: <Widget>[
                        _elementoCard('Correo', 'alejandrojusto.isc@gmail.com'),
                        Divider(),
                        _elementoCard('Contraseña', '•••••••••••••'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(),
                ButtonTheme(
                  height: 45.0,
                  child:  RaisedButton(
                    child: Text('Actualizar datos',style: TextStyle(fontSize: 17),),
                    color: Color(0xffd8a500),
                    textColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    onPressed: () {
                    },
                  ),
                )
              ],
            ),
            SizedBox(height: 10.0,),
          ],
        ),
      ),
    );
  }

  Widget _elementoCard(String _campo, String _valor){
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_campo,style: TextStyle(fontSize: 17,color: Colors.black87)),
                Text(_valor,style: TextStyle(fontSize: 16,color: Colors.black54)),
              ],
            ),
            Container(
              child: IconButton(icon: Icon(Icons.edit),onPressed:(){},)
            ),
          ],
        ),
      ],
    );
  }
}