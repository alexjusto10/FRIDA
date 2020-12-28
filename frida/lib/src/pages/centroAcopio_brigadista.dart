
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CentroAcopioBrigadista extends StatefulWidget {
  @override
  _CentroAcopioBrigadistaState createState() => _CentroAcopioBrigadistaState();
}

class _CentroAcopioBrigadistaState extends State<CentroAcopioBrigadista> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Centro de acopio (Brigadista)'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 10.0
        ),
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)
            ),
            elevation: 5.0,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top:10.0,left:10.0,right:10.0),
                    child: Text(
                      'Mapa de centros de acopio cercanos',
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top:10.0,right:10.0,left:10.0),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                            hintText: 'Introduce el domicilio a buscar',
                            labelText: 'Domicilio del centro a buscar',
                            suffixIcon: Icon(Icons.location_on)
                          ),
                        ),
                        SizedBox(height: 5.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ButtonTheme(
                              height: 45.0,
                              child:  RaisedButton(
                                child: Text('Buscar',style: TextStyle(fontSize: 17),),
                                color: Color(0xffffd54f),
                                textColor: Colors.black,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                onPressed: _actualizarMapa,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  _mapas(),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.0,),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)
            ),
            elevation: 5.0,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Centro de acopio seleccionado:',
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                    subtitle: Text(
                      'Eje Central Lázaro Cárdenas S/N, Tlatelolco, Cuauhtémoc, 06900 Ciudad de México, CDMX',
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 5.0,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            GridView.count(
                              shrinkWrap: true,
                              childAspectRatio: MediaQuery.of(context).size.width /(MediaQuery.of(context).size.height / 5),
                              crossAxisCount: 3,
                              children: <Widget>[
                                Text('Artículos',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                Text('Cantidad actual',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                Text('Cantidad necesaria',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Text('Agua embotellada'),
                                    ],
                                  ),
                                ),
                                _articulos('40'),
                                _articulos('100'),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Text('Bolsas de arroz'),
                                    ],
                                  ),
                                ),
                                _articulos('8'),
                                _articulos('100'),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Text('Bolsas de lentejas'),
                                    ],
                                  ),
                                ),
                                _articulos('13'),
                                _articulos('100'),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Text('Latas de atún'),
                                    ],
                                  ),
                                ),
                                _articulos('16'),
                                _articulos('50'),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Text('Aceite'),
                                    ],
                                  ),
                                ),
                                _articulos('68'),
                                _articulos('50'),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Text('Alimento para bebé'),
                                    ],
                                  ),
                                ),
                                _articulos('116'),
                                _articulos('100'),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Text('Sábanas y cobijas'),
                                    ],
                                  ),
                                ),
                                _articulos('70'),
                                _articulos('91'),
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Añadir nuevo artículo',style: TextStyle(fontSize: 17),),
                                SizedBox(width: 10.0,),
                                IconButton(icon: Icon(Icons.add_box),onPressed: () {_mostrarAlerta(context);},),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),   
            ),
          ),
          SizedBox(height: 10.0,),
        ],
      ),
    );
  }

  Widget _articulos(String _cantidad){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(_cantidad),
          IconButton(icon: Icon(Icons.edit), onPressed: () {},)
        ],
      ),
    );
  }

  CameraPosition _initialPosition = CameraPosition(target: LatLng(19.4516892,-99.1375919),zoom: 15.0);
  GoogleMapController _controller;
  final Set<Marker> _markers = Set();

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  Widget _mapas() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0,),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.transparent,
          ),
          height: 250.0,
          alignment: Alignment.center,
          child: ClipRRect(
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: <Widget>[
                  GoogleMap(    
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: _initialPosition,
                    markers: _markers,
                  ),
                ],
              )
            ),
            borderRadius:BorderRadius.circular(20.0),
          ),
        ),
      ],
    );
  }

  void _actualizarMapa(){
    setState(() {
      _markers.add(
        Marker(
            markerId: MarkerId('Tlatelolco'),
            position: LatLng(19.4516892,-99.1375919),
        ),
      );
    });
  }

  void _mostrarAlerta(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
          ),
          title: Text('Agregar artículo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    hintText: 'Introduce el nombre del artículo a añadir',
                    labelText: 'Nombre del artículo',
                    suffixIcon: Icon(Icons.font_download)
                  ),
                ),
                SizedBox(height: 10.0,),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    hintText: 'Introduce la cantidad actual',
                    labelText: 'Cantidad actual',
                    suffixIcon: Icon(Icons.check)
                  ),
                ),
                SizedBox(height: 10.0,),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    hintText: 'Introduce la cantidad necesaria',
                    labelText: 'Cantidad necesaria',
                    suffixIcon: Icon(Icons.priority_high)
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ButtonTheme(
              height: 45.0,
              child:  RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                color: Color(0xffd8a500),
                child: Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            ButtonTheme(
              height: 45.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                color: Color(0xffffd54f),
                child:Text('Confirmar'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ),
          ],
        );
      }
    );
  }
}