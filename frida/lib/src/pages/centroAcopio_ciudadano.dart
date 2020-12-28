
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CentroAcopioCiudadano extends StatefulWidget {
  @override
  _CentroAcopioCiudadanoState createState() => _CentroAcopioCiudadanoState();
}

class _CentroAcopioCiudadanoState extends State<CentroAcopioCiudadano> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Centro de acopio (Ciudadano)'),
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
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                        hintText: 'Introduce el domicilio a buscar',
                        labelText: 'Domicilio del centro a buscar',
                        suffixIcon: Icon(Icons.location_on)
                      ),
                    ),
                  ),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10.0),
                                child: Text('Artículos requeridos',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                              ),
                              Container(
                                padding: EdgeInsets.all(10.0),
                                child: Text('Cantidad solicitada',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                              )
                            ],
                          ),
                          Divider(),
                          _articulos('Agua embotellada', '60 piezas'),
                          Divider(),
                          _articulos('Bolsas de arroz', '92 piezas'),
                          Divider(),
                          _articulos('Bolsas de lentejas', '87 piezas'),
                          Divider(),
                          _articulos('Latas de atún', '34 piezas'),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 5.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10.0),
                                child: Text('Artículos suficientes',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                          Divider(),
                          _articulos('Aceite', ''),
                          Divider(),
                          _articulos('Alimento para bebé', ''),
                          Divider(),
                          _articulos('Sábanas y cobijas', ''),
                        ],
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

  Widget _articulos(String _articulo, String _cantidad){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          child: Text(_articulo,style: TextStyle(fontSize: 16),),
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          child: Text(_cantidad,style: TextStyle(fontSize: 16),),
        )
      ],
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
          height: 200.0,
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
}