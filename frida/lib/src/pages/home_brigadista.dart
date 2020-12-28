import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:android_intent/android_intent.dart';

class HomeBrigadista extends StatefulWidget {
  @override
  _HomeBrigadistaState createState() => _HomeBrigadistaState();
}

class _HomeBrigadistaState extends State<HomeBrigadista> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Caso asignado',
          style: TextStyle(
            fontSize: 25.0,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_location),
            onPressed: () {
              Navigator.pushNamed(context, 'centro_acopio_brigadista');
            },
          )
        ],
        leading: Container(),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text('Información del inmueble',
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left),
          ),
          _cardTipo1(),
          SizedBox(
            height: 5.0,
          ),
          _mapas(),
          SizedBox(
            height: 20.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text('Fotos del inmueble',
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left),
          ),
          _cardContainer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(),
              ButtonTheme(
                height: 45.0,
                child: RaisedButton(
                  child: Text(
                    'Confirmar evaluación',
                    style: TextStyle(fontSize: 17),
                  ),
                  color: Color(0xffd8a500),
                  textColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  onPressed: _actualizarMapa,
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

  Widget _cardTipo1() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.error,
                color: Colors.red,
                size: 40.0,
              ),
              title: Text(
                'Daño de prioridad alta.',
                style: TextStyle(fontSize: 20.0),
              ),
              subtitle: Text(
                'Eje Central Lázaro Cárdenas S/N, Tlatelolco, Cuauhtémoc, 06900 Ciudad de México, CDMX',
                style: TextStyle(fontSize: 15.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardTipo2(String url) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      alignment: Alignment.topCenter,
      child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
          child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: FadeInImage(
                  image: NetworkImage(url),
                  placeholder: AssetImage('assets/original.gif'),
                  fadeInDuration: Duration(milliseconds: 200),
                  fit: BoxFit.fitWidth,
                ),
              ))),
    );
  }

  Widget _cardContainer() {
    return Column(
      children: <Widget>[
        _cardTipo2(
            'https://www.animalpolitico.com/wp-content/uploads/2014/04/Danos_Colonia_Doctores-2.jpg'),
        _cardTipo2(
            'https://www.unionedomex.mx/sites/default/files/styles/galeria/public/field/image/grietasedomex.jpg'),
        _cardTipo2(
            'https://www.greentv.com.mx/wp-content/uploads/2017/09/CAP-QUE-2017-09-22_23-2.jpg')
      ],
    );
  }

  CameraPosition _initialPosition =
      CameraPosition(target: LatLng(19.4516892, -99.1375919), zoom: 15.0);
  GoogleMapController _controller;
  final Set<Marker> _markers = Set();

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  Widget _mapas() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
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
                )),
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ],
    );
  }

  void _actualizarMapa() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('Tlatelolco'),
          position: LatLng(19.4516892, -99.1375919),
        ),
      );
    });
  }
}
