import 'package:flutter/material.dart';

class ModificarMensaje extends StatefulWidget {
  ModificarMensaje({Key key}) : super(key: key);

  @override
  _ModificarMensajeState createState() => _ModificarMensajeState();
}

class _ModificarMensajeState extends State<ModificarMensaje> {
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
                        'Mensaje no hay peligro',
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
                                'Me encuentro bien, no te preocupes.',
                                style: TextStyle(fontSize: 17),
                              )),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {},
                              )
                            ],
                          )
                          /*Divider(),
                        Column(
                          children: <Widget>[
                            CheckboxListTile(title: Text('¿Notificar a Padre?'), onChanged: (value) {}, value: true,),
                            CheckboxListTile(title: Text('¿Notificar a Madre?'), onChanged: (value) {}, value: false,),
                            CheckboxListTile(title: Text('¿Notificar a Tío?'), onChanged: (value) {}, value: false,),
                          ],
                        )*/
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
                        'Mensaje estoy en peligro',
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
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                  'Necesito ayuda, me encuentro en: [dirección actual] [coordenadas actuales].',
                                  style: TextStyle(fontSize: 17),
                                )),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {},
                                )
                              ],
                            ),
                            /*Divider(),
                        Column(
                          children: <Widget>[
                            CheckboxListTile(title: Text('¿Incluir coordenadas?'), onChanged: (value) {}, value: true,),
                            CheckboxListTile(title: Text('¿Notificar a Padre?'), onChanged: (value) {}, value: true,),
                            CheckboxListTile(title: Text('¿Notificar a Madre?'), onChanged: (value) {}, value: true,),
                            CheckboxListTile(title: Text('¿Notificar a Tío?'), onChanged: (value) {}, value: true,),
                          ],
                        )*/
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
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
