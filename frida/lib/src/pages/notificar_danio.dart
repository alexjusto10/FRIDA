
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NotificarDanio extends StatefulWidget {
  @override
  _NotificarDanioState createState() => _NotificarDanioState();
}

class _NotificarDanioState extends State<NotificarDanio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reporte de daño'),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top:10.0,left:10.0,right:10.0),
                  child: Text(
                    'Selecciona la ubicación del inmueble.',
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top:10.0,left:10.0,right:10.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      hintText: 'Introduce el domicilio del inmueble afectado',
                      labelText: 'Ubicación',
                      suffixIcon: Icon(Icons.location_on)
                    ),
                  ),
                ),
                _mapas(),
              ],
            ),
          ),
          SizedBox(height: 20.0,),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)
            ),
            elevation: 5.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top:10.0,left:10.0,right:10.0),
                  child: Text(
                    'Añadir fotos del inmueble',
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 130.0,
                        width: 130.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: FadeInImage(
                            image: NetworkImage('https://www.animalpolitico.com/wp-content/uploads/2014/04/Danos_Colonia_Doctores-2.jpg'),
                            placeholder: AssetImage('assets/original.gif'),
                            fadeInDuration: Duration(milliseconds: 200),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 20.0,),
                      Container(
                        height: 130.0,
                        width: 130.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: FadeInImage(
                            image: NetworkImage('https://www.unionedomex.mx/sites/default/files/styles/galeria/public/field/image/grietasedomex.jpg'),
                            placeholder: AssetImage('assets/original.gif'),
                            fadeInDuration: Duration(milliseconds: 200),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 20.0,),
                      Container(
                        height: 130.0,
                        width: 130.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey[300],
                          shape: BoxShape.rectangle,
                        ),
                        child: Icon(Icons.add_box,size: 30.0,),
                      ),
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
                  child: Text('Continuar con el cuestionario',style: TextStyle(fontSize: 17),),
                  color: Color(0xffd8a500),
                  textColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  onPressed:() {Navigator.pushNamed(context, 'cuestionario');},
                  onLongPress: _actualizarMapa,
                ),
              )
            ],
          ),
          SizedBox(height: 10.0,),
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
}