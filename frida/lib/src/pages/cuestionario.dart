import 'package:flutter/material.dart';

enum SingingCharacter { calle, casa, edificio, critico }

class Cuestionario extends StatefulWidget {
  Cuestionario({Key key}) : super(key: key);

  @override
  _CuestionarioState createState() => _CuestionarioState();
}

class _CuestionarioState extends State<Cuestionario> {
  SingingCharacter _character = SingingCharacter.calle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Cuestionario',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blue,
        ),
        body: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 20.0,
            ),
            children: <Widget>[
              Wrap(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 2.0, top: 5.0),
                    width: (MediaQuery.of(context).size.width - 74) / 7,
                    height: 5.0,
                    decoration: BoxDecoration(
                        color: Colors.blue[700], shape: BoxShape.rectangle),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 2.0, top: 5.0),
                    width: (MediaQuery.of(context).size.width - 74) / 7,
                    height: 5.0,
                    decoration: BoxDecoration(
                        color: Colors.blue[700], shape: BoxShape.rectangle),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 2.0, top: 5.0),
                    width: (MediaQuery.of(context).size.width - 74) / 7,
                    height: 5.0,
                    decoration: BoxDecoration(
                        color: Colors.grey, shape: BoxShape.rectangle),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 2.0, top: 5.0),
                    width: (MediaQuery.of(context).size.width - 74) / 7,
                    height: 5.0,
                    decoration: BoxDecoration(
                        color: Colors.grey, shape: BoxShape.rectangle),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 2.0, top: 5.0),
                    width: (MediaQuery.of(context).size.width - 74) / 7,
                    height: 5.0,
                    decoration: BoxDecoration(
                        color: Colors.grey, shape: BoxShape.rectangle),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 2.0, top: 5.0),
                    width: (MediaQuery.of(context).size.width - 74) / 7,
                    height: 5.0,
                    decoration: BoxDecoration(
                        color: Colors.grey, shape: BoxShape.rectangle),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 2.0, top: 5.0),
                    width: (MediaQuery.of(context).size.width - 74) / 7,
                    height: 5.0,
                    decoration: BoxDecoration(
                        color: Colors.grey, shape: BoxShape.rectangle),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 2.0, top: 5.0),
                    width: (MediaQuery.of(context).size.width - 74) / 7,
                    height: 5.0,
                    decoration: BoxDecoration(
                        color: Colors.grey, shape: BoxShape.rectangle),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 2.0, top: 5.0),
                    width: (MediaQuery.of(context).size.width - 74) / 7,
                    height: 5.0,
                    decoration: BoxDecoration(
                        color: Colors.grey, shape: BoxShape.rectangle),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 2.0, top: 5.0),
                    width: (MediaQuery.of(context).size.width - 74) / 7,
                    height: 5.0,
                    decoration: BoxDecoration(
                        color: Colors.grey, shape: BoxShape.rectangle),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 2.0, top: 5.0),
                    width: (MediaQuery.of(context).size.width - 74) / 7,
                    height: 5.0,
                    decoration: BoxDecoration(
                        color: Colors.grey, shape: BoxShape.rectangle),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 2.0, top: 5.0),
                    width: (MediaQuery.of(context).size.width - 74) / 7,
                    height: 5.0,
                    decoration: BoxDecoration(
                        color: Colors.grey, shape: BoxShape.rectangle),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 2.0, top: 5.0),
                    width: (MediaQuery.of(context).size.width - 74) / 7,
                    height: 5.0,
                    decoration: BoxDecoration(
                        color: Colors.grey, shape: BoxShape.rectangle),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 2.0, top: 5.0),
                    width: (MediaQuery.of(context).size.width - 74) / 7,
                    height: 5.0,
                    decoration: BoxDecoration(
                        color: Colors.grey, shape: BoxShape.rectangle),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Container(
                        alignment: Alignment.center,
                        width: 75.0,
                        height: 75.0,
                        decoration: BoxDecoration(
                            color: Colors.blue[700], shape: BoxShape.circle),
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
                          'La grieta se encuentra en:',
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
                    title: Text('Calle o acera'),
                    leading: Radio(
                      activeColor: Colors.blue[700],
                      value: SingingCharacter.calle,
                      groupValue: _character,
                      onChanged: (SingingCharacter value) {
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                  ),
                  Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.all(10.0),
                    title: Text('Casa o edificio con 2 pisos o menos'),
                    leading: Radio(
                      activeColor: Colors.blue[700],
                      value: SingingCharacter.casa,
                      groupValue: _character,
                      onChanged: (SingingCharacter value) {
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                  ),
                  Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.all(10.0),
                    title: Text('Edificio con 3 o más pisos'),
                    leading: Radio(
                      activeColor: Colors.blue[700],
                      value: SingingCharacter.edificio,
                      groupValue: _character,
                      onChanged: (SingingCharacter value) {
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                  ),
                  Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.all(10.0),
                    title: Text(
                        'Edificio de situación crítica (hospital, orfanato, asilo, etc.)'),
                    leading: Radio(
                      activeColor: Colors.blue[700],
                      value: SingingCharacter.critico,
                      groupValue: _character,
                      onChanged: (SingingCharacter value) {
                        setState(() {
                          _character = value;
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
                            borderRadius: BorderRadius.circular(10.0)),
                        onPressed: () {},
                      )),
                ],
              ),
            ]));
  }
}
